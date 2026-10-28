module FIR(
  input         clock,
  input         reset,
  output        io_in_ready,
  input         io_in_valid,
  input  [15:0] io_in_bits,
  input         io_out_ready,
  output        io_out_valid,
  output [31:0] io_out_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] state; // @[FIR.scala 10:22]
  reg [15:0] shiftReg_0; // @[FIR.scala 12:25]
  reg [15:0] shiftReg_1; // @[FIR.scala 12:25]
  reg [15:0] shiftReg_2; // @[FIR.scala 12:25]
  reg [31:0] acc; // @[FIR.scala 14:20]
  reg [1:0] counter; // @[FIR.scala 16:24]
  wire  _T = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_1 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire [15:0] _GEN_7 = 2'h1 == counter ? $signed(shiftReg_1) : $signed(shiftReg_0); // @[FIR.scala 44:33 FIR.scala 44:33]
  wire [15:0] _GEN_8 = 2'h2 == counter ? $signed(shiftReg_2) : $signed(_GEN_7); // @[FIR.scala 44:33 FIR.scala 44:33]
  wire [15:0] _GEN_10 = 2'h1 == counter ? $signed(16'sh2) : $signed(16'sh1); // @[FIR.scala 44:33 FIR.scala 44:33]
  wire [15:0] _GEN_11 = 2'h2 == counter ? $signed(16'sh3) : $signed(_GEN_10); // @[FIR.scala 44:33 FIR.scala 44:33]
  wire [31:0] _T_2 = $signed(_GEN_8) * $signed(_GEN_11); // @[FIR.scala 44:33]
  wire [31:0] _T_5 = $signed(acc) + $signed(_T_2); // @[FIR.scala 44:18]
  wire [1:0] _T_8 = counter + 2'h1; // @[FIR.scala 49:28]
  wire  _T_9 = 2'h2 == state; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_14 = io_out_ready ? 2'h0 : state; // @[FIR.scala 55:26 FIR.scala 56:15 FIR.scala 10:22]
  wire  _GEN_20 = _T_1 ? 1'h0 : _T_9; // @[Conditional.scala 39:67 FIR.scala 21:16]
  assign io_in_ready = 2'h0 == state; // @[Conditional.scala 37:30]
  assign io_out_valid = _T ? 1'h0 : _GEN_20; // @[Conditional.scala 40:58 FIR.scala 21:16]
  assign io_out_bits = acc; // @[FIR.scala 22:15]
  always @(posedge clock) begin
    if (reset) begin // @[FIR.scala 10:22]
      state <= 2'h0; // @[FIR.scala 10:22]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (io_in_valid) begin // @[FIR.scala 28:25]
        state <= 2'h1; // @[FIR.scala 36:15]
      end
    end else if (_T_1) begin // @[Conditional.scala 39:67]
      if (counter == 2'h2) begin // @[FIR.scala 46:41]
        state <= 2'h2; // @[FIR.scala 47:15]
      end
    end else if (_T_9) begin // @[Conditional.scala 39:67]
      state <= _GEN_14;
    end
    if (reset) begin // @[FIR.scala 12:25]
      shiftReg_0 <= 16'sh0; // @[FIR.scala 12:25]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (io_in_valid) begin // @[FIR.scala 28:25]
        shiftReg_0 <= io_in_bits; // @[FIR.scala 32:21]
      end
    end
    if (reset) begin // @[FIR.scala 12:25]
      shiftReg_1 <= 16'sh0; // @[FIR.scala 12:25]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (io_in_valid) begin // @[FIR.scala 28:25]
        shiftReg_1 <= shiftReg_0; // @[FIR.scala 30:23]
      end
    end
    if (reset) begin // @[FIR.scala 12:25]
      shiftReg_2 <= 16'sh0; // @[FIR.scala 12:25]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (io_in_valid) begin // @[FIR.scala 28:25]
        shiftReg_2 <= shiftReg_1; // @[FIR.scala 30:23]
      end
    end
    if (reset) begin // @[FIR.scala 14:20]
      acc <= 32'sh0; // @[FIR.scala 14:20]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (io_in_valid) begin // @[FIR.scala 28:25]
        acc <= 32'sh0; // @[FIR.scala 34:13]
      end
    end else if (_T_1) begin // @[Conditional.scala 39:67]
      acc <= _T_5; // @[FIR.scala 44:11]
    end
    if (reset) begin // @[FIR.scala 16:24]
      counter <= 2'h0; // @[FIR.scala 16:24]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (io_in_valid) begin // @[FIR.scala 28:25]
        counter <= 2'h0; // @[FIR.scala 35:17]
      end
    end else if (_T_1) begin // @[Conditional.scala 39:67]
      if (!(counter == 2'h2)) begin // @[FIR.scala 46:41]
        counter <= _T_8; // @[FIR.scala 49:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  shiftReg_0 = _RAND_1[15:0];
  _RAND_2 = {1{`RANDOM}};
  shiftReg_1 = _RAND_2[15:0];
  _RAND_3 = {1{`RANDOM}};
  shiftReg_2 = _RAND_3[15:0];
  _RAND_4 = {1{`RANDOM}};
  acc = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  counter = _RAND_5[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Tx(
  input        clock,
  input        reset,
  output       io_txd,
  output       io_channel_ready,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [9:0] shiftReg; // @[UART.scala 12:25]
  reg [19:0] cntReg; // @[UART.scala 13:23]
  reg [3:0] bitsReg; // @[UART.scala 14:24]
  wire  _T = cntReg == 20'h0; // @[UART.scala 16:31]
  wire [9:0] _T_8 = {1'h1,shiftReg[9:1]}; // @[UART.scala 23:23]
  wire [3:0] _T_10 = bitsReg - 4'h1; // @[UART.scala 24:26]
  wire [9:0] _T_12 = {1'h1,io_channel_bits,1'h0}; // @[UART.scala 27:44]
  wire [19:0] _T_14 = cntReg - 20'h1; // @[UART.scala 34:22]
  assign io_txd = shiftReg[0]; // @[UART.scala 17:21]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[UART.scala 16:40]
  always @(posedge clock) begin
    if (reset) begin // @[UART.scala 12:25]
      shiftReg <= 10'h3ff; // @[UART.scala 12:25]
    end else if (_T) begin // @[UART.scala 19:24]
      if (bitsReg != 4'h0) begin // @[UART.scala 21:27]
        shiftReg <= _T_8; // @[UART.scala 23:16]
      end else if (io_channel_valid) begin // @[UART.scala 26:30]
        shiftReg <= _T_12; // @[UART.scala 27:18]
      end else begin
        shiftReg <= 10'h3ff; // @[UART.scala 30:18]
      end
    end
    if (reset) begin // @[UART.scala 13:23]
      cntReg <= 20'h0; // @[UART.scala 13:23]
    end else if (_T) begin // @[UART.scala 19:24]
      cntReg <= 20'h1b1; // @[UART.scala 20:12]
    end else begin
      cntReg <= _T_14; // @[UART.scala 34:12]
    end
    if (reset) begin // @[UART.scala 14:24]
      bitsReg <= 4'h0; // @[UART.scala 14:24]
    end else if (_T) begin // @[UART.scala 19:24]
      if (bitsReg != 4'h0) begin // @[UART.scala 21:27]
        bitsReg <= _T_10; // @[UART.scala 24:15]
      end else if (io_channel_valid) begin // @[UART.scala 26:30]
        bitsReg <= 4'ha; // @[UART.scala 28:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  shiftReg = _RAND_0[9:0];
  _RAND_1 = {1{`RANDOM}};
  cntReg = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  bitsReg = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Buffer(
  input        clock,
  input        reset,
  output       io_in_ready,
  input        io_in_valid,
  input  [7:0] io_in_bits,
  input        io_out_ready,
  output       io_out_valid,
  output [7:0] io_out_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  stateReg; // @[UART.scala 45:25]
  reg [7:0] dataReg; // @[UART.scala 46:24]
  wire  _T = ~stateReg; // @[UART.scala 48:27]
  wire  _GEN_1 = io_in_valid | stateReg; // @[UART.scala 52:23 UART.scala 54:16 UART.scala 45:25]
  assign io_in_ready = ~stateReg; // @[UART.scala 48:27]
  assign io_out_valid = stateReg; // @[UART.scala 49:28]
  assign io_out_bits = dataReg; // @[UART.scala 61:15]
  always @(posedge clock) begin
    if (reset) begin // @[UART.scala 45:25]
      stateReg <= 1'h0; // @[UART.scala 45:25]
    end else if (_T) begin // @[UART.scala 51:28]
      stateReg <= _GEN_1;
    end else if (io_out_ready) begin // @[UART.scala 57:24]
      stateReg <= 1'h0; // @[UART.scala 58:16]
    end
    if (reset) begin // @[UART.scala 46:24]
      dataReg <= 8'h0; // @[UART.scala 46:24]
    end else if (_T) begin // @[UART.scala 51:28]
      if (io_in_valid) begin // @[UART.scala 52:23]
        dataReg <= io_in_bits; // @[UART.scala 53:15]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  stateReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  dataReg = _RAND_1[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BufferedTx(
  input        clock,
  input        reset,
  output       io_txd,
  output       io_channel_ready,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
  wire  tx_clock; // @[UART.scala 70:18]
  wire  tx_reset; // @[UART.scala 70:18]
  wire  tx_io_txd; // @[UART.scala 70:18]
  wire  tx_io_channel_ready; // @[UART.scala 70:18]
  wire  tx_io_channel_valid; // @[UART.scala 70:18]
  wire [7:0] tx_io_channel_bits; // @[UART.scala 70:18]
  wire  buf__clock; // @[UART.scala 71:19]
  wire  buf__reset; // @[UART.scala 71:19]
  wire  buf__io_in_ready; // @[UART.scala 71:19]
  wire  buf__io_in_valid; // @[UART.scala 71:19]
  wire [7:0] buf__io_in_bits; // @[UART.scala 71:19]
  wire  buf__io_out_ready; // @[UART.scala 71:19]
  wire  buf__io_out_valid; // @[UART.scala 71:19]
  wire [7:0] buf__io_out_bits; // @[UART.scala 71:19]
  Tx tx ( // @[UART.scala 70:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Buffer buf_ ( // @[UART.scala 71:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_ready(buf__io_in_ready),
    .io_in_valid(buf__io_in_valid),
    .io_in_bits(buf__io_in_bits),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid),
    .io_out_bits(buf__io_out_bits)
  );
  assign io_txd = tx_io_txd; // @[UART.scala 75:10]
  assign io_channel_ready = buf__io_in_ready; // @[UART.scala 73:13]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[UART.scala 74:17]
  assign tx_io_channel_bits = buf__io_out_bits; // @[UART.scala 74:17]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = io_channel_valid; // @[UART.scala 73:13]
  assign buf__io_in_bits = io_channel_bits; // @[UART.scala 73:13]
  assign buf__io_out_ready = tx_io_channel_ready; // @[UART.scala 74:17]
endmodule
module Top(
  input         clock,
  input         reset,
  output        io_firIn_ready,
  input         io_firIn_valid,
  input  [15:0] io_firIn_bits,
  output        io_txd
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  wire  fir_clock; // @[Top.scala 10:19]
  wire  fir_reset; // @[Top.scala 10:19]
  wire  fir_io_in_ready; // @[Top.scala 10:19]
  wire  fir_io_in_valid; // @[Top.scala 10:19]
  wire [15:0] fir_io_in_bits; // @[Top.scala 10:19]
  wire  fir_io_out_ready; // @[Top.scala 10:19]
  wire  fir_io_out_valid; // @[Top.scala 10:19]
  wire [31:0] fir_io_out_bits; // @[Top.scala 10:19]
  wire  tx_clock; // @[Top.scala 11:18]
  wire  tx_reset; // @[Top.scala 11:18]
  wire  tx_io_txd; // @[Top.scala 11:18]
  wire  tx_io_channel_ready; // @[Top.scala 11:18]
  wire  tx_io_channel_valid; // @[Top.scala 11:18]
  wire [7:0] tx_io_channel_bits; // @[Top.scala 11:18]
  reg  state; // @[Top.scala 17:22]
  reg [31:0] dataReg; // @[Top.scala 19:24]
  reg [2:0] byteCnt; // @[Top.scala 20:24]
  wire  _T = ~state; // @[Top.scala 22:30]
  wire  _GEN_2 = fir_io_out_valid | state; // @[Top.scala 29:30 Top.scala 32:15 Top.scala 17:22]
  wire [2:0] _T_8 = byteCnt - 3'h1; // @[Top.scala 38:28]
  wire  _GEN_3 = byteCnt == 3'h1 ? 1'h0 : state; // @[Top.scala 40:31 Top.scala 41:17 Top.scala 17:22]
  FIR fir ( // @[Top.scala 10:19]
    .clock(fir_clock),
    .reset(fir_reset),
    .io_in_ready(fir_io_in_ready),
    .io_in_valid(fir_io_in_valid),
    .io_in_bits(fir_io_in_bits),
    .io_out_ready(fir_io_out_ready),
    .io_out_valid(fir_io_out_valid),
    .io_out_bits(fir_io_out_bits)
  );
  BufferedTx tx ( // @[Top.scala 11:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  assign io_firIn_ready = fir_io_in_ready; // @[Top.scala 13:13]
  assign io_txd = tx_io_txd; // @[Top.scala 14:10]
  assign fir_clock = clock;
  assign fir_reset = reset;
  assign fir_io_in_valid = io_firIn_valid; // @[Top.scala 13:13]
  assign fir_io_in_bits = io_firIn_bits; // @[Top.scala 13:13]
  assign fir_io_out_ready = ~state; // @[Top.scala 22:30]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = state; // @[Top.scala 23:33]
  assign tx_io_channel_bits = dataReg[7:0]; // @[Top.scala 25:32]
  always @(posedge clock) begin
    if (reset) begin // @[Top.scala 17:22]
      state <= 1'h0; // @[Top.scala 17:22]
    end else if (_T) begin // @[Conditional.scala 40:58]
      state <= _GEN_2;
    end else if (state) begin // @[Conditional.scala 39:67]
      if (tx_io_channel_ready) begin // @[Top.scala 36:33]
        state <= _GEN_3;
      end
    end
    if (reset) begin // @[Top.scala 19:24]
      dataReg <= 32'h0; // @[Top.scala 19:24]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (fir_io_out_valid) begin // @[Top.scala 29:30]
        dataReg <= fir_io_out_bits; // @[Top.scala 30:17]
      end
    end else if (state) begin // @[Conditional.scala 39:67]
      if (tx_io_channel_ready) begin // @[Top.scala 36:33]
        dataReg <= {{8'd0}, dataReg[31:8]}; // @[Top.scala 37:17]
      end
    end
    if (reset) begin // @[Top.scala 20:24]
      byteCnt <= 3'h0; // @[Top.scala 20:24]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (fir_io_out_valid) begin // @[Top.scala 29:30]
        byteCnt <= 3'h4; // @[Top.scala 31:17]
      end
    end else if (state) begin // @[Conditional.scala 39:67]
      if (tx_io_channel_ready) begin // @[Top.scala 36:33]
        byteCnt <= _T_8; // @[Top.scala 38:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  dataReg = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  byteCnt = _RAND_2[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
