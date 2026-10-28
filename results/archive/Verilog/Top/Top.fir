;buildInfoPackage: chisel3, version: 3.4.2, scalaVersion: 2.12.12, sbtVersion: 1.3.10
circuit Top : 
  module FIR : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<32>}}
    
    reg state : UInt<2>, clock with : (reset => (reset, UInt<2>("h00"))) @[FIR.scala 10:22]
    wire _WIRE : SInt<16>[3] @[FIR.scala 12:33]
    _WIRE[0] <= asSInt(UInt<16>("h00")) @[FIR.scala 12:33]
    _WIRE[1] <= asSInt(UInt<16>("h00")) @[FIR.scala 12:33]
    _WIRE[2] <= asSInt(UInt<16>("h00")) @[FIR.scala 12:33]
    reg shiftReg : SInt<16>[3], clock with : (reset => (reset, _WIRE)) @[FIR.scala 12:25]
    reg acc : SInt<32>, clock with : (reset => (reset, asSInt(UInt<32>("h00")))) @[FIR.scala 14:20]
    reg counter : UInt<2>, clock with : (reset => (reset, UInt<2>("h00"))) @[FIR.scala 16:24]
    wire weightsWire : SInt<16>[3] @[FIR.scala 18:28]
    weightsWire[0] <= asSInt(UInt<16>("h01")) @[FIR.scala 18:28]
    weightsWire[1] <= asSInt(UInt<16>("h02")) @[FIR.scala 18:28]
    weightsWire[2] <= asSInt(UInt<16>("h03")) @[FIR.scala 18:28]
    io.in.ready <= UInt<1>("h00") @[FIR.scala 20:15]
    io.out.valid <= UInt<1>("h00") @[FIR.scala 21:16]
    io.out.bits <= acc @[FIR.scala 22:15]
    node _T = eq(UInt<2>("h00"), state) @[Conditional.scala 37:30]
    when _T : @[Conditional.scala 40:58]
      io.in.ready <= UInt<1>("h01") @[FIR.scala 27:19]
      when io.in.valid : @[FIR.scala 28:25]
        shiftReg[2] <= shiftReg[1] @[FIR.scala 30:23]
        shiftReg[1] <= shiftReg[0] @[FIR.scala 30:23]
        shiftReg[0] <= io.in.bits @[FIR.scala 32:21]
        acc <= asSInt(UInt<1>("h00")) @[FIR.scala 34:13]
        counter <= UInt<1>("h00") @[FIR.scala 35:17]
        state <= UInt<2>("h01") @[FIR.scala 36:15]
        skip @[FIR.scala 28:25]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_1 = eq(UInt<2>("h01"), state) @[Conditional.scala 37:30]
      when _T_1 : @[Conditional.scala 39:67]
        node _T_2 = mul(shiftReg[counter], weightsWire[counter]) @[FIR.scala 44:33]
        node _T_3 = add(acc, _T_2) @[FIR.scala 44:18]
        node _T_4 = tail(_T_3, 1) @[FIR.scala 44:18]
        node _T_5 = asSInt(_T_4) @[FIR.scala 44:18]
        acc <= _T_5 @[FIR.scala 44:11]
        node _T_6 = eq(counter, UInt<2>("h02")) @[FIR.scala 46:20]
        when _T_6 : @[FIR.scala 46:41]
          state <= UInt<2>("h02") @[FIR.scala 47:15]
          skip @[FIR.scala 46:41]
        else : @[FIR.scala 48:20]
          node _T_7 = add(counter, UInt<1>("h01")) @[FIR.scala 49:28]
          node _T_8 = tail(_T_7, 1) @[FIR.scala 49:28]
          counter <= _T_8 @[FIR.scala 49:17]
          skip @[FIR.scala 48:20]
        skip @[Conditional.scala 39:67]
      else : @[Conditional.scala 39:67]
        node _T_9 = eq(UInt<2>("h02"), state) @[Conditional.scala 37:30]
        when _T_9 : @[Conditional.scala 39:67]
          io.out.valid <= UInt<1>("h01") @[FIR.scala 54:20]
          when io.out.ready : @[FIR.scala 55:26]
            state <= UInt<2>("h00") @[FIR.scala 56:15]
            skip @[FIR.scala 55:26]
          skip @[Conditional.scala 39:67]
    
  module Tx : 
    input clock : Clock
    input reset : Reset
    output io : {txd : UInt<1>, flip channel : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg shiftReg : UInt, clock with : (reset => (reset, UInt<10>("h03ff"))) @[UART.scala 12:25]
    reg cntReg : UInt<20>, clock with : (reset => (reset, UInt<20>("h00"))) @[UART.scala 13:23]
    reg bitsReg : UInt<4>, clock with : (reset => (reset, UInt<4>("h00"))) @[UART.scala 14:24]
    node _T = eq(cntReg, UInt<1>("h00")) @[UART.scala 16:31]
    node _T_1 = eq(bitsReg, UInt<1>("h00")) @[UART.scala 16:52]
    node _T_2 = and(_T, _T_1) @[UART.scala 16:40]
    io.channel.ready <= _T_2 @[UART.scala 16:20]
    node _T_3 = bits(shiftReg, 0, 0) @[UART.scala 17:21]
    io.txd <= _T_3 @[UART.scala 17:10]
    node _T_4 = eq(cntReg, UInt<1>("h00")) @[UART.scala 19:15]
    when _T_4 : @[UART.scala 19:24]
      cntReg <= UInt<9>("h01b1") @[UART.scala 20:12]
      node _T_5 = neq(bitsReg, UInt<1>("h00")) @[UART.scala 21:18]
      when _T_5 : @[UART.scala 21:27]
        node _T_6 = shr(shiftReg, 1) @[UART.scala 22:28]
        node _T_7 = bits(_T_6, 8, 0) @[UART.scala 23:31]
        node _T_8 = cat(UInt<1>("h01"), _T_7) @[UART.scala 23:23]
        shiftReg <= _T_8 @[UART.scala 23:16]
        node _T_9 = sub(bitsReg, UInt<1>("h01")) @[UART.scala 24:26]
        node _T_10 = tail(_T_9, 1) @[UART.scala 24:26]
        bitsReg <= _T_10 @[UART.scala 24:15]
        skip @[UART.scala 21:27]
      else : @[UART.scala 25:18]
        when io.channel.valid : @[UART.scala 26:30]
          node _T_11 = cat(UInt<1>("h01"), io.channel.bits) @[UART.scala 27:25]
          node _T_12 = cat(_T_11, UInt<1>("h00")) @[UART.scala 27:44]
          shiftReg <= _T_12 @[UART.scala 27:18]
          bitsReg <= UInt<4>("h0a") @[UART.scala 28:17]
          skip @[UART.scala 26:30]
        else : @[UART.scala 29:20]
          shiftReg <= UInt<10>("h03ff") @[UART.scala 30:18]
          skip @[UART.scala 29:20]
        skip @[UART.scala 25:18]
      skip @[UART.scala 19:24]
    else : @[UART.scala 33:16]
      node _T_13 = sub(cntReg, UInt<1>("h01")) @[UART.scala 34:22]
      node _T_14 = tail(_T_13, 1) @[UART.scala 34:22]
      cntReg <= _T_14 @[UART.scala 34:12]
      skip @[UART.scala 33:16]
    
  module Buffer : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg stateReg : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[UART.scala 45:25]
    reg dataReg : UInt<8>, clock with : (reset => (reset, UInt<8>("h00"))) @[UART.scala 46:24]
    node _T = eq(stateReg, UInt<1>("h00")) @[UART.scala 48:27]
    io.in.ready <= _T @[UART.scala 48:15]
    node _T_1 = eq(stateReg, UInt<1>("h01")) @[UART.scala 49:28]
    io.out.valid <= _T_1 @[UART.scala 49:16]
    node _T_2 = eq(stateReg, UInt<1>("h00")) @[UART.scala 51:17]
    when _T_2 : @[UART.scala 51:28]
      when io.in.valid : @[UART.scala 52:23]
        dataReg <= io.in.bits @[UART.scala 53:15]
        stateReg <= UInt<1>("h01") @[UART.scala 54:16]
        skip @[UART.scala 52:23]
      skip @[UART.scala 51:28]
    else : @[UART.scala 56:16]
      when io.out.ready : @[UART.scala 57:24]
        stateReg <= UInt<1>("h00") @[UART.scala 58:16]
        skip @[UART.scala 57:24]
      skip @[UART.scala 56:16]
    io.out.bits <= dataReg @[UART.scala 61:15]
    
  module BufferedTx : 
    input clock : Clock
    input reset : Reset
    output io : {txd : UInt<1>, flip channel : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    inst tx of Tx @[UART.scala 70:18]
    tx.clock <= clock
    tx.reset <= reset
    inst buf of Buffer @[UART.scala 71:19]
    buf.clock <= clock
    buf.reset <= reset
    buf.io.in.bits <= io.channel.bits @[UART.scala 73:13]
    buf.io.in.valid <= io.channel.valid @[UART.scala 73:13]
    io.channel.ready <= buf.io.in.ready @[UART.scala 73:13]
    tx.io.channel.bits <= buf.io.out.bits @[UART.scala 74:17]
    tx.io.channel.valid <= buf.io.out.valid @[UART.scala 74:17]
    buf.io.out.ready <= tx.io.channel.ready @[UART.scala 74:17]
    io.txd <= tx.io.txd @[UART.scala 75:10]
    
  module Top : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip firIn : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, txd : UInt<1>}
    
    inst fir of FIR @[Top.scala 10:19]
    fir.clock <= clock
    fir.reset <= reset
    inst tx of BufferedTx @[Top.scala 11:18]
    tx.clock <= clock
    tx.reset <= reset
    fir.io.in.bits <= io.firIn.bits @[Top.scala 13:13]
    fir.io.in.valid <= io.firIn.valid @[Top.scala 13:13]
    io.firIn.ready <= fir.io.in.ready @[Top.scala 13:13]
    io.txd <= tx.io.txd @[Top.scala 14:10]
    reg state : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[Top.scala 17:22]
    reg dataReg : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[Top.scala 19:24]
    reg byteCnt : UInt<3>, clock with : (reset => (reset, UInt<3>("h00"))) @[Top.scala 20:24]
    node _T = eq(state, UInt<1>("h00")) @[Top.scala 22:30]
    fir.io.out.ready <= _T @[Top.scala 22:20]
    node _T_1 = eq(state, UInt<1>("h01")) @[Top.scala 23:33]
    tx.io.channel.valid <= _T_1 @[Top.scala 23:23]
    node _T_2 = bits(dataReg, 7, 0) @[Top.scala 25:32]
    tx.io.channel.bits <= _T_2 @[Top.scala 25:22]
    node _T_3 = eq(UInt<1>("h00"), state) @[Conditional.scala 37:30]
    when _T_3 : @[Conditional.scala 40:58]
      when fir.io.out.valid : @[Top.scala 29:30]
        node _T_4 = asUInt(fir.io.out.bits) @[Top.scala 30:36]
        dataReg <= _T_4 @[Top.scala 30:17]
        byteCnt <= UInt<3>("h04") @[Top.scala 31:17]
        state <= UInt<1>("h01") @[Top.scala 32:15]
        skip @[Top.scala 29:30]
      skip @[Conditional.scala 40:58]
    else : @[Conditional.scala 39:67]
      node _T_5 = eq(UInt<1>("h01"), state) @[Conditional.scala 37:30]
      when _T_5 : @[Conditional.scala 39:67]
        when tx.io.channel.ready : @[Top.scala 36:33]
          node _T_6 = shr(dataReg, 8) @[Top.scala 37:28]
          dataReg <= _T_6 @[Top.scala 37:17]
          node _T_7 = sub(byteCnt, UInt<1>("h01")) @[Top.scala 38:28]
          node _T_8 = tail(_T_7, 1) @[Top.scala 38:28]
          byteCnt <= _T_8 @[Top.scala 38:17]
          node _T_9 = eq(byteCnt, UInt<1>("h01")) @[Top.scala 40:22]
          when _T_9 : @[Top.scala 40:31]
            state <= UInt<1>("h00") @[Top.scala 41:17]
            skip @[Top.scala 40:31]
          skip @[Top.scala 36:33]
        skip @[Conditional.scala 39:67]
    
