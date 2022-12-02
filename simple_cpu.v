// simple_cpu.v
// A Single-Cycle RISC-V Microarchitecture
// RV32I Base Integer Instructions

module simple_cpu
#(parameter DATA_WIDTH = 32)(
  input clk,
  input rstn
);

////////////////////////////////////////////////////
// Instruction Fetch (IF)
////////////////////////////////////////////////////

wire [DATA_WIDTH-1:0] pc_plus_4;
reg [DATA_WIDTH-1:0] PC;

// pc+4
adder m_next_pc_adder(
  .in1(PC),
  .in2(32'h0000_0004),

  .out(pc_plus_4)
);

wire [DATA_WIDTH-1:0] NEXT_PC;

// program counter
always @(posedge clk) begin
  if (rstn == 1'b0) PC <= 32'h00000000;
  else PC <= NEXT_PC;
end



localparam NUM_INSTS = 512;

// instruction memory
reg [31:0] inst_memory[0:NUM_INSTS-1];
initial $readmemb("data/inst.mem", inst_memory);


// current instruction
wire [DATA_WIDTH-1:0] instruction;
assign instruction = inst_memory[PC[31:2]];


////////////////////////////////////////////////////
// Instruction Decode (ID)
////////////////////////////////////////////////////

// from register file 
wire [31:0] rs1_out, rs2_out;
wire [31:0] alu_out;

// 5 bits for each (because there exist 32 registers)
wire [4:0] rs1, rs2, rd;

wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;

// instruction fields
assign opcode = instruction[6:0];

assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];

// R type
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign rd  = instruction[11:7];


wire branch;
wire mem_read;
wire mem_to_reg;
wire [1:0] alu_op;
wire mem_write;
wire alu_src;
wire reg_write;
wire [1:0]jump;

// control
control m_control(
  .opcode(opcode),

  .jump(jump),
  .branch(branch),
  .mem_read(mem_read),
  .mem_to_reg(mem_to_reg),
  .alu_op(alu_op),
  .mem_write(mem_write),
  .alu_src(alu_src),
  .reg_write(reg_write)
);


wire [DATA_WIDTH-1:0] write_data; 
wire [DATA_WIDTH-1:0] read_data;

// register file
register_file m_register_file(
  .clk(clk),
  .reg_write(reg_write),
  .rs1(rs1),
  .rs2(rs2),
  .rd(rd),
  .write_data_i(write_data),
  
  .data1_o(rs1_out),
  .data2_o(rs2_out)
);


wire [31:0] immediate;

// immediate generator
imm_generator m_imm_generator(
  .opcode(opcode),
  .instruction(instruction),

  .immediate(immediate)
);


////////////////////////////////////////////////////
// Execute (EX) 
////////////////////////////////////////////////////


wire [3:0] alu_func;

// alu control
ALU_control m_ALU_control(
  .alu_op(alu_op), 
  .funct7(funct7),
  .funct3(funct3),

  .alu_func(alu_func)
);


wire [31:0] alu_in2;

// mux for in_b in alu
mux_2x1 in_b_mux(
  .select(alu_src),
  .in1(rs2_out),
  .in2(immediate),
  .out(alu_in2)
);


wire [31:0] alu_in1;
wire alu_check;

assign alu_in1 = rs1_out;

// alu
ALU m_ALU(
  .in_a(alu_in1), 
  .in_b(alu_in2),
  .alu_func(alu_func),

  .out(alu_out),
  .check(alu_check)
);


////////////////////////////////////////////////////
// Memory (MEM) 
////////////////////////////////////////////////////



wire[DATA_WIDTH-1:0] branch_target;

// pc+immediate
adder pc_imm_adder(
  .in1(PC),
  .in2(immediate),
  .out(branch_target)
);


wire taken;

// branch control
branch_control m_branch_control(
  .branch(branch),
  .check(alu_check),

  .taken(taken)
);


wire [DATA_WIDTH-1:0] next_pc_cand;

// 2 2x1 mux for selecting next_pc
mux_2x1 pc_branch_mux(
  .select(jump[1]),
  .in1(branch_target),
  .in2(alu_out),
  .out(next_pc_cand)
);

mux_2x1 next_pc_mux(
  .select(taken),
  .in1(pc_plus_4),
  .in2(next_pc_cand),
  .out(NEXT_PC)
);



wire [1:0] maskmode;
wire sext;

assign maskmode = instruction[13:12];
assign sext = instruction[14];

// data memory
data_memory m_data_memory(
  .clk(clk),
  .mem_write(mem_write),
  .mem_read(mem_read),
  .maskmode(maskmode),
  .sext(sext),
  .address(alu_out),
  .write_data(rs2_out),

  .read_data(read_data)
);


////////////////////////////////////////////////////
// Write Back (WB) 
////////////////////////////////////////////////////

// 1 3x1 mux for write_data_i in register file
mux_3x1 write_data_mux(
  .select({jump[0],mem_to_reg}),
  .in1(alu_out),
  .in2(read_data),
  .in3(pc_plus_4),
  .out(write_data)
);

endmodule
