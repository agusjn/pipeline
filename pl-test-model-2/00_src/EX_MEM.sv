module EX_MEM(
    input logic i_clk, i_reset, flush, enable,
    input logic [31:0] i_PC, i_instr,
    input logic [31:0] i_alu_data, i_dataR2,
    input logic i_rd_wren, i_mem_wren, i_insn_vld, 
    input logic [1:0] i_wb_sel,
    input logic [2:0] i_byte_num,
    input logic [31:0] i_pc_plus_four,
    input logic i_br_taken, i_reg_reset, i_mispred_EX,


    output logic [31:0] o_PC, o_instr, o_alu_data, o_dataR2,
    output logic o_rd_wren, o_mem_wren, o_insn_vld,
    output logic [1:0] o_wb_sel,
    output logic [2:0] o_byte_num,
    output logic [31:0] o_pc_plus_four,
    output logic o_br_taken, o_mispred, o_reg_reset, o_mispred_MEM
);
assign o_mispred_MEM = i_mispred_EX;


always_ff @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin
    o_PC <= 32'h0;
    o_instr <= 32'h0;
    o_dataR2 <= 32'h0;
    o_rd_wren <= 1'h0;
    o_mem_wren <= 1'h0;
    o_insn_vld <= 1'h0;
    o_byte_num <= 3'h0;
    o_wb_sel <= 2'h0;
    o_alu_data <= 32'h0;
    o_pc_plus_four <= 32'h0;
    o_br_taken <= 1'h0;
    o_mispred <= 1'h0;
    o_reg_reset <= 1'h0;
    end

    else if(flush) begin
    o_PC <= 32'h0;
    o_instr <= 32'h0;
    o_dataR2 <= 32'h0;
    o_rd_wren <= 1'h0;
    o_mem_wren <= 1'h0;
    o_insn_vld <= 1'h0;
    o_byte_num <= 3'h0;
    o_wb_sel <= 2'h0;
    o_alu_data <= 32'h0;
    o_pc_plus_four <= 32'h0;
    o_br_taken <= 1'h0;
    o_mispred <= 1'h1;
    o_reg_reset <= 1'h0;
    end
    else if(!enable) begin
        o_PC <= o_PC;
        o_instr <= o_instr;
        o_dataR2 <= o_dataR2;
        o_rd_wren <= o_rd_wren;
        o_mem_wren <= o_mem_wren;
        o_insn_vld <= o_insn_vld;
        o_byte_num <= o_byte_num;
        o_wb_sel <= o_wb_sel;
        o_alu_data <= o_alu_data;
        o_pc_plus_four <= o_pc_plus_four;
        o_br_taken <= o_br_taken;
        o_mispred <= o_mispred;
        o_reg_reset <= o_reg_reset;
    end

    else begin
        o_PC <= i_PC;
        o_instr <= i_instr;
        o_dataR2 <= i_dataR2;
        o_rd_wren <= i_rd_wren;
        o_mem_wren <= i_mem_wren;
        o_insn_vld <= i_insn_vld;
        o_byte_num <= i_byte_num;
        o_wb_sel <= i_wb_sel;
        o_alu_data <= i_alu_data;
        o_pc_plus_four <= i_pc_plus_four;
        o_br_taken <= i_br_taken;
        o_mispred <= 1'h0;
        o_reg_reset <= i_reg_reset;
    end

end

endmodule