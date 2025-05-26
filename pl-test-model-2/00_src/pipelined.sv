module pipelined(
input logic i_clk, i_reset,
input logic [31:0] i_io_sw,
output logic [31:0] o_io_ledr, o_io_ledg,
output logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
output logic [31:0] o_io_lcd,
output logic [31:0] o_pc_debug,
output logic o_insn_vld, o_mispred, o_ctrl
);

logic i_br_taken, reg_reset, reg_reset_EX;
//peripherals
logic [31:0] i_io_ledr, i_io_ledg, i_io_lcd;
logic [6:0] i_io_hex0, i_io_hex1, i_io_hex2, i_io_hex3, i_io_hex4, i_io_hex5, i_io_hex6, i_io_hex7;


//IF_ID
logic [31:0] o_PC_IF, o_instr_IF;
logic [31:0] i_PC_ID, i_instr_ID;

//ID_EX
logic [31:0] o_dataR1_ID, o_dataR2_ID;
logic [31:0] o_imm_ID;
logic o_sela_ID, o_selb_ID;
logic o_brun_ID;
logic [3:0] o_alu_sel_ID;
logic o_rdwren_ID;
logic o_memRW_ID, o_instvld_ID;
logic [1:0] o_wb_sel_ID;
logic [2:0] o_bytenum_ID;

logic [31:0] i_PC_EX, i_EX_inst;
logic [31:0] i_dataR1_EX, i_dataR2_EX;
logic [31:0] i_imm_EX;
logic  i_sela_EX, i_selb_EX;
logic  i_brun_EX;
logic [3:0] i_alu_sel_EX;
logic i_rdwren_EX;
logic i_memRW_EX, i_instvld_EX;
logic [1:0] i_wb_sel_EX;
logic [2:0] i_bytenum_EX;

//EX_MEM
logic [31:0] o_alu_out_EX;
logic [31:0] o_pc_four_EX;
logic [31:0] o_rs2_EX;


logic [31:0] i_alu_out_MEM;
logic [31:0] i_pc_four_MEM;
logic [31:0] i_instr_MEM, i_PC_MEM;
logic [31:0] i_dataR2_MEM;
logic i_rdwren_MEM, i_memRW_MEM, i_instvld_MEM;
logic [1:0]  i_wb_sel_MEM;
logic [2:0]  i_byte_num_MEM;

//MEM_WB
logic [31:0] o_datamem_MEM;

logic [31:0] i_pc_four_WB, i_instr_WB;
logic [31:0] i_alu_out_WB;
logic i_rdwren_WB, i_instvld_WB;
logic [31:0] i_datamem_WB;
logic [1:0] i_wbsel_WB;

//WB
logic [31:0] o_dataW_WB;

//hazard_detection
logic IF_ID_flush, ID_EX_flush, EX_MEM_Flush, MEM_WB_flush, EX_MEM_stall, IF_stall, IF_ID_stall, ID_EX_stall;
logic [1:0] forward_a_sel, forward_b_sel;
logic pc_four_selA, pc_four_selB;

IF IF_module(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .enable(IF_stall),
    .i_alu_data(o_alu_out_EX),
    .i_pc_sel(i_br_taken),
    .o_PC(o_PC_IF),
    .o_instr(o_instr_IF)
);

IF_ID IF_ID_module(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .enable(IF_ID_stall),
    .flush(IF_ID_flush),
    .i_PC(o_PC_IF),
    .i_instr(o_instr_IF),
    .o_PC(i_PC_ID),
    .o_instr(i_instr_ID)
);

