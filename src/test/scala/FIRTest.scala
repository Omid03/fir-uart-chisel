import chisel3.iotesters._

class FIRTest(c: FIR) extends PeekPokeTester(c) {

  poke(c.io.in.valid, 0)
  poke(c.io.out.ready, 1)

  step(1)
  def sendAndVerify(dataIn: Int, expectedOut: Int): Unit = {
    poke(c.io.in.bits, dataIn)
    poke(c.io.in.valid, 1)

    while (peek(c.io.in.ready) == 0) {
      step(1)
    }
    step(1)
    poke(c.io.in.valid, 0)

    while (peek(c.io.out.valid) == 0) {
      step(1)
    }

    expect(c.io.out.bits, expectedOut)
    step(1)
  }

  sendAndVerify(10, 10)
  sendAndVerify(20, 40)
  sendAndVerify(30, 100)
}

object FIRTestApp extends App {
  val weights = Seq(1, 2, 3)
  Driver.execute(Array("--generate-vcd-output", "on"), () => new FIR(weights)) {
    c => new FIRTest(c)
  }
}