circuit FIR :
  module FIR :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : { flip ready : UInt<1>, valid : UInt<1>, bits : SInt<32>}}

    reg state : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[FIR.scala 10:22]
    wire _WIRE : SInt<16>[3] @[FIR.scala 12:33]
    _WIRE[0] <= asSInt(UInt<16>("h0")) @[FIR.scala 12:33]
    _WIRE[1] <= asSInt(UInt<16>("h0")) @[FIR.scala 12:33]
    _WIRE[2] <= asSInt(UInt<16>("h0")) @[FIR.scala 12:33]
    reg shiftReg : SInt<16>[3], clock with :
      reset => (reset, _WIRE) @[FIR.scala 12:25]
    reg acc : SInt<32>, clock with :
      reset => (reset, asSInt(UInt<32>("h0"))) @[FIR.scala 14:20]
    reg counter : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[FIR.scala 16:24]
    wire weightsWire : SInt<16>[3] @[FIR.scala 18:28]
    weightsWire[0] <= asSInt(UInt<16>("h1")) @[FIR.scala 18:28]
    weightsWire[1] <= asSInt(UInt<16>("h2")) @[FIR.scala 18:28]
    weightsWire[2] <= asSInt(UInt<16>("h3")) @[FIR.scala 18:28]
    io.in.ready <= UInt<1>("h0") @[FIR.scala 20:15]
    io.out.valid <= UInt<1>("h0") @[FIR.scala 21:16]
    io.out.bits <= acc @[FIR.scala 22:15]
    node _T = eq(UInt<2>("h0"), state) @[Conditional.scala 37:30]
    when _T : @[Conditional.scala 40:58]
      io.in.ready <= UInt<1>("h1") @[FIR.scala 27:19]
      when io.in.valid : @[FIR.scala 28:25]
        shiftReg[2] <= shiftReg[1] @[FIR.scala 30:23]
        shiftReg[1] <= shiftReg[0] @[FIR.scala 30:23]
        shiftReg[0] <= io.in.bits @[FIR.scala 32:21]
        acc <= asSInt(UInt<1>("h0")) @[FIR.scala 34:13]
        counter <= UInt<1>("h0") @[FIR.scala 35:17]
        state <= UInt<2>("h1") @[FIR.scala 36:15]
    else :
      node _T_1 = eq(UInt<2>("h1"), state) @[Conditional.scala 37:30]
      when _T_1 : @[Conditional.scala 39:67]
        node _T_2 = mul(shiftReg[counter], weightsWire[counter]) @[FIR.scala 44:33]
        node _T_3 = add(acc, _T_2) @[FIR.scala 44:18]
        node _T_4 = tail(_T_3, 1) @[FIR.scala 44:18]
        node _T_5 = asSInt(_T_4) @[FIR.scala 44:18]
        acc <= _T_5 @[FIR.scala 44:11]
        node _T_6 = eq(counter, UInt<2>("h2")) @[FIR.scala 46:20]
        when _T_6 : @[FIR.scala 46:41]
          state <= UInt<2>("h2") @[FIR.scala 47:15]
        else :
          node _T_7 = add(counter, UInt<1>("h1")) @[FIR.scala 49:28]
          node _T_8 = tail(_T_7, 1) @[FIR.scala 49:28]
          counter <= _T_8 @[FIR.scala 49:17]
      else :
        node _T_9 = eq(UInt<2>("h2"), state) @[Conditional.scala 37:30]
        when _T_9 : @[Conditional.scala 39:67]
          io.out.valid <= UInt<1>("h1") @[FIR.scala 54:20]
          when io.out.ready : @[FIR.scala 55:26]
            state <= UInt<2>("h0") @[FIR.scala 56:15]
