module control_unit(
    input logic [31:0] instr,
    input logic br_equal, br_less,
    output logic rd_wren, insn_vld, br_un, opa_sel, opb_sel, mem_wren, regfile_reset,
    output logic [3:0] alu_op,
    output logic [2:0] byte_num,
    output logic [1:0] wb_sel
);
logic [5:0] addr;
logic [6:0] opcode;
logic [2:0] funct3;
logic funct7;
logic [15:0] result;


assign opcode =  instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[30];

encoder_addr addresses(.opcode(opcode), .funct3(funct3), .funct7(funct7), .br_equal(br_equal), .br_less(br_less), .addr(addr));
rom rom(.addr_rom(addr) ,.result(result));

assign {rd_wren, insn_vld, br_un, opa_sel, opb_sel, alu_op, byte_num, mem_wren, wb_sel, regfile_reset} = result;

endmodule

module rom(
    input logic [5:0] addr_rom,
    output logic [15:0] result
);

logic [15:0] rom [0:43];


always_comb begin 
    case(addr_rom)
        6'd0: result = 16'b0_0_0_0_0_0000_000_0_00_0;
        6'd1: result = 16'b1_1_0_0_1_0000_000_0_01_0;
        6'd2: result = 16'b1_1_0_0_1_0001_000_0_01_0;
        6'd3: result = 16'b1_1_0_0_1_0010_000_0_01_0;
        6'd4: result = 16'b1_1_0_0_1_0011_000_0_01_0;
        6'd5: result = 16'b1_1_0_0_1_0100_000_0_01_0;
        6'd6: result = 16'b1_1_0_0_1_0101_000_0_01_0;
        6'd7: result = 16'b1_1_0_0_1_0110_000_0_01_0;
        6'd8: result = 16'b1_1_0_0_1_0111_000_0_01_0;
        6'd9: result = 16'b1_1_0_0_1_1000_000_0_01_0;
        6'd10: result = 16'b1_1_0_0_1_1001_000_0_01_0;
        6'd11: result = 16'b1_1_0_0_0_0000_000_0_01_0;
        6'd12: result = 16'b1_1_0_0_0_0010_000_0_01_0;
        6'd13: result = 16'b1_1_0_0_0_0011_000_0_01_0;
        6'd14: result = 16'b1_1_0_0_0_0100_000_0_01_0;
        6'd15: result = 16'b1_1_0_0_0_0101_000_0_01_0;
        6'd16: result = 16'b1_1_0_0_0_0110_000_0_01_0;
        6'd17: result = 16'b1_1_0_0_0_0111_000_0_01_0;
        6'd18: result = 16'b1_1_0_0_0_1000_000_0_01_0;
        6'd19: result = 16'b1_1_0_0_0_1001_000_0_01_0;
        6'd20: result = 16'b0_1_0_1_0_0000_000_0_00_0;
        6'd21: result = 16'b0_1_0_1_0_0000_000_0_00_0;
        6'd22: result = 16'b0_1_0_1_0_0000_000_0_00_0;
        6'd23: result = 16'b0_1_0_1_0_0000_000_0_00_0;
        6'd24: result = 16'b0_1_0_1_0_0000_000_0_00_0;
        6'd25: result = 16'b0_1_0_1_0_0000_000_0_00_0;
        6'd26: result = 16'b0_1_0_1_0_0000_000_0_00_0;
        6'd27: result = 16'b0_1_0_1_0_0000_000_0_00_0;
        6'd28: result = 16'b0_1_1_1_0_0000_000_0_00_0;
        6'd29: result = 16'b0_1_1_1_0_0000_000_0_00_0;
        6'd30: result = 16'b0_1_1_1_0_0000_000_0_00_0;
        6'd31: result = 16'b0_1_1_1_0_0000_000_0_00_0;
        6'd32: result = 16'b1_1_0_0_0_0000_000_0_00_0;
        6'd33: result = 16'b1_1_0_0_0_0000_001_0_00_0;
        6'd34: result = 16'b1_1_0_0_0_0000_010_0_00_0;
        6'd35: result = 16'b1_1_0_0_0_0000_011_0_00_0;
        6'd36: result = 16'b1_1_0_0_0_0000_100_0_00_0;
        6'd37: result = 16'b0_1_0_0_0_0000_000_1_00_0;
        6'd38: result = 16'b0_1_0_0_0_0000_001_1_00_0;
        6'd39: result = 16'b0_1_0_0_0_0000_010_1_00_0;
        6'd40: result = 16'b1_1_0_1_0_0000_000_0_10_0;
        6'd41: result = 16'b1_1_0_0_0_0000_000_0_10_0;
        6'd42: result = 16'b1_1_0_1_0_0000_000_0_01_0;
        6'd43: result = 16'b1_1_0_0_0_0000_000_0_01_1;
        default: result = 16'b0000000000000000;
			//{rd_wren, insn_vld, br_un, opa_sel, opb_sel, alu_op, byte_num, mem_wren, wb_sel, regfile_reset}
	 endcase
