circuit Top :
  module FIR :
    input clock : Clock
    input reset : UInt<1>
    output io_in_ready : UInt<1>
    input io_in_valid : UInt<1>
    input io_in_bits : SInt<16>
    input io_out_ready : UInt<1>
    output io_out_valid : UInt<1>
    output io_out_bits : SInt<32>

    reg state : UInt<2>, clock with :
      reset => (UInt<1>("h0"), state) @[FIR.scala 12:22]
    reg shiftReg_0 : SInt<16>, clock with :
      reset => (UInt<1>("h0"), shiftReg_0) @[FIR.scala 14:25]
    reg shiftReg_1 : SInt<16>, clock with :
      reset => (UInt<1>("h0"), shiftReg_1) @[FIR.scala 14:25]
    reg shiftReg_2 : SInt<16>, clock with :
      reset => (UInt<1>("h0"), shiftReg_2) @[FIR.scala 14:25]
    reg acc : SInt<32>, clock with :
      reset => (UInt<1>("h0"), acc) @[FIR.scala 16:20]
    reg counter : UInt<2>, clock with :
      reset => (UInt<1>("h0"), counter) @[FIR.scala 18:24]
    node _T = eq(UInt<2>("h0"), state) @[Conditional.scala 37:30]
    node _GEN_0 = mux(io_in_valid, shiftReg_1, shiftReg_2) @[FIR.scala 30:25 FIR.scala 32:23 FIR.scala 14:25]
    node _GEN_1 = mux(io_in_valid, shiftReg_0, shiftReg_1) @[FIR.scala 30:25 FIR.scala 32:23 FIR.scala 14:25]
    node _GEN_2 = mux(io_in_valid, io_in_bits, shiftReg_0) @[FIR.scala 30:25 FIR.scala 34:21 FIR.scala 14:25]
    node _GEN_3 = mux(io_in_valid, asSInt(UInt<1>("h0")), acc) @[FIR.scala 30:25 FIR.scala 36:13 FIR.scala 16:20]
    node _GEN_4 = mux(io_in_valid, UInt<1>("h0"), counter) @[FIR.scala 30:25 FIR.scala 37:17 FIR.scala 18:24]
    node _GEN_5 = mux(io_in_valid, UInt<2>("h1"), state) @[FIR.scala 30:25 FIR.scala 38:15 FIR.scala 12:22]
    node _T_1 = eq(UInt<2>("h1"), state) @[Conditional.scala 37:30]
    node _GEN_6 = validif(eq(UInt<1>("h0"), counter), shiftReg_0) @[FIR.scala 46:33 FIR.scala 46:33]
    node _GEN_7 = mux(eq(UInt<1>("h1"), counter), shiftReg_1, _GEN_6) @[FIR.scala 46:33 FIR.scala 46:33]
    node _GEN_8 = mux(eq(UInt<2>("h2"), counter), shiftReg_2, _GEN_7) @[FIR.scala 46:33 FIR.scala 46:33]
    node weightsWire_0 = asSInt(UInt<16>("h1")) @[FIR.scala 20:28 FIR.scala 20:28]
    node _GEN_9 = validif(eq(UInt<1>("h0"), counter), weightsWire_0) @[FIR.scala 46:33 FIR.scala 46:33]
    node weightsWire_1 = asSInt(UInt<16>("h2")) @[FIR.scala 20:28 FIR.scala 20:28]
    node _GEN_10 = mux(eq(UInt<1>("h1"), counter), weightsWire_1, _GEN_9) @[FIR.scala 46:33 FIR.scala 46:33]
    node weightsWire_2 = asSInt(UInt<16>("h3")) @[FIR.scala 20:28 FIR.scala 20:28]
    node _GEN_11 = mux(eq(UInt<2>("h2"), counter), weightsWire_2, _GEN_10) @[FIR.scala 46:33 FIR.scala 46:33]
    node _shiftReg_counter = _GEN_8 @[FIR.scala 46:33]
    node _weightsWire_counter = _GEN_11 @[FIR.scala 46:33]
    node _T_2 = mul(_shiftReg_counter, _weightsWire_counter) @[FIR.scala 46:33]
    node _T_3 = add(acc, _T_2) @[FIR.scala 46:18]
    node _T_4 = tail(_T_3, 1) @[FIR.scala 46:18]
    node _T_5 = asSInt(_T_4) @[FIR.scala 46:18]
    node _T_6 = eq(counter, UInt<2>("h2")) @[FIR.scala 48:20]
    node _T_7 = add(counter, UInt<1>("h1")) @[FIR.scala 51:28]
    node _T_8 = tail(_T_7, 1) @[FIR.scala 51:28]
    node _GEN_12 = mux(_T_6, UInt<2>("h2"), state) @[FIR.scala 48:41 FIR.scala 49:15 FIR.scala 12:22]
    node _GEN_13 = mux(_T_6, counter, _T_8) @[FIR.scala 48:41 FIR.scala 18:24 FIR.scala 51:17]
    node _T_9 = eq(UInt<2>("h2"), state) @[Conditional.scala 37:30]
    node _GEN_14 = mux(io_out_ready, UInt<2>("h0"), state) @[FIR.scala 57:26 FIR.scala 58:15 FIR.scala 12:22]
    node _GEN_15 = mux(_T_9, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 39:67 FIR.scala 56:20 FIR.scala 23:16]
    node _GEN_16 = mux(_T_9, _GEN_14, state) @[Conditional.scala 39:67 FIR.scala 12:22]
    node _GEN_17 = mux(_T_1, _T_5, acc) @[Conditional.scala 39:67 FIR.scala 46:11 FIR.scala 16:20]
    node _GEN_18 = mux(_T_1, _GEN_12, _GEN_16) @[Conditional.scala 39:67]
    node _GEN_19 = mux(_T_1, _GEN_13, counter) @[Conditional.scala 39:67 FIR.scala 18:24]
    node _GEN_20 = mux(_T_1, UInt<1>("h0"), _GEN_15) @[Conditional.scala 39:67 FIR.scala 23:16]
    node _GEN_21 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Conditional.scala 40:58 FIR.scala 29:19 FIR.scala 22:15]
    node _GEN_22 = mux(_T, _GEN_0, shiftReg_2) @[Conditional.scala 40:58 FIR.scala 14:25]
    node _GEN_23 = mux(_T, _GEN_1, shiftReg_1) @[Conditional.scala 40:58 FIR.scala 14:25]
    node _GEN_24 = mux(_T, _GEN_2, shiftReg_0) @[Conditional.scala 40:58 FIR.scala 14:25]
    node _GEN_25 = mux(_T, _GEN_3, _GEN_17) @[Conditional.scala 40:58]
    node _GEN_26 = mux(_T, _GEN_4, _GEN_19) @[Conditional.scala 40:58]
    node _GEN_27 = mux(_T, _GEN_5, _GEN_18) @[Conditional.scala 40:58]
    node _GEN_28 = mux(_T, UInt<1>("h0"), _GEN_20) @[Conditional.scala 40:58 FIR.scala 23:16]
    node _WIRE_0 = asSInt(UInt<16>("h0")) @[FIR.scala 14:33 FIR.scala 14:33]
    node _WIRE_1 = asSInt(UInt<16>("h0")) @[FIR.scala 14:33 FIR.scala 14:33]
    node _WIRE_2 = asSInt(UInt<16>("h0")) @[FIR.scala 14:33 FIR.scala 14:33]
    io_in_ready <= _GEN_21
    io_out_valid <= _GEN_28
    io_out_bits <= acc @[FIR.scala 24:15]
    state <= mux(reset, UInt<2>("h0"), _GEN_27) @[FIR.scala 12:22 FIR.scala 12:22]
    shiftReg_0 <= mux(reset, _WIRE_0, _GEN_24) @[FIR.scala 14:25 FIR.scala 14:25]
    shiftReg_1 <= mux(reset, _WIRE_1, _GEN_23) @[FIR.scala 14:25 FIR.scala 14:25]
    shiftReg_2 <= mux(reset, _WIRE_2, _GEN_22) @[FIR.scala 14:25 FIR.scala 14:25]
    acc <= mux(reset, asSInt(UInt<32>("h0")), _GEN_25) @[FIR.scala 16:20 FIR.scala 16:20]
    counter <= mux(reset, UInt<2>("h0"), _GEN_26) @[FIR.scala 18:24 FIR.scala 18:24]

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

  module Top :
    input clock : Clock
    input reset : UInt<1>
    output io_firIn_ready : UInt<1>
    input io_firIn_valid : UInt<1>
    input io_firIn_bits : SInt<16>
    output io_txd : UInt<1>

    inst fir of FIR @[Top.scala 10:19]
    inst tx of BufferedTx @[Top.scala 11:18]
    reg state : UInt<1>, clock with :
      reset => (UInt<1>("h0"), state) @[Top.scala 17:22]
    reg dataReg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), dataReg) @[Top.scala 19:24]
    reg byteCnt : UInt<3>, clock with :
      reset => (UInt<1>("h0"), byteCnt) @[Top.scala 20:24]
    node _T = eq(state, UInt<1>("h0")) @[Top.scala 22:30]
    node _T_1 = eq(state, UInt<1>("h1")) @[Top.scala 23:33]
    node _T_2 = bits(dataReg, 7, 0) @[Top.scala 25:32]
    node _T_3 = eq(UInt<1>("h0"), state) @[Conditional.scala 37:30]
    node _T_4 = asUInt(fir.io_out_bits) @[Top.scala 30:36]
    node _GEN_0 = mux(fir.io_out_valid, _T_4, dataReg) @[Top.scala 29:30 Top.scala 30:17 Top.scala 19:24]
    node _GEN_1 = mux(fir.io_out_valid, UInt<2>("h3"), byteCnt) @[Top.scala 29:30 Top.scala 31:17 Top.scala 20:24]
    node _GEN_2 = mux(fir.io_out_valid, UInt<1>("h1"), state) @[Top.scala 29:30 Top.scala 32:15 Top.scala 17:22]
    node _T_5 = eq(UInt<1>("h1"), state) @[Conditional.scala 37:30]
    node _T_6 = shr(dataReg, 8) @[Top.scala 37:28]
    node _T_7 = sub(byteCnt, UInt<1>("h1")) @[Top.scala 38:28]
    node _T_8 = tail(_T_7, 1) @[Top.scala 38:28]
    node _T_9 = eq(byteCnt, UInt<1>("h0")) @[Top.scala 40:22]
    node _GEN_3 = mux(_T_9, UInt<1>("h0"), state) @[Top.scala 40:31 Top.scala 41:17 Top.scala 17:22]
    node _GEN_4 = mux(tx.io_channel_ready, _T_6, dataReg) @[Top.scala 36:33 Top.scala 37:17 Top.scala 19:24]
    node _GEN_5 = mux(tx.io_channel_ready, _T_8, byteCnt) @[Top.scala 36:33 Top.scala 38:17 Top.scala 20:24]
    node _GEN_6 = mux(tx.io_channel_ready, _GEN_3, state) @[Top.scala 36:33 Top.scala 17:22]
    node _GEN_7 = mux(_T_5, _GEN_4, dataReg) @[Conditional.scala 39:67 Top.scala 19:24]
    node _GEN_8 = mux(_T_5, _GEN_5, byteCnt) @[Conditional.scala 39:67 Top.scala 20:24]
    node _GEN_9 = mux(_T_5, _GEN_6, state) @[Conditional.scala 39:67 Top.scala 17:22]
    node _GEN_10 = mux(_T_3, _GEN_0, _GEN_7) @[Conditional.scala 40:58]
    node _GEN_11 = mux(_T_3, _GEN_1, _GEN_8) @[Conditional.scala 40:58]
    node _GEN_12 = mux(_T_3, _GEN_2, _GEN_9) @[Conditional.scala 40:58]
    io_firIn_ready <= fir.io_in_ready @[Top.scala 13:13]
    io_txd <= tx.io_txd @[Top.scala 14:10]
    fir.clock <= clock
    fir.reset <= reset
    fir.io_in_valid <= io_firIn_valid @[Top.scala 13:13]
    fir.io_in_bits <= io_firIn_bits @[Top.scala 13:13]
    fir.io_out_ready <= _T @[Top.scala 22:20]
    tx.clock <= clock
    tx.reset <= reset
    tx.io_channel_valid <= _T_1 @[Top.scala 23:23]
    tx.io_channel_bits <= _T_2 @[Top.scala 25:22]
    state <= mux(reset, UInt<1>("h0"), _GEN_12) @[Top.scala 17:22 Top.scala 17:22]
    dataReg <= mux(reset, UInt<32>("h0"), _GEN_10) @[Top.scala 19:24 Top.scala 19:24]
    byteCnt <= mux(reset, UInt<3>("h0"), _GEN_11) @[Top.scala 20:24 Top.scala 20:24]
