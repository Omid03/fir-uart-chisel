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
