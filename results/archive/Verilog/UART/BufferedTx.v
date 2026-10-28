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
