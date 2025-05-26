module MEM_WB (
  input  logic           i_clk, i_reset  , flush,
  input  logic    [31:0] i_mem         ,
  input  logic    [31:0] i_pc_plus_four, i_inst,
  input  logic    [31:0] i_alu_out     ,
  input  logic    [ 1:0] i_wb_sel     ,
  input  logic           i_regWEn      ,
  input  logic    [31:0] i_io_ledr, i_io_ledg,
  input  logic    [6:0]  i_io_hex0, i_io_hex1, i_io_hex2, i_io_hex3, i_io_hex4, i_io_hex5, i_io_hex6, i_io_hex7,
  input  logic    [31:0] i_io_lcd,
  input  logic    i_instvld_MEM, i_br_taken, i_mispred, i_reg_reset,
  input  logic    [31:0] i_pc_debug_MEM,

  output logic [31:0] o_mem         ,
  output logic [31:0] o_pc_plus_four, o_inst,
  output logic [31:0] o_alu_out    ,
  output logic [ 1:0] o_wb_sel      ,
  output logic        o_regWEn,
  output logic [31:0] o_io_ledr, o_io_ledg,
  output logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
  output logic [31:0] o_io_lcd, o_pc_debug_WB,
  output logic i_instvld_WB, o_ctrl, o_mispred, o_reg_reset
);

  always_ff @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin
      o_mem          <= 32'd0;
      o_regWEn       <= 1'd0;
      o_pc_plus_four <= 32'd0;
      o_alu_out      <= 32'd0;
      o_wb_sel       <= 2'd0;
      o_inst         <= 32'd0;
      o_io_ledr      <= 32'd0;
      o_io_ledg      <= 32'd0;
      o_io_hex0      <= 7'h0;
      o_io_hex1      <= 7'h0;
      o_io_hex2      <= 7'h0;
      o_io_hex3      <= 7'h0;
      o_io_hex4      <= 7'h0;
      o_io_hex5      <= 7'h0;
      o_io_hex6      <= 7'h0;
      o_io_hex7      <= 7'h0;
      o_io_lcd       <= 32'h0;
      i_instvld_WB   <= 1'b0;
      o_pc_debug_WB  <= 32'h0;
      o_mispred <= 1'h0;
      o_ctrl <= 1'h0;
      o_reg_reset <= 1'h0;
		end
    else begin
      o_mem          <= i_mem;
      o_regWEn       <= i_regWEn;
      o_pc_plus_four <= i_pc_plus_four;
      o_alu_out      <= i_alu_out;
      o_wb_sel       <= i_wb_sel;
      o_inst         <= i_inst;
      o_io_ledr      <= i_io_ledr;
      o_io_ledg      <= i_io_ledg;
      o_io_hex0      <= i_io_hex0;
      o_io_hex1      <= i_io_hex1;
      o_io_hex2      <= i_io_hex2;
      o_io_hex3      <= i_io_hex3;
      o_io_hex4      <= i_io_hex4;
      o_io_hex5      <= i_io_hex5;
      o_io_hex6      <= i_io_hex6;
      o_io_hex7      <= i_io_hex7;
      o_io_lcd       <= i_io_lcd;
      i_instvld_WB   <= i_instvld_MEM;
      o_pc_debug_WB  <= i_pc_debug_MEM;
      o_mispred      <= i_mispred;
      o_ctrl <= i_br_taken;
      o_reg_reset <= i_reg_reset;
    end
  end

endmodule
