module inst_mem(
  input logic rst,
  input logic [31:0]i_PC,
  output logic [31:0]o_instr
  );

  logic [31:0] mem [8191:0]; //2048 * 4 byte = 8192 byte = 8KiB
  
  assign o_instr = (!rst) ? {32{1'b0}} : mem[i_PC[31:2]];

  initial begin
    $readmemh("../02_test/isa.mem",mem);
  end
endmodule