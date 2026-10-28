;buildInfoPackage: chisel3, version: 3.4.2, scalaVersion: 2.12.12, sbtVersion: 1.3.10
circuit BufferedTx : 
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
      cntReg <= UInt<4>("h09") @[UART.scala 20:12]
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
    input reset : UInt<1>
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
    
