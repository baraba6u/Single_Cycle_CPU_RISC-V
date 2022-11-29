// mux_2x1.v
// This module is a 2 way multiplexer.

module mux_2x1
#(parameter DATA_WIDTH = 32)(
  input select,
  input [DATA_WIDTH-1:0] in1,
  input [DATA_WIDTH-1:0] in2,
  
  output reg [DATA_WIDTH-1:0] out
);

// combinational logic
always @ (*) begin
  case(select)
    1'b0: out = in1;
    1'b1: out = in2;
    default: out = {DATA_WIDTH{1'bx}}; // should never fall here
  endcase
end

endmodule
