// branch_control.v
// This unit is for controlling branch instructions.
// It takes the branch control signal from the main control unit
// and the check signal from the ALU to check if the instruction 
// is a branch taken/not-taken.
// for jal/jalr always taken = 1

module branch_control
(
  input branch,
  input check,

  output reg taken 
);

always @(*) begin
  taken = branch && check;
end

endmodule
