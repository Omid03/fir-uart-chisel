import chisel3._
import chisel3.util._

class Top(frequency: Int, baudRate: Int, weights: Seq[Int]) extends Module {
  val io = IO(new Bundle {
    val firIn = DeqIO(SInt(16.W))
    val txd = Output(UInt(1.W))
  })

  val fir = Module(new FIR(weights))
  val tx = Module(new BufferedTx(frequency, baudRate))

  fir.io.in <> io.firIn
  io.txd := tx.io.txd

  val sIdle :: sSendBytes :: Nil = Enum(2)
  val state = RegInit(sIdle)

  val dataReg = RegInit(0.U(32.W))
  val byteCnt = RegInit(0.U(3.W))

  fir.io.out.ready := (state === sIdle)
  tx.io.channel.valid := (state === sSendBytes)

  tx.io.channel.bits := dataReg(7, 0)

  switch(state) {
    is(sIdle) {
      when(fir.io.out.valid) {
        dataReg := fir.io.out.bits.asUInt
        byteCnt := 3.U
        state := sSendBytes
      }
    }
    is(sSendBytes) {
      when(tx.io.channel.ready) {
        dataReg := dataReg >> 8
        byteCnt := byteCnt - 1.U

        when(byteCnt === 0.U) {
          state := sIdle
        }
      }
    }
  }
}

object TopMaker extends App {
  val weights = Seq(1, 2, 3)
  (new chisel3.stage.ChiselStage).emitVerilog(
    new Top(50000000, 115200, weights),
    Array("--target-dir", "Verilog/Top")
  )
}