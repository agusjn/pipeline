module EX(
    input logic [3:0] alu_op,
    input logic [31:0] i_PC,
    input logic [31:0] i_imm,
    input logic br_un,
    input logic opa_sel, opb_sel,
    input logic [31:0] rs1_data, rs2_data ,
    input logic [1:0] forward_a_sel, forward_b_sel,
    input logic pc_plus_4_sela, pc_plus_4_selb,
    input logic [31:0] pc_plus4_mem, pc_plus4_wb,
    input logic [31:0] alu_out_mem, dataW_WB,
    input logic [31:0] i_instr_EX,
    
    output logic [31:0] o_rs2_data,
    output logic [31:0] o_alu_data,
    output logic [31:0] o_pc_plus4,
    output logic br_taken
);

assign o_pc_plus4 = i_PC +32'd4;

logic [31:0] inA, inB;
logic [31:0] forwardA, forwardB;
logic [31:0] pc_plus_fourA, pc_plus_fourB;
assign pc_plus_fourA = pc_plus_4_sela ? pc_plus4_wb : pc_plus4_mem;
assign pc_plus_fourB = pc_plus_4_selb ? pc_plus4_wb : pc_plus4_mem;

logic BrEq, BrLT;

assign forwardA = (forward_a_sel == 2'b11) ? pc_plus_fourA : (forward_a_sel == 2'b10) ? alu_out_mem : (forward_a_sel == 2'b01) ? dataW_WB : rs1_data;
assign forwardB = (forward_b_sel == 2'b11) ? pc_plus_fourB : (forward_b_sel == 2'b10) ? alu_out_mem : (forward_b_sel == 2'b01) ? dataW_WB : rs2_data;

assign inA = opa_sel ? i_PC : forwardA;
assign inB = opb_sel ? forwardB : i_imm;

logic [2:0] funct3;
logic       Btype, Jtype;
assign funct3 = i_instr_EX[14:12];
assign Btype        = (i_instr_EX[6:2] == 5'b11000);
assign Jtype        = (i_instr_EX[6:4] == 3'b110) & i_instr_EX[2];                      // jal, jalr
assign br_taken = Jtype | (Btype & ((funct3 == 3'b000 & BrEq) | (funct3 == 3'b001 & ~BrEq) | ({funct3[2], funct3[0]} == 2'b10 & BrLT) | ({funct3[2], funct3[0]} == 2'b11 & ~BrLT)));



alu alu_module(
    .i_operand_a(inA),
    .i_operand_b(inB),
    .i_alu_op(alu_op),
    .o_alu_data(o_alu_data)
);

brc brc_module(
    .i_rs1_data(forwardA),
    .i_rs2_data(forwardB),
    .i_brc_un(br_un),
    .o_brc_less(BrLT),
    .o_brc_equal(BrEq)
);

assign o_rs2_data = forwardB;
endmodule