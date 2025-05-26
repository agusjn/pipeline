module regfile (
    input logic i_clk,
    input logic rst_n, regfile_reset,
    input logic wren,
    input logic [4:0] rd_addr, rs1_addr, rs2_addr,
    input logic [31:0] rd_data,
    output logic [31:0] rs1_data, rs2_data
);
    logic [31:0] register_file [31:0]; // Bộ nhớ 32 thanh ghi 32-bit
	logic delete;
	
	always_comb begin
		if(regfile_reset) begin
			delete = 1'b1;
		end
		else if(rs1_addr == 5'h0) begin
			delete = 1'b1;
		end
		else delete = 1'b0;
	end
	
	
    // Ghi dữ liệu vào thanh ghi
    always_ff @(posedge i_clk or negedge rst_n) begin
        if (!rst_n)
            register_file <= '{default: 32'h0};
        else if (wren)
            register_file[rd_addr] <= rd_data;
    end

    // Đọc dữ liệu từ thanh ghi
    assign rs1_data = (!delete) ? register_file[rs1_addr] : 32'h0;
    assign rs2_data = (rs2_addr != 5'h0) ? register_file[rs2_addr] : 32'h0;
endmodule
