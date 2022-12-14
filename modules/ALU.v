// ALU.v

// This module performs ALU operations according to the "alu_func" value,
// which is generated by the ALU control unit.
// Note that there exist 10 R-type instructions in RV32I:
// add, sub, xor, or, and, sll, srl, sra, slt, sltu

`include "defines.v"

module ALU 
#(parameter DATA_WIDTH = 32)(
  input [DATA_WIDTH-1:0] in_a, 
  input [DATA_WIDTH-1:0] in_b,
  input [3:0] alu_func,

  output reg [DATA_WIDTH-1:0] out,
  output reg check 
);

// combinational logic 
always @(*) begin
  case (alu_func)
    `OP_ADD: out = in_a +  in_b; 
    `OP_SUB: out = in_a -  in_b;
    `OP_XOR: out = in_a ^  in_b;
    `OP_OR:  out = in_a |  in_b;
    `OP_AND: out = in_a &  in_b;
    `OP_SLL: out = in_a << in_b[4:0];
    `OP_SRL: out = in_a >> in_b[4:0];
    `OP_SRA: out = $signed(in_a) >>> in_b[4:0];
    `OP_SLT: out = ($signed(in_a) < $signed(in_b) )? 1 : 0;
    `OP_SLTU:out = (in_a < in_b) ? 1 : 0;
    `OP_SGE: out = ($signed(in_b) > $signed(in_a)) ? 0 : 1;
    `OP_SGEU:out = (in_b > in_a) ? 0 : 1;
    default: out = 32'h0000_0000;
  endcase
end

// combinational logic
always @(*) begin
  case (alu_func)
    `OP_ADD: check = 1;
    `OP_XOR: check = out ? 0 : 1;
    `OP_SUB: check = out ? 1 : 0;
    `OP_SLL: check = out ? 1 : 0;
    `OP_SGE: check = out ? 1 : 0;
    `OP_SLTU:check = out ? 1 : 0;
    `OP_SGEU:check = out ? 1 : 0;
    default: check = 0;
  endcase
end
endmodule
