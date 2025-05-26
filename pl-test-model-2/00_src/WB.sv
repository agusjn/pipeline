module WB (
  input  [31:0] i_pc_plus_four,
  input  [31:0] i_alu         ,
  input  [31:0] i_mem         ,
  input  [ 1:0] i_WB_sel         ,
  output [31:0] o_dataW
);

  assign o_dataW = (i_WB_sel == 2'b01) ? i_alu : (i_WB_sel == 2'b10) ? i_pc_plus_four : i_mem;

endmodule