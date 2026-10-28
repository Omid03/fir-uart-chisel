# Technical review

## Evidence boundaries

The archive contains three separate VCDs, associated FIRRTL, legacy Verilog and split CIRCT SystemVerilog. No saved test console log, sbt execution log or test-result XML was found outside IDE configuration. Test code contains assertions, but printed success strings in source files are not execution evidence.

The new analyzer checks historical waveforms. It reads all changes at each timestamp, detects clock rising edges and uses the values immediately before the edge for ready/valid transfers. For UART it detects a falling start edge and samples the middle of each bit cell, using the archived 100 ns bit duration. This is deliberately scoped to the supplied test configurations; it is not a general baud-rate autodetector.

FIR transfers were observed at 61/101, 111/151 and 161/201 ns (input/output). UART sends 0x55 starting at 151 ns. Top accepts one input sample of 10 at 61 ns and sends bytes 0A, 00, 00, 00 starting at 151, 1251, 2351 and 3451 ns. All sampled framing bits match 8N1. No new hardware simulation was run.

## FIR behavior

The coefficient sequence is a Scala elaboration parameter. The supplied examples use three taps with coefficients 1, 2 and 3. The presentation's phrase “dynamic weight arrays” should not be read as runtime reprogramming: there is no coefficient-write port.

The delay line changes only on input acceptance. One tap is accumulated per compute cycle; output data remains stable in the done state during backpressure. For N taps, earliest output transfer occurs N+1 clock periods after acceptance, and earliest next input acceptance is N+2 periods after the preceding acceptance. These statements follow from the FSM with an always-ready output, not from physical timing analysis.

Each product is formed from signed 16-bit operands, but the accumulated result is assigned to 32 bits. There is no saturation. An arbitrary tap count can overflow even when each product fits. No parameter validation constrains empty coefficient sequences, zero-width counter corner cases for one tap, or out-of-range signed coefficients. Only the supplied three-tap configuration is evidenced by the runs.

The FIR test uses three positive inputs and keeps output ready high. It does not test stalls, negative arithmetic, overflow, reset during computation, or arbitrary coefficient lengths.

## UART and buffering

The divider counts from BIT_CNT down to zero, giving BIT_CNT+1 clocks per bit. The counter continues to tick in the idle state, so a buffered byte can wait for the next baud tick. The 20-bit counter also limits the usable divider range; constructor parameters have no explicit range validation.

The transmitter loads start/data/stop into a ten-bit shift register and sets bitsReg to ten. At the final shift, bitsReg becomes zero, but the next load cannot occur until the following baud tick. Consecutive frame starts in the Top VCD are therefore eleven bit periods apart. This is an extra idle-high interval, not a second data byte or a framing failure.

The one-byte Buffer cannot dequeue and refill on the same edge: its input is ready only in the empty state. It introduces a refill bubble, although UART serialization dominates the demonstrated rate.

The standalone UART test checks only 0x55. The top test checks a word whose upper three bytes are zero. Arbitrary nonzero byte positions, negative results, long bursts and reset mid-frame are not demonstrated.

## Top-level backpressure

Top captures one FIR result and starts offering its low byte. It shifts the holding register only when the byte buffer is ready while the sending state asserts valid. The count starts at three and returns Top to idle on the fourth accepted byte.

Top may consume another FIR result before all previous bytes have physically left the serial pin, because queue acceptance and serial completion are different events. Ordering is preserved by the byte buffer/transmitter path; long-run behavior still needs a multi-result regression. The FIR can accept one subsequent sample after its prior output handshake, compute it, and wait in its done state while Top remains busy. Consequently the source does not freeze every FIR internal state for the complete serial frame duration.

## Test harness limitations

FIRTest calls expect on each of three outputs. UARTTest checks start, each of eight data bits, and stop. TopTest checks framing for four bytes and asserts that the reconstructed word equals ten. These are meaningful directed cases; no archived pass-count summary is available.

The original UART testers sample at nominal bit boundaries after stepping, while the new archival decoder samples bit centers. The archived waveforms satisfy the center-sampling checks. Waiting loops lack explicit timeouts and can hang if ready/valid or start detection never progresses. Driver.execute results are not checked by the App entry points, so process success alone is not a reliable regression verdict.

## Generation provenance

Scala-based generators use the pinned Chisel 3.4.2 dependencies. A second tree contains CIRCT firtool-1.146.0 output and its own FIRRTL inputs. FIRtool.txt supplies the intended CLI flags. The archived CIRCT input files add a `FIRRTL version 2.0.0` declaration to the corresponding legacy FIRRTL. This textual change is not a general compatibility validation. These files establish that output artifacts exist, not that formal or simulation equivalence between both backends has been checked.

UART/Top RTL generators use 50 MHz and 115200; their baud reload constant is 433. The tests use 10000 and 1000, giving reload nine. A simulated 10 ns clock does not physically correspond to the frequency parameter 10000; the parameter is only used for the ratio in the divider.

No synthesis, utilization, timing closure, power or board demonstration is present. No backend was rerun during documentation preparation. All supplied Scala and build files are unchanged; hashes are retained in results/source-manifest.json.