end
endmodule

module encoder_addr(
    input logic funct7, br_equal, br_less,
    input logic [2:0] funct3,
    input logic [6:0] opcode,
    output logic [5:0] addr
);
parameter [6:0] LUI    = 7'b0110111,
                AUIPC  = 7'b0010111,
                JAL    = 7'b1101111,
                JALR   = 7'b1100111,
                B_type = 7'b1100011,
                LOAD   = 7'b0000011,
                STORE  = 7'b0100011,
                I_type = 7'b0010011,
                R_type = 7'b0110011;
    
parameter [2:0]  ADD_SUB_ADDI_BEQ_LB_SB  = 3'b000,
            BNE_LH_SH_SLLI_SLL     = 3'b001,
            BLT_LBU_XORI       = 3'b100,
            BGE_LHU_SRLI_SRAI  = 3'b101,
            BLTU_ORI           = 3'b110,
            BGEU_ANDI          = 3'b111,
            LW_SW_SLTI_SLT         = 3'b010,
            SLTIU_SLTU              = 3'b011;

always_comb begin
    case(opcode)
        R_type: begin
            case(funct3)
                ADD_SUB_ADDI_BEQ_LB_SB: addr = (~funct7) ? 6'd1 : 6'd2;   //address of add, sub
                LW_SW_SLTI_SLT: addr = 6'd3;   //SLT
                SLTIU_SLTU: addr = 6'd4;       //SLTU
                BLT_LBU_XORI: addr = 6'd5;     //XOR
                BLTU_ORI: addr = 6'd6;         //OR
                BGEU_ANDI: addr = 6'd7;        //AND
                BNE_LH_SH_SLLI_SLL: addr = 6'd8;   //SLL
                BGE_LHU_SRLI_SRAI: addr = (~funct7) ? 6'd9 : 6'd10; //address of SRL, SRA
				default: addr = 6'd0;
            endcase
        end
    
        I_type: begin
            case(funct3)
                ADD_SUB_ADDI_BEQ_LB_SB: addr = 6'd11;   //address of addi
                LW_SW_SLTI_SLT: addr = 6'd12;   //SLTI
                SLTIU_SLTU: addr = 6'd13;       //SLTIU
                BLT_LBU_XORI: addr = 6'd14;     //XORI
                BLTU_ORI: addr = 6'd15;         //ORI
                BGEU_ANDI: addr = 6'd16;        //ANDI
                BNE_LH_SH_SLLI_SLL: addr = 6'd17;   //SLLI
                BGE_LHU_SRLI_SRAI: addr = (~funct7) ? 6'd18 : 6'd19; //address of SRLI, SRAI
				default: addr = 6'd0;
            endcase
        end

        
        B_type: begin
            case(funct3)    
                ADD_SUB_ADDI_BEQ_LB_SB: addr = 6'd20;    //BEQ dia chi cao la nhay, thap la khong nhay
                BNE_LH_SH_SLLI_SLL: addr =  6'd22;        //BNE
                BLT_LBU_XORI: addr = 6'd24;               //BLT
                BGE_LHU_SRLI_SRAI: addr = 6'd26;                      //BGE
                BLTU_ORI: addr = 6'd28;                   //BLTU
                BGEU_ANDI: addr = 6'd30;                               // BGEU
				default: addr = 6'd0;
            endcase
        end 

        LOAD: begin
            case(funct3)
                ADD_SUB_ADDI_BEQ_LB_SB: addr = 6'd32;      //LB
                BNE_LH_SH_SLLI_SLL: addr = 6'd33;          //LH
                LW_SW_SLTI_SLT: addr = 6'd34;              //LW
                BLT_LBU_XORI: addr = 6'd35;                //LBU
                BGE_LHU_SRLI_SRAI: addr = 6'd36;           //LHU
					 default: addr = 6'd0;
            endcase
        end

        STORE: begin
            case(funct3)
                ADD_SUB_ADDI_BEQ_LB_SB: addr = 6'd37;      //SB
                BNE_LH_SH_SLLI_SLL: addr = 6'd38;          //SH
                LW_SW_SLTI_SLT: addr = 6'd39;               //SW
					 default: addr = 6'd0;
            endcase
        end

        JAL: addr = 6'd40;     //JAL
        JALR: addr = 6'd41;    //JALR
        AUIPC: addr = 6'd42;   //AUIPC
        LUI:  addr = 6'd43;    //LUI
		  default: addr = 6'd0;
    endcase
end
endmodule