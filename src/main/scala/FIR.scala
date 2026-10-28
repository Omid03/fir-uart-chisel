import chisel3._
import chisel3.util._

class FIR(val weights: Seq[Int]) extends Module {
  val io = IO(new Bundle {
    val in = DeqIO(SInt(16.W))
    val out = EnqIO(SInt(32.W))
  })

  val numTaps = weights.length
  val sIdle :: sCompute :: sDone :: Nil = Enum(3)
  val state = RegInit(sIdle)

  val shiftReg = RegInit(VecInit(Seq.fill(numTaps)(0.S(16.W))))

  val acc = RegInit(0.S(32.W))

  val counter = RegInit(0.U(log2Ceil(numTaps).W))

  val weightsWire = VecInit(weights.map(_.S(16.W)))

  io.in.ready := false.B
  io.out.valid := false.B
  io.out.bits := acc

  switch(state) {

    is(sIdle) {
      io.in.ready := true.B
      when(io.in.valid) {
        for (i <- numTaps - 1 to 1 by -1) {
          shiftReg(i) := shiftReg(i - 1)
        }
        shiftReg(0) := io.in.bits

        acc := 0.S
        counter := 0.U
        state := sCompute
      }
    }

    is(sCompute) {
      val currentData = shiftReg(counter)
      val currentWeight = weightsWire(counter)

      acc := acc + (currentData * currentWeight)

      when(counter === (numTaps - 1).U) {
        state := sDone
      } .otherwise {
        counter := counter + 1.U
      }
    }

    is(sDone) {
      io.out.valid := true.B
      when(io.out.ready) {
        state := sIdle
      }
    }
  }
}

object FIRFirrtl extends App {
  val weights = Seq(1, 2, 3)
  (new chisel3.stage.ChiselStage).emitFirrtl(
    new FIR(weights),
    Array("--target-dir", "FIRRTL/FIR")
  )
}

object FIRVerilog extends App {
  val weights = Seq(1, 2, 3)
  (new chisel3.stage.ChiselStage).emitVerilog(
    new FIR(weights),
    Array("--target-dir",
    "Verilog/FIR"))
}