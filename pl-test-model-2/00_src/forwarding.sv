module forwarding(
    input logic [31:0] i_instr_EX, i_instr_MEM, i_instr_WB,  i_instr_ID,
    input logic i_rd_wren_MEM, i_rd_wren_WB, regfile_reset_MEM, regfile_reset_WB,
    output logic [1:0] forward_a_sel, forward_b_sel,
    output logic pc_four_selA, pc_four_selB
);


logic [4:0] rs1_EX, rs2_EX, rsw_MEM, rsw_WB, rs1_ID, rs2_ID;

assign rs1_ID = i_instr_ID[19:15];
assign rs2_ID = i_instr_ID[24:20];

assign rs1_EX = i_instr_EX[19:15];
assign rs2_EX = i_instr_EX[24:20];
assign rsw_MEM = i_instr_MEM[11:7];
assign rsw_WB = i_instr_WB[11:7];

logic [4:0] opcode_MEM, opcode_WB;
assign opcode_MEM = i_instr_MEM[6:2];
assign opcode_WB = i_instr_WB[6:2];

logic is_jump_MEM, is_jump_WB;
assign is_jump_MEM = (opcode_MEM == 5'b11011) | (opcode_MEM == 5'b11001);
assign is_jump_WB  = (opcode_WB == 5'b11011) | (opcode_WB == 5'b11001);

  always_comb begin
    forward_a_sel   = 2'b00;
    forward_b_sel   = 2'b00;
    pc_four_selA = 1'b0;
    pc_four_selB = 1'b0;

            // A
    if(i_rd_wren_MEM & (rsw_MEM != 5'd0) & (rsw_MEM == rs1_EX)) begin
      if(is_jump_MEM) begin
        forward_a_sel   = 2'b11;
        pc_four_selA = 1'b0;
      end else begin
        forward_a_sel = 2'b10;
      end
    end else if(i_rd_wren_WB & (rsw_WB != 5'd0) & (rsw_WB == rs1_EX)) begin
      if(is_jump_WB) begin
        forward_a_sel   = 2'b11;
        pc_four_selA = 1'b1;
      end else begin
        forward_a_sel = 2'b01;
      end
    end

    // B
    if(i_rd_wren_MEM & (rsw_MEM != 5'd0) & (rsw_MEM == rs2_EX)) begin
      if(is_jump_MEM) begin
        forward_b_sel   = 2'b11;
        pc_four_selB = 1'b0;
      end else begin
        forward_b_sel = 2'b10;
      end
    end else if(i_rd_wren_WB & (rsw_WB != 5'd0) & (rsw_WB == rs2_EX)) begin
      if(is_jump_WB) begin
        forward_b_sel   = 2'b11;
        pc_four_selB = 1'b1;
      end else begin
        forward_b_sel = 2'b01;
      end
    end
  end
endmodule