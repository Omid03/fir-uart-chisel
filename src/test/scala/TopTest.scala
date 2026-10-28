import chisel3.iotesters._

class TopTest(c: Top) extends PeekPokeTester(c) {
  val bitCnt = 10

  poke(c.io.firIn.valid, 0)
  step(1)

  def receiveByte(): Int = {
    // انتظار برای بیت Start
    while(peek(c.io.txd) == 1) { step(1) }
    expect(c.io.txd, 0)
    step(bitCnt)

    var receivedByte = 0
    for (i <- 0 until 8) {
      val bit = peek(c.io.txd).toInt
      receivedByte = receivedByte | (bit << i)
      step(bitCnt)
    }

    expect(c.io.txd, 1)
    step(bitCnt)

    receivedByte
  }

  poke(c.io.firIn.bits, 10)
  poke(c.io.firIn.valid, 1)
  while (peek(c.io.firIn.ready) == 0) {
    step(1)
  }
  step(1)
  poke(c.io.firIn.valid, 0)

  println("Waiting for UART transmission to complete...")
  val byte1 = receiveByte()
  val byte2 = receiveByte()
  val byte3 = receiveByte()
  val byte4 = receiveByte()

  val finalResult = byte1 | (byte2 << 8) | (byte3 << 16) | (byte4 << 24)

  println(s"Received Bytes: [0x${byte1.toHexString}, 0x${byte2.toHexString}, 0x${byte3.toHexString}, 0x${byte4.toHexString}]")
  println(s"Reconstructed 32-bit Value: $finalResult")

  assert(finalResult == 10, s"Expected 10 but got $finalResult")
}

object TopTestApp extends App {
  val weights = Seq(1, 2, 3)
  Driver.execute(Array("--generate-vcd-output", "on"), () => new Top(10000, 1000, weights)) {
    c => new TopTest(c)
  }
}