ID ID_module(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_instr(i_instr_ID),
    .rd_addr(i_instr_WB[11:7]),
    .rd_data(o_dataW_WB),
    .rd_wren_WB(i_rdwren_WB),
    .opa_sel(o_sela_ID),
    .opb_sel(o_selb_ID),
    .alu_op(o_alu_sel_ID),
    .rd_wren(o_rdwren_ID),
    .br_un(o_brun_ID),
    .mem_wren(o_memRW_ID),
    .wb_sel(o_wb_sel_ID),
    .byte_num(o_bytenum_ID),
    .insn_vld(o_instvld_ID),
    .rs1_data(o_dataR1_ID),
    .rs2_data(o_dataR2_ID),
    .imm_gen(o_imm_ID),
    .regfile_reset(reg_reset)
);
logic o_mispred_EX;
ID_EX ID_EX_module(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .enable(ID_EX_stall),
    .flush(ID_EX_flush),
    .i_PC(i_PC_ID),
    .i_instr(i_instr_ID),
    .i_rs1_data(o_dataR1_ID),
    .i_rs2_data(o_dataR2_ID),
    .i_imm(o_imm_ID),
    .opa_sel(o_sela_ID),
    .opb_sel(o_selb_ID),
    .rd_wren(o_rdwren_ID),
    .br_un(o_brun_ID),
    .mem_wren(o_memRW_ID),
    .insn_vld(o_instvld_ID),
    .alu_op(o_alu_sel_ID),
    .byte_num(o_bytenum_ID),
    .wb_sel(o_wb_sel_ID),
    .i_reg_reset(reg_reset),

    .o_PC(i_PC_EX),
    .o_instr(i_EX_inst),
    .o_datar1(i_dataR1_EX),
    .o_datar2(i_dataR2_EX),
    .o_imm(i_imm_EX),
    .o_opa_sel(i_sela_EX),
    .o_opb_sel(i_selb_EX),
    .o_br_un(i_brun_EX),
    .o_rd_wren(i_rdwren_EX),
    .o_mem_wren(i_memRW_EX),
    .o_insn_vld(i_instvld_EX),
    .o_byte_num(i_bytenum_EX),
    .o_wb_sel(i_wb_sel_EX),
    .o_alu_op(i_alu_sel_EX),
    .o_reg_reset(reg_reset_EX),
    .o_mispred(o_mispred_EX)
);

EX EX_module(
    .alu_op(i_alu_sel_EX),
    .i_PC(i_PC_EX),
    .i_imm(i_imm_EX),
    .br_un(i_brun_EX),
    .opa_sel(i_sela_EX),
    .opb_sel(i_selb_EX),
    .rs1_data(i_dataR1_EX),
    .rs2_data(i_dataR2_EX),
    .pc_plus4_mem(i_pc_four_MEM),
    .pc_plus4_wb(i_pc_four_WB),
    .alu_out_mem(i_alu_out_MEM),
    .dataW_WB(o_dataW_WB),
    .i_instr_EX(i_EX_inst),
    .forward_a_sel(forward_a_sel),
    .forward_b_sel(forward_b_sel),
    .pc_plus_4_sela(pc_four_selA),
    .pc_plus_4_selb(pc_four_selB),

    .o_rs2_data(o_rs2_EX),
    .o_alu_data(o_alu_out_EX),
    .o_pc_plus4(o_pc_four_EX),
    .br_taken(i_br_taken)

);
logic reg_reset_MEM, reg_reset_WB;
logic o_br_taken_MEM;
logic i_mispred_MEM, o_mispred_MEM;
EX_MEM EX_MEM_module(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .flush(EX_MEM_Flush),
    .enable(EX_MEM_stall),
    .i_PC(i_PC_EX),
    .i_instr(i_EX_inst),
    .i_alu_data(o_alu_out_EX),
    .i_dataR2(o_rs2_EX),
    .i_rd_wren(i_rdwren_EX),
    .i_mem_wren(i_memRW_EX),
    .i_insn_vld(i_instvld_EX),
    .i_wb_sel(i_wb_sel_EX),
    .i_byte_num(i_bytenum_EX),
    .i_pc_plus_four(o_pc_four_EX),
    .i_br_taken(i_br_taken),
    .i_reg_reset(reg_reset_EX),
    .i_mispred_EX(o_mispred_EX),

    .o_PC(i_PC_MEM),
    .o_instr(i_instr_MEM),
    .o_alu_data(i_alu_out_MEM),
    .o_dataR2(i_dataR2_MEM),
    .o_rd_wren(i_rdwren_MEM),
    .o_mem_wren(i_memRW_MEM),
    .o_insn_vld(i_instvld_MEM),
    .o_wb_sel(i_wb_sel_MEM),
    .o_byte_num(i_byte_num_MEM),
    .o_pc_plus_four(i_pc_four_MEM),
    .o_br_taken(o_br_taken_MEM),
    .o_mispred(i_mispred_MEM),
    .o_reg_reset(reg_reset_MEM),
    .o_mispred_MEM(o_mispred_MEM)
);

MEM MEM_module(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_lsu_addr(i_alu_out_MEM),
    .i_st_data(i_dataR2_MEM),
    .i_lsu_wren(i_memRW_MEM),
    .i_bmask(i_byte_num_MEM),
    .i_io_sw(i_io_sw),
    .o_ld_data(o_datamem_MEM),
    .o_io_ledr(i_io_ledr),
    .o_io_ledg(i_io_ledg),
    .o_io_hex0(i_io_hex0),
    .o_io_hex1(i_io_hex1),
    .o_io_hex2(i_io_hex2),
    .o_io_hex3(i_io_hex3),
    .o_io_hex4(i_io_hex4),
    .o_io_hex5(i_io_hex5),
    .o_io_hex6(i_io_hex6),
    .o_io_hex7(i_io_hex7),
    .o_io_lcd(i_io_lcd)
);

