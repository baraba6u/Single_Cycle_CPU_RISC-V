// control.v

// The main control module takes as input the opcode field of an instruction
// (i.e., instruction[6:0]) and generates a set of control signals.

module control(
  input [6:0] opcode,

  output [1:0] jump,          // 01: jal, 11: jalr, 00: else

  output branch,              // 1: branch
  output mem_read,            // 1: read from memroy
  output mem_to_reg,          // 1: reg writeback from memory, 0: from ALU

  output [1:0] alu_op,        // ALU control

  output mem_write,           // 1: write to memory
  output alu_src,             // 1: in_b = immediate, 0: register val
  output reg_write            // 1: writeback to register
);

reg [9:0] controls;

// combinational logic
always @(*) begin
  case (opcode)
  
    // R-type
    7'b0110011: controls = 10'b00_000_10_001;
    // I-type immediate
    7'b0010011: controls = 10'b00_000_11_011;
    // I-type load
    7'b0000011: controls = 10'b00_011_00_011;
    // S-type store
    7'b0100011: controls = 10'b00_00x_00_110;
    // B-type conditional branch
    7'b1100011: controls = 10'b00_10x_01_000;
    // J-type jal
    7'b1101111: controls = 10'b01_100_00_0x1;
    // I-type jalr
    7'b1100111: controls = 10'b11_100_00_011;

    default:    controls = 10'b00_000_00_000;
  endcase
end

assign {jump, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = controls;

endmodule
