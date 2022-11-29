// register_file.v
// This models 32, 32-bit registers.

module register_file #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 5
)(
  input clk, 
  input reg_write, 
  input  [ADDR_WIDTH-1:0] rs1, rs2, rd,
  input  [DATA_WIDTH-1:0] write_data_i,
  output [DATA_WIDTH-1:0] data1_o,
  output [DATA_WIDTH-1:0] data2_o
);

  // register declaration
  reg [DATA_WIDTH-1:0] reg_array[0:2**ADDR_WIDTH-1];
  initial $readmemh("data/register.mem", reg_array);

  always @(negedge clk) begin 
    // x0 = hard-wired zero
    reg_array[0] <= 0;
    
    // write at the negedge
    if (reg_write == 1'b1) reg_array[rd] <= write_data_i;
  end

  // register fetch = combinational logic
  assign data1_o = reg_array[rs1];
  assign data2_o = reg_array[rs2];

endmodule
