// mux_2x1.v
// This module is a 3 way multiplexer.

module mux_3x1
#(parameter DATA_WIDTH = 32)(
  input [1:0] select,
  input [DATA_WIDTH-1:0] in1,
  input [DATA_WIDTH-1:0] in2,
  input [DATA_WIDTH-1:0] in3,
  
  output reg [DATA_WIDTH-1:0] out
);

// combinational logic
always @ (*) begin
  case(select)
    2'b00: out = in1;
    2'b01: out = in2;
    2'b10: out = in3;
    2'b11: out = {DATA_WIDTH{1'bx}};   // invalid output
    default: out = {DATA_WIDTH{1'bx}}; // should never fall here
  endcase
end

endmodule
