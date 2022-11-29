// adder.v
// This module is a simple adder for 2 inputs.

module adder #(
  parameter DATA_WIDTH = 32
)(
  input [DATA_WIDTH-1:0] in1,
  input [DATA_WIDTH-1:0] in2,

  output reg [DATA_WIDTH-1:0] out
);

always @(*) begin
  out = in1 + in2;
end

endmodule
