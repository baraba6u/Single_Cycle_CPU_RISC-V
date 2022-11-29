`ifndef __defines_vh__
`define __defines_vh__

// ALU function
`define OP_ADD  4'b0000
`define OP_SUB  4'b0001
`define OP_XOR  4'b0010
`define OP_OR   4'b0011
`define OP_AND  4'b0100
`define OP_SLL  4'b0101    // shift left logical
`define OP_SRL  4'b0110    // shift right logical
`define OP_SRA  4'b0111    // shift right arithmetic
`define OP_SLT  4'b1000    // set less than
`define OP_SLTU 4'b1001    // set less than (unsigned)
`define OP_SGE  4'b1010    // set greater than or equal to
`define OP_SGEU 4'b1011    // set greater than or equal to (unsigned)
`define OP_EEE  4'b1111    // error

`endif // __defines_vh__
