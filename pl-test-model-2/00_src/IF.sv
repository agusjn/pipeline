module IF(
    input logic i_clk, i_reset, enable,
    input logic [31:0] i_alu_data,
    input logic i_pc_sel,
    output logic [31:0] o_PC, o_instr
);
logic [31:0] PC;

inst_mem IMEM(
    .rst(i_reset),
    .i_PC(PC),
    .o_instr(o_instr)
);

PC_block PC_module(
  .i_clk(i_clk),
  .i_reset(i_reset),
  .pc_sel(i_pc_sel),
  .i_stall(enable),
  .i_alu_data(i_alu_data),
  .o_pc(PC)
);

assign o_PC = PC;

endmodule