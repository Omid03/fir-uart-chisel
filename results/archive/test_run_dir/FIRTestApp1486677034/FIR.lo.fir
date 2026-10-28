circuit FIR :
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
