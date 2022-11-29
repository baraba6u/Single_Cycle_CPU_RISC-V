// data_memory.v
// This is a 32 bit memory unit.

module data_memory #(
  parameter DATA_WIDTH = 32
)(
  input  clk,
  input  mem_write,
  input  mem_read,
  input  [1:0] maskmode,
  input  sext,
  input  [DATA_WIDTH-1:0] address,
  input  [DATA_WIDTH-1:0] write_data,
  output reg [DATA_WIDTH-1:0] read_data
);

  // memory
  reg [DATA_WIDTH-1:0] mem_array [0:31]; // 32-entry * 4bytes
  initial $readmemh("data/data_memory.mem", mem_array);
  // wire reg for write_data
  reg [DATA_WIDTH-1:0] write_data_internal = 0;
  wire [4:0] address_internal;

  assign address_internal = address[6:2];

  always @(*) begin
    case (maskmode)
      2'b00: write_data_internal[7:0] = write_data[7:0];
      2'b01: write_data_internal[15:0] = write_data[15:0];
      2'b10: write_data_internal[31:0] = write_data[31:0];
      default: write_data_internal[31:0] = 32'h0000_0000;
    endcase
  end

  // update at negative edge
  always @(negedge clk) begin 
    if (mem_write == 1'b1) begin
      mem_array[address_internal] <= write_data_internal;
    end
  end

  // combinational logic
  always @(*) begin
    if (mem_read == 1'b1) begin
      case (sext)
        1'b0: begin // sign-extended
          case (maskmode)
            2'b00: read_data = { {24{mem_array[address_internal][7]}}, mem_array[address_internal][7:0]};
            2'b01: read_data = { {16{mem_array[address_internal][15]}}, mem_array[address_internal][15:0]};
            2'b10: read_data = mem_array[address_internal];
            default: read_data = 32'h0000_0000;
          endcase
        end
        1'b1: begin // zero-extended
          case (maskmode)
            2'b00: read_data = { 24'h0000_00, mem_array[address_internal][7:0]};
            2'b01: read_data = { 16'h0000, mem_array[address_internal][15:0]};
            default: read_data = 32'h0000_0000;
          endcase
        end
      endcase
    end else begin
      read_data = 32'h0000_0000;
    end
  end

endmodule
