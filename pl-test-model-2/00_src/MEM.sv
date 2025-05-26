module MEM(
input logic i_clk, i_reset,
input logic [31:0] i_lsu_addr, i_st_data,
input logic i_lsu_wren,
input logic [2:0] i_bmask,
input logic [31:0] i_io_sw,
output logic [31:0] o_ld_data, o_io_ledr, o_io_ledg,
output logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
output logic [31:0] o_io_lcd 
);



lsu lsu_block(  .i_clk(i_clk), .i_reset(i_reset), .i_lsu_addr(i_lsu_addr), .i_st_data(i_st_data), .i_lsu_wren(i_lsu_wren), .i_bmask(i_bmask), .i_io_sw(i_io_sw), 
                .o_ld_data(o_ld_data), .o_io_ledr(o_io_ledr), .o_io_ledg(o_io_ledg), .o_io_hex0(o_io_hex0), .o_io_hex1(o_io_hex1), 
                .o_io_hex2(o_io_hex2), .o_io_hex3(o_io_hex3), .o_io_hex4(o_io_hex4), .o_io_hex5(o_io_hex5), .o_io_hex6(o_io_hex6), 
                .o_io_hex7(o_io_hex7), .o_io_lcd(o_io_lcd));




endmodule