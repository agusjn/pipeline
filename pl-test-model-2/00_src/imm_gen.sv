module ImmGen (
	input logic [31:0] instr, 
  	output logic [31:0] instr_gen  
);

 always_comb begin
        case (instr[6:0])
            7'b0010011: instr_gen = {{20{instr[31]}},instr[31:20]};                // I-type
            7'b0000011: instr_gen = {{20{instr[31]}},instr[31:20]};                // Load
			7'b0100011: instr_gen = {{20{instr[31]}},instr[31:25],instr[11:7]};// Store
			7'b1100011: instr_gen = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8], 1'b0};// B-type 13bit
            7'b1101111: instr_gen = {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};                // JAL 20bit
			7'b0110111: instr_gen = {instr[31:12], 12'h0};  //LUI
			7'b0010111: instr_gen = {instr[31:12], 12'h0}; // AUIPC
			default: instr_gen = {32{1'b0}};
		endcase
end	

endmodule : ImmGen