logic [31:0] o_pc_debug_WB;

MEM_WB MEM_WB_module(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .flush(MEM_WB_flush),
    .i_mem(o_datamem_MEM),
    .i_pc_plus_four(i_pc_four_MEM),
    .i_inst(i_instr_MEM),
    .i_alu_out(i_alu_out_MEM),
    .i_wb_sel(i_wb_sel_MEM),
    .i_regWEn(i_rdwren_MEM),
    .i_io_ledr(i_io_ledr),
    .i_io_ledg(i_io_ledg),
    .i_io_hex0(i_io_hex0),
    .i_io_hex1(i_io_hex1),
    .i_io_hex2(i_io_hex2),
    .i_io_hex3(i_io_hex3),
    .i_io_hex4(i_io_hex4),
    .i_io_hex5(i_io_hex5),
    .i_io_hex6(i_io_hex6),
    .i_io_hex7(i_io_hex7),
    .i_io_lcd(i_io_lcd), 
    .i_instvld_MEM(i_instvld_MEM),
    .i_pc_debug_MEM(i_PC_MEM),
    .i_mispred(o_mispred_MEM),
    .i_br_taken(o_br_taken_MEM),
    .i_reg_reset(reg_reset_MEM),

    .o_mem(i_datamem_WB),
    .o_pc_plus_four(i_pc_four_WB),
    .o_inst(i_instr_WB),
    .o_alu_out(i_alu_out_WB),
    .o_wb_sel(i_wbsel_WB),
    .o_regWEn(i_rdwren_WB),
    .o_io_ledr(o_io_ledr),
    .o_io_ledg(o_io_ledg),
    .o_io_hex0(o_io_hex0),
    .o_io_hex1(o_io_hex1),
    .o_io_hex2(o_io_hex2),
    .o_io_hex3(o_io_hex3),
    .o_io_hex4(o_io_hex4),
    .o_io_hex5(o_io_hex5),
    .o_io_hex6(o_io_hex6),
    .o_io_hex7(o_io_hex7),
    .o_io_lcd(o_io_lcd),
    .i_instvld_WB(i_instvld_WB),
    .o_pc_debug_WB(o_pc_debug_WB),
    .o_mispred(o_mispred),
    .o_ctrl(o_ctrl),
    .o_reg_reset(reg_reset_WB)
);


assign o_insn_vld = i_instvld_WB;
assign o_pc_debug = o_pc_debug_WB;
WB WB_module(
    .i_pc_plus_four(i_pc_four_WB),
    .i_alu(i_alu_out_WB),
    .i_mem(i_datamem_WB),
    .i_WB_sel(i_wbsel_WB),
    .o_dataW(o_dataW_WB)
);



hazard_detection hazard_detection_unit(
    .i_rd_wren_EX(i_rdwren_EX),
    .i_rd_wren_MEM(i_rdwren_MEM),
    .i_rd_wren_WB(i_rdwren_WB),
    .i_br_taken(i_br_taken),
    .i_inst_EX(i_EX_inst),
    .i_instr_MEM(i_instr_MEM),
    .i_instr_WB(i_instr_WB),
    .i_instr_ID(i_instr_ID),
    .IF_ID_flush(IF_ID_flush),
    .ID_EX_flush(ID_EX_flush),
    .EX_MEM_Flush(EX_MEM_Flush),
    .IF_stall(IF_stall),
    .IF_ID_stall(IF_ID_stall),
    .ID_EX_stall(ID_EX_stall),
    .EX_MEM_stall(EX_MEM_stall)
);

forwarding forwarding_unit(
    .i_instr_ID(i_instr_ID),
    .i_instr_EX(i_EX_inst),
    .i_instr_MEM(i_instr_MEM),
    .i_instr_WB(i_instr_WB),
    .i_rd_wren_MEM(i_rdwren_MEM),
    .i_rd_wren_WB(i_rdwren_WB),
    .regfile_reset_WB(reg_reset_WB),
    .regfile_reset_MEM(reg_reset_MEM),
    .forward_a_sel(forward_a_sel),
    .forward_b_sel(forward_b_sel),
    .pc_four_selA(pc_four_selA),
    .pc_four_selB(pc_four_selB)
);

endmodule