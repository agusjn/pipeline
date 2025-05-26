module hazard_detection(
	input logic i_br_taken, i_rd_wren_WB, i_rd_wren_MEM, i_rd_wren_EX,
    input logic [31:0] i_inst_EX, i_instr_MEM, i_instr_WB, i_instr_ID,
    output logic ID_EX_flush, EX_MEM_Flush, IF_stall, IF_ID_stall, ID_EX_stall, IF_ID_flush, EX_MEM_stall
);

logic [4:0] rs1_ID, rs2_ID, rsW_MEM, rsW_WB, rsW_EX;
logic [4:0] opcode_EX;
logic is_load, hazard_1,  hazard_2;

assign opcode_EX = i_inst_EX[6:2];
assign opcode_MEM = i_instr_MEM[6:2];
assign is_load_EX = (opcode_EX == 5'b0) ? 1'b1 : 1'b0;
assign is_load_MEM = (opcode_MEM == 5'b0) ? 1'b1 : 1'b0;
assign rs1_ID = i_instr_ID[19:15];
assign rs2_ID = i_instr_ID[24:20];
assign rs1_EX = i_inst_EX[19:15];
assign rs2_EX = i_inst_EX[24:20];
assign rsW_EX = i_inst_EX[11:7];
assign rsW_MEM = i_instr_MEM[11:7];
assign rsW_WB = i_instr_WB[11:7];
assign hazard_1 = (i_rd_wren_WB)  && (rsW_WB != 5'h0)  && ((rsW_WB == rs1_ID)  || (rsW_WB == rs2_ID));
assign hazard_2 = i_rd_wren_EX && is_load_EX && (rsW_EX != 5'h0) && (rsW_EX == rs1_ID || rsW_EX == rs2_ID);
always_comb begin
		ID_EX_flush = 1'h0;
		ID_EX_stall = 1'h1;
		EX_MEM_Flush = 1'h0;
		IF_ID_stall = 1'h1;
		IF_ID_flush =1'h0;
		IF_stall =1'h1;
		EX_MEM_stall =1'h1;
		
    //if(i_rd_wren_MEM & is_load_EX & (rsW_EX != 5'h0) & (rsW_EX == rs1_ID | rsW_EX == rs2_ID)) begin
	if(hazard_2) begin
        //EX_MEM_Flush = 1'b1;
		ID_EX_flush =1'h1;
        IF_stall = 1'b0;
        IF_ID_stall = 1'b0;
    end
	else if(hazard_1) begin
		IF_ID_stall = 1'b0;
		IF_stall = i_br_taken;
		ID_EX_flush = 1'b1;
	end
	else if (i_br_taken)
        begin
              IF_ID_flush = 1'b1;  // Flush the ID stage
			  ID_EX_flush = 1'b1;  // Flush the ID stage
        end
    else begin
		ID_EX_flush = 1'h0;
		ID_EX_stall = 1'h1;
		EX_MEM_Flush = 1'h0;
		IF_ID_stall = 1'h1;
		IF_ID_flush =1'h0;
		IF_stall =1'h1;
    end 
end

endmodule

