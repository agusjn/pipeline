module memory #(
    parameter DEPTH    = 65535
)(
    input logic i_clk, i_reset,
    input logic [15:0] i_addr,
    input logic [31:0] i_wdata,
    input logic [2:0] i_bmask,
    input logic i_wren,
    output logic [31:0] o_rdata
);
logic [3:0][7:0] ram [DEPTH/4];
logic [$clog2(DEPTH/4)-1:0]  mem_addr;
logic [31:0] result;
assign mem_addr = i_addr[$clog2(DEPTH)-1:2];
integer i;
logic [31:0] data;


always_ff @( posedge i_clk or negedge i_reset ) begin 
    if(!i_reset) begin
        data <=0;
        end
    else if (i_wren) begin
        case(i_bmask)
            3'b000: begin
            if(i_addr[1:0] == 2'h0) begin
                ram[mem_addr][0] <= i_wdata[7:0];
                //ram[mem_addr][1] <= 8'h0;
                //ram[mem_addr][2] <= 8'h0;
                //ram[mem_addr][3] <= 8'h0;
                ram[mem_addr][1] <= ram[mem_addr][1];
                ram[mem_addr][2] <= ram[mem_addr][2];
                ram[mem_addr][3] <= ram[mem_addr][3];
            end
            else if(i_addr[1:0] == 2'h1) begin
                ram[mem_addr][0] <= ram[mem_addr][0];
                //ram[mem_addr][0] <= 8'h0;
                ram[mem_addr][1] <= i_wdata[7:0];
                //ram[mem_addr][2] <= 8'h0;
                //ram[mem_addr][3] <= 8'h0;
                ram[mem_addr][2] <= ram[mem_addr][2];
                ram[mem_addr][3] <= ram[mem_addr][3];
            end
            else if(i_addr[1:0] == 2'h2) begin
                //ram[mem_addr][0] <= 8'h0;
                //ram[mem_addr][1] <= 8'h0;
               	ram[mem_addr][0] <= ram[mem_addr][0];
              	ram[mem_addr][1] <= ram[mem_addr][1];
                ram[mem_addr][2] <= i_wdata[7:0];
                //ram[mem_addr][3] <= 8'h0;
                ram[mem_addr][3] <= ram[mem_addr][3];
            end
            else if(i_addr[1:0] == 2'h3) begin
                //ram[mem_addr][0] <= 8'h0;
                //ram[mem_addr][1] <= 8'h0;
                //ram[mem_addr][2] <= 8'h0;
                ram[mem_addr][0] <= ram[mem_addr][0];
                ram[mem_addr][1] <= ram[mem_addr][1];
                ram[mem_addr][2] <= ram[mem_addr][2];
                ram[mem_addr][3] <= i_wdata[7:0];
            end
            end
            3'b001: begin
            if(i_addr[1:0] == 2'h0) begin
                ram[mem_addr][0] <= i_wdata[7:0];
                ram[mem_addr][1] <= i_wdata[15:8];
                ram[mem_addr][2] <= 8'h0;
                ram[mem_addr][3] <= 8'h0;
                //ram[mem_addr][2] <= ram[mem_addr][2];
                //ram[mem_addr][3] <= ram[mem_addr][3];
            end
            else if(i_addr[1:0] == 2'h1) begin
                ram[mem_addr][0] <= i_wdata[7:0];
                ram[mem_addr][1] <= i_wdata[15:8];
                ram[mem_addr][2] <= 8'h0;
                ram[mem_addr][3] <= 8'h0;
                //ram[mem_addr][2] <= ram[mem_addr][2];
                //ram[mem_addr][3] <= ram[mem_addr][3];
            end
            else if(i_addr[1:0] == 2'h2) begin
                ram[mem_addr][0] <= ram[mem_addr][0];
                ram[mem_addr][1] <= ram[mem_addr][1];
                ram[mem_addr][2] <= i_wdata[7:0];
                ram[mem_addr][3] <= i_wdata[15:8];   
            end
            else if(i_addr[1:0] == 2'h3) begin
                ram[mem_addr][0] <= ram[mem_addr][0];
                ram[mem_addr][1] <= ram[mem_addr][1];
                ram[mem_addr][2] <= i_wdata[7:0];
                ram[mem_addr][3] <= i_wdata[15:8];   
            end
				end
            3'b010: begin
            ram[mem_addr][0] <= i_wdata[7:0];
            ram[mem_addr][1] <= i_wdata[15:8];
            ram[mem_addr][2] <= i_wdata[23:16];
            ram[mem_addr][3] <= i_wdata[31:24];
            end
            default: begin
            ram[mem_addr][0] <= 8'h0;
            ram[mem_addr][1] <= 8'h0;
            ram[mem_addr][2] <= 8'h0;
            ram[mem_addr][3] <= 8'h0;
				end
        endcase
    end
end

logic addr_0, addr_1, addr_2, addr_3;
logic [3:0] addr_en;
assign {addr_3, addr_2, addr_1, addr_0} = addr_en;

conv_addr uut(.i_addr(i_addr[1:0]), .addr_en(addr_en));

always_comb begin
        if(!i_reset) begin
            result = 32'h0;
        end
        else begin
        if(addr_0) begin
            case(i_bmask)
                3'b000: result =  (ram[mem_addr][0][7]) ? {24'hffffff, ram[mem_addr][0]} :  {24'h000000, ram[mem_addr][0]};
                3'b001: result =  (ram[mem_addr][1][7]) ? {16'hffff, ram[mem_addr][1], ram[mem_addr][0]} :  {16'h0000, ram[mem_addr][1], ram[mem_addr][0]};
                3'b010: result = {ram[mem_addr][3], ram[mem_addr][2], ram[mem_addr][1], ram[mem_addr][0]};
                3'b011: result = {24'h000000, ram[mem_addr][0]};
                3'b100: result =  {16'h0000, ram[mem_addr][1], ram[mem_addr][0]};
					 default: result = 32'hdeadbeef;
            endcase
        end
        else if(addr_1) begin
            case(i_bmask)
                3'b000: result =  (ram[mem_addr][1][7]) ? {24'hffffff, ram[mem_addr][1]} :  {24'h000000, ram[mem_addr][1]};
                3'b001: result =  (ram[mem_addr][1][7]) ? {16'hffff, ram[mem_addr][1], ram[mem_addr][0]} :  {16'h0000, ram[mem_addr][1], ram[mem_addr][0]};
                3'b010: result = {ram[mem_addr][3], ram[mem_addr][2], ram[mem_addr][1], ram[mem_addr][0]};
                3'b011: result =  {24'h000000, ram[mem_addr][1]};
                3'b100: result = {16'h0000, ram[mem_addr][1], ram[mem_addr][0]};
					 default: result <= 32'hdeadbeef;
            endcase
        end
        else if(addr_2) begin
            case(i_bmask)
                3'b000: result =  (ram[mem_addr][2][7]) ? {24'hffffff, ram[mem_addr][2]} :  {24'h000000, ram[mem_addr][2]};
                3'b001: result =  (ram[mem_addr][3][7]) ? {16'hffff, ram[mem_addr][3], ram[mem_addr][2]} :  {16'h0000, ram[mem_addr][3], ram[mem_addr][2]};
                3'b010: result = {ram[mem_addr][3], ram[mem_addr][2], ram[mem_addr][1], ram[mem_addr][0]};
                3'b011: result =  {24'h000000, ram[mem_addr][2]};
                3'b100: result = {16'h0000, ram[mem_addr][3], ram[mem_addr][2]};
					 default: result <= 32'hdeadbeef;
            endcase
        end
        else if(addr_3) begin
            case(i_bmask)
                3'b000: result =  (ram[mem_addr][3][7]) ? {24'hffffff, ram[mem_addr][3]} :  {24'h000000, ram[mem_addr][3]};
                3'b001: result =  (ram[mem_addr][3][7]) ? {16'hffff, ram[mem_addr][3], ram[mem_addr][2]} :  {16'h0000, ram[mem_addr][3], ram[mem_addr][2]};
                3'b010: result = {ram[mem_addr][3], ram[mem_addr][2], ram[mem_addr][1], ram[mem_addr][0]};
                3'b011: result =  {24'h000000, ram[mem_addr][3]};
                3'b100: result = {16'h0000, ram[mem_addr][3], ram[mem_addr][2]};
					 default: result <= 32'hdeadbeef;
            endcase
        end
end
end


assign o_rdata = (!i_reset) ? 32'h0 : result;

endmodule



module conv_addr(
    input logic [1:0] i_addr,
    output logic [3:0] addr_en
);

always_comb begin
    case(i_addr)
        2'b00: addr_en = 4'b0001;
        2'b01: addr_en = 4'b0010;
        2'b10: addr_en = 4'b0100;
        2'b11: addr_en = 4'b1000;
		  default: addr_en = 4'h0;
    endcase
end
endmodule