circuit BufferedTx :
  module Tx :
    input clock : Clock
    input reset : UInt<1>
    output io_txd : UInt<1>
    output io_channel_ready : UInt<1>
    input io_channel_valid : UInt<1>
    input io_channel_bits : UInt<8>

    reg shiftReg : UInt<10>, clock with :
      reset => (UInt<1>("h0"), shiftReg) @[UART.scala 12:25]
    reg cntReg : UInt<20>, clock with :
      reset => (UInt<1>("h0"), cntReg) @[UART.scala 13:23]
    reg bitsReg : UInt<4>, clock with :
      reset => (UInt<1>("h0"), bitsReg) @[UART.scala 14:24]
    node _T = eq(cntReg, UInt<1>("h0")) @[UART.scala 16:31]
    node _T_1 = eq(bitsReg, UInt<1>("h0")) @[UART.scala 16:52]
    node _T_2 = and(_T, _T_1) @[UART.scala 16:40]
    node _T_3 = bits(shiftReg, 0, 0) @[UART.scala 17:21]
    node _T_4 = eq(cntReg, UInt<1>("h0")) @[UART.scala 19:15]
    node _T_5 = neq(bitsReg, UInt<1>("h0")) @[UART.scala 21:18]
    node _T_6 = shr(shiftReg, 1) @[UART.scala 22:28]
    node _T_7 = bits(_T_6, 8, 0) @[UART.scala 23:31]
    node _T_8 = cat(UInt<1>("h1"), _T_7) @[UART.scala 23:23]
    node _T_9 = sub(bitsReg, UInt<1>("h1")) @[UART.scala 24:26]
    node _T_10 = tail(_T_9, 1) @[UART.scala 24:26]
    node _T_11 = cat(UInt<1>("h1"), io_channel_bits) @[UART.scala 27:25]
    node _T_12 = cat(_T_11, UInt<1>("h0")) @[UART.scala 27:44]
    node _GEN_0 = mux(io_channel_valid, _T_12, UInt<10>("h3ff")) @[UART.scala 26:30 UART.scala 27:18 UART.scala 30:18]
    node _GEN_1 = mux(io_channel_valid, UInt<4>("ha"), bitsReg) @[UART.scala 26:30 UART.scala 28:17 UART.scala 14:24]
    node _GEN_2 = mux(_T_5, _T_8, _GEN_0) @[UART.scala 21:27 UART.scala 23:16]
    node _GEN_3 = mux(_T_5, _T_10, _GEN_1) @[UART.scala 21:27 UART.scala 24:15]
    node _T_13 = sub(cntReg, UInt<1>("h1")) @[UART.scala 34:22]
    node _T_14 = tail(_T_13, 1) @[UART.scala 34:22]
    node _GEN_4 = mux(_T_4, UInt<4>("h9"), _T_14) @[UART.scala 19:24 UART.scala 20:12 UART.scala 34:12]
    node _GEN_5 = mux(_T_4, _GEN_2, shiftReg) @[UART.scala 19:24 UART.scala 12:25]
    node _GEN_6 = mux(_T_4, _GEN_3, bitsReg) @[UART.scala 19:24 UART.scala 14:24]
    io_txd <= _T_3 @[UART.scala 17:10]
    io_channel_ready <= _T_2 @[UART.scala 16:20]
    shiftReg <= mux(reset, UInt<10>("h3ff"), _GEN_5) @[UART.scala 12:25 UART.scala 12:25]
    cntReg <= mux(reset, UInt<20>("h0"), _GEN_4) @[UART.scala 13:23 UART.scala 13:23]
    bitsReg <= mux(reset, UInt<4>("h0"), _GEN_6) @[UART.scala 14:24 UART.scala 14:24]

  module Buffer :
    input clock : Clock
    input reset : UInt<1>
    output io_in_ready : UInt<1>
    input io_in_valid : UInt<1>
    input io_in_bits : UInt<8>
    input io_out_ready : UInt<1>
    output io_out_valid : UInt<1>
    output io_out_bits : UInt<8>

    reg stateReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), stateReg) @[UART.scala 45:25]
    reg dataReg : UInt<8>, clock with :
      reset => (UInt<1>("h0"), dataReg) @[UART.scala 46:24]
    node _T = eq(stateReg, UInt<1>("h0")) @[UART.scala 48:27]
    node _T_1 = eq(stateReg, UInt<1>("h1")) @[UART.scala 49:28]
    node _T_2 = eq(stateReg, UInt<1>("h0")) @[UART.scala 51:17]
    node _GEN_0 = mux(io_in_valid, io_in_bits, dataReg) @[UART.scala 52:23 UART.scala 53:15 UART.scala 46:24]
    node _GEN_1 = mux(io_in_valid, UInt<1>("h1"), stateReg) @[UART.scala 52:23 UART.scala 54:16 UART.scala 45:25]
    node _GEN_2 = mux(io_out_ready, UInt<1>("h0"), stateReg) @[UART.scala 57:24 UART.scala 58:16 UART.scala 45:25]
    node _GEN_3 = mux(_T_2, _GEN_0, dataReg) @[UART.scala 51:28 UART.scala 46:24]
    node _GEN_4 = mux(_T_2, _GEN_1, _GEN_2) @[UART.scala 51:28]
    io_in_ready <= _T @[UART.scala 48:15]
    io_out_valid <= _T_1 @[UART.scala 49:16]
    io_out_bits <= dataReg @[UART.scala 61:15]
    stateReg <= mux(reset, UInt<1>("h0"), _GEN_4) @[UART.scala 45:25 UART.scala 45:25]
    dataReg <= mux(reset, UInt<8>("h0"), _GEN_3) @[UART.scala 46:24 UART.scala 46:24]

  module BufferedTx :
    input clock : Clock
    input reset : UInt<1>
    output io_txd : UInt<1>
    output io_channel_ready : UInt<1>
    input io_channel_valid : UInt<1>
    input io_channel_bits : UInt<8>

    inst tx of Tx @[UART.scala 70:18]
    inst buf of Buffer @[UART.scala 71:19]
    io_txd <= tx.io_txd @[UART.scala 75:10]
    io_channel_ready <= buf.io_in_ready @[UART.scala 73:13]
    tx.clock <= clock
    tx.reset <= reset
    tx.io_channel_valid <= buf.io_out_valid @[UART.scala 74:17]
    tx.io_channel_bits <= buf.io_out_bits @[UART.scala 74:17]
    buf.clock <= clock
    buf.reset <= reset
    buf.io_in_valid <= io_channel_valid @[UART.scala 73:13]
    buf.io_in_bits <= io_channel_bits @[UART.scala 73:13]
    buf.io_out_ready <= tx.io_channel_ready @[UART.scala 74:17]
