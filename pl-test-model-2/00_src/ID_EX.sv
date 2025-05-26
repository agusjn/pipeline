module ID_EX(
    input logic i_clk, i_reset, flush, enable,
    input logic [31:0] i_PC, i_instr,
    input logic [31:0] i_rs1_data, i_rs2_data,
    input logic [31:0] i_imm,
    input logic opa_sel, opb_sel, rd_wren, br_un, mem_wren, insn_vld, i_reg_reset,
    input logic [3:0] alu_op,
    input logic [2:0] byte_num, 
    input logic [1:0] wb_sel,
    
    output logic [31:0] o_PC, o_instr,
    output logic [31:0] o_datar1, o_datar2, o_imm,
    output logic  o_opa_sel, o_opb_sel, o_mispred,
    output logic o_br_un, o_rd_wren, o_mem_wren, o_insn_vld, o_reg_reset,
    output logic [2:0] o_byte_num,
    output logic [1:0] o_wb_sel,
    output logic [3:0] o_alu_op
);

always_ff @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin
    o_PC <= 32'h0;
    o_instr <= 32'h0;
    o_datar1 <= 32'h0;
    o_datar2 <= 32'h0;
    o_imm <= 32'h0;
    o_opa_sel <= 1'h0;
    o_opb_sel <= 1'h0;
    o_br_un <= 1'h0;
    o_rd_wren <= 1'h0;
    o_mem_wren <= 1'h0;
    o_insn_vld <= 1'h0;
    o_byte_num <= 3'h0;
    o_wb_sel <= 2'h0;
    o_alu_op  <= 4'h0;
    o_reg_reset <= 1'h0;
    o_mispred <= 1'h0;
    end
    
    else if(flush) begin
    o_PC <= 32'h0;
    o_instr <= 32'h0;
    o_datar1 <= 32'h0;
    o_datar2 <= 32'h0;
    o_imm <= 32'h0;
    o_opa_sel <= 1'h0;
    o_opb_sel <= 1'h0;
    o_br_un <= 1'h0;
    o_rd_wren <= 1'h0;
    o_mem_wren <= 1'h0;
    o_insn_vld <= 1'h0;
    o_byte_num <= 3'h0;
    o_wb_sel <= 2'h0;
    o_alu_op  <= 4'h0;
    o_reg_reset <= 1'h0;
    o_mispred <= 1'h1;
    end
    else if(!enable) begin
    o_PC <= o_PC;
    o_instr <= o_instr;
    o_datar1 <= o_datar1;
    o_datar2 <= o_datar2;
    o_imm <= o_imm;
    o_opa_sel <= o_opa_sel;
    o_opb_sel <= o_opb_sel;
    o_br_un <= o_br_un;
    o_rd_wren <= o_rd_wren;
    o_mem_wren <= o_mem_wren;
    o_insn_vld <= o_insn_vld;
    o_byte_num <= o_byte_num;
    o_wb_sel <= o_wb_sel;
    o_alu_op  <= o_alu_op;
    o_reg_reset <= o_reg_reset;
    o_mispred <= o_mispred;
    end
    else begin
    o_PC <= i_PC;
    o_instr <= i_instr;
    o_datar1 <= i_rs1_data;
    o_datar2 <= i_rs2_data;
    o_imm <= i_imm;
    o_opa_sel <= opa_sel;
    o_opb_sel <= opb_sel;
    o_br_un <= br_un;
    o_rd_wren <= rd_wren;
    o_mem_wren <= mem_wren;
    o_insn_vld <= insn_vld;
    o_byte_num <= byte_num;
    o_wb_sel <= wb_sel;
    o_alu_op  <= alu_op;
    o_reg_reset <= i_reg_reset;
    o_mispred <= 1'h0;
    end


end


endmodule