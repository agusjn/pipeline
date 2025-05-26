module ID(
    input logic i_clk, i_reset,
    input logic [31:0] i_instr,
    input logic [4:0] rd_addr,
    input logic [31:0] rd_data,
    input logic  rd_wren_WB,

    output logic opa_sel, opb_sel,
    output logic [3:0] alu_op,
    output logic rd_wren,
    output logic br_un,
    output logic mem_wren,
    output logic [1:0] wb_sel,
    output logic [2:0] byte_num, 
    output logic insn_vld, regfile_reset,


    output logic [31:0] rs1_data, rs2_data,
    output logic [31:0] imm_gen
);

logic reg_file_reset;



ImmGen immgen_module(
    .instr(i_instr),
    .instr_gen(imm_gen)
);

regfile regfile_module(
    .i_clk(i_clk),
    .rst_n(i_reset),
    .regfile_reset(reg_file_reset),
    .wren(rd_wren_WB),
    .rd_addr(rd_addr),
    .rs1_addr(i_instr[19:15]),
    .rs2_addr(i_instr[24:20]),
    .rd_data(rd_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);

control_unit CU_module(
    .instr(i_instr),
    .opa_sel(opa_sel),
    .opb_sel(opb_sel),
    .alu_op(alu_op),
    .rd_wren(rd_wren),
    .mem_wren(mem_wren),
    .wb_sel(wb_sel),
    .byte_num(byte_num),
    .regfile_reset(reg_file_reset),
    .br_un(br_un),
    .insn_vld(insn_vld)
);
assign regfile_reset = reg_file_reset;
endmodule