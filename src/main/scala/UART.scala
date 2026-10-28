import chisel3._
import chisel3.util._

class Tx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
    val channel = DeqIO(UInt(8.W))
  })

  val BIT_CNT = ((frequency + baudRate / 2) / baudRate - 1).asUInt

  val shiftReg = RegInit(0x3ff.U)
  val cntReg = RegInit(0.U(20.W))
  val bitsReg = RegInit(0.U(4.W))

  io.channel.ready := (cntReg === 0.U) && (bitsReg === 0.U)
  io.txd := shiftReg(0)

  when(cntReg === 0.U) {
    cntReg := BIT_CNT
    when(bitsReg =/= 0.U) {
      val shift = shiftReg >> 1
      shiftReg := 1.U ## shift(8, 0)
      bitsReg := bitsReg - 1.U
    } .otherwise {
      when(io.channel.valid) {
        shiftReg := 1.U ## io.channel.bits ## 0.U
        bitsReg := 10.U
      } .otherwise {
        shiftReg := 0x3ff.U
      }
    }
  } .otherwise {
    cntReg := cntReg - 1.U
  }
}

class Buffer extends Module {
  val io = IO(new Bundle {
    val in = DeqIO(UInt(8.W))
    val out = EnqIO(UInt(8.W))
  })

  val empty :: full :: Nil = Enum(2)
  val stateReg = RegInit(empty)
  val dataReg = RegInit(0.U(8.W))

  io.in.ready := stateReg === empty
  io.out.valid := stateReg === full

  when(stateReg === empty) {
    when(io.in.valid) {
      dataReg := io.in.bits
      stateReg := full
    }
  } .otherwise {
    when(io.out.ready) {
      stateReg := empty
    }
  }
  io.out.bits := dataReg
}

class BufferedTx(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
    val channel = DeqIO(UInt(8.W))
  })

  val tx = Module(new Tx(frequency, baudRate))
  val buf = Module(new Buffer())

  buf.io.in <> io.channel
  tx.io.channel <> buf.io.out
  io.txd <> tx.io.txd
}

object BufferedTxMaker extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(new BufferedTx(50000000, 115200), Array("--target-dir",
    "Verilog/UART"))
}