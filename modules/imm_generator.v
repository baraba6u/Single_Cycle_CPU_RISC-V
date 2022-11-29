// imm_generator.v
// This unit generates immediate values certain types of instructions.

module imm_generator #(
  parameter DATA_WIDTH = 32
)(
  input [6:0] opcode,
  input [31:0] instruction,

  output reg [DATA_WIDTH-1:0] immediate
);

wire [31:0] inst;
assign inst = instruction;

always @(*) begin
  casex (opcode)
    
    7'b00x0011: immediate = {{21{inst[31]}},inst[30:20]};
    7'b1100111: immediate = {{21{inst[31]}},inst[30:20]};
    7'b0100011: immediate = {{21{inst[31]}},inst[30:25],inst[11:7]};
    7'b1100011: immediate = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
    7'b1101111: immediate = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};
    default: immediate = 32'h0000_0000;
    
  endcase
end


endmodule
