import chisel3.iotesters._

class UARTTest(c: BufferedTx) extends PeekPokeTester(c) {
  val bitCnt = 10

  poke(c.io.channel.valid, 0)
  step(1)

  val dataToSend = 0x55
  poke(c.io.channel.bits, dataToSend)
  poke(c.io.channel.valid, 1)

  while(peek(c.io.channel.ready) == 0) {
    step(1)
  }
  step(1)
  poke(c.io.channel.valid, 0)

  while(peek(c.io.txd) == 1) {
    step(1)
  }
  expect(c.io.txd, 0)
  step(bitCnt)

  for (i <- 0 until 8) {
    val expectedBit = (dataToSend >> i) & 1
    expect(c.io.txd, expectedBit)
    step(bitCnt)
  }
  expect(c.io.txd, 1)
  step(bitCnt)

  println(s"Successfully transmitted byte: 0x${dataToSend.toHexString}")
}

object UARTTestApp extends App {
  Driver.execute(Array("--generate-vcd-output", "on"), () => new BufferedTx(10000, 1000)) {
    c => new UARTTest(c)
  }
}