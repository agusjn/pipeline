module lsu(
 input logic i_clk, i_reset,
 input logic [31:0] i_lsu_addr, i_st_data,
 input logic i_lsu_wren,
 input logic [2:0] i_bmask,
 input logic [31:0] i_io_sw,
 output logic [31:0] o_ld_data, o_io_ledr, o_io_ledg,
 output logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
 output logic [31:0] o_io_lcd 
);

logic [5:0] lsu_addr;
logic mem_en, redleg_en, greenled_en, led_30_en, led_74_en, lcd_en, sw_en;
logic [6:0] en_case;
logic [31:0] per_data_o;
logic [31:0] mem_data_o;
logic i_wren;

assign lsu_addr  = {i_lsu_addr[28], i_lsu_addr[16], i_lsu_addr[15], i_lsu_addr[14], i_lsu_addr[13], i_lsu_addr[12]};

decoder_addr enable_src(.lsu_addr(lsu_addr), .en_case(en_case));
assign {mem_en, redleg_en, greenled_en, led_30_en, led_74_en, lcd_en, sw_en} = en_case;
assign i_wren = i_lsu_wren & mem_en;
memory dmem (.i_clk(i_clk), .i_reset(i_reset), .i_addr(i_lsu_addr[15:0]), .i_wdata(i_st_data), .i_bmask(i_bmask), .i_wren(i_wren), .o_rdata(mem_data_o));

always_ff @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin
        o_io_ledr <= 32'h0;
        o_io_ledg <= 32'h0;
        o_io_hex0 <= 7'h0;
        o_io_hex1 <= 7'h0;
        o_io_hex2 <= 7'h0;
        o_io_hex3 <= 7'h0;
        o_io_hex4 <= 7'h0;
        o_io_hex5 <= 7'h0;
        o_io_hex6 <= 7'h0;
        o_io_hex7 <= 7'h0;
        o_io_lcd <= 32'h0;
    end
    else if(i_lsu_wren) begin
        if(redleg_en) begin
            case(i_bmask) 
                3'b000: o_io_ledr[7:0] <= i_st_data[7:0];
                3'b001: o_io_ledr[15:0] <= i_st_data[15:0];
                3'b010: o_io_ledr <= i_st_data;
                default: o_io_ledr <= o_io_ledr;
            endcase
        end

        else if(greenled_en) begin
            case(i_bmask) 
                3'b000: o_io_ledg[7:0] <= i_st_data[7:0];
                3'b001: o_io_ledg[15:0] <= i_st_data[15:0];
                3'b010: o_io_ledg <= i_st_data;
                default: o_io_ledg <= o_io_ledg;
            endcase
        end

        else if(led_30_en) begin
                o_io_hex0 <= i_st_data[6:0];
                o_io_hex1 <= i_st_data[14:8];
                o_io_hex2 <= i_st_data[22:16];
                o_io_hex3 <= i_st_data[30:24];     
        end

        else if(led_74_en) begin
                o_io_hex4 <= i_st_data[6:0];
                o_io_hex5 <= i_st_data[14:8];
                o_io_hex6 <= i_st_data[22:16];
                o_io_hex7 <= i_st_data[30:24];
        end

        else if(lcd_en) begin
            o_io_lcd <= i_st_data;
        end
end
end

always_comb begin
    if(mem_en && !i_lsu_wren) per_data_o = mem_data_o;
    else if (redleg_en && !i_lsu_wren) begin
        case(i_bmask)
                3'b000: per_data_o = (o_io_ledr[7]) ? {24'hffffff, o_io_ledr[7:0]} : {24'h000000, o_io_ledr[7:0]};
                3'b001: per_data_o = (o_io_ledr[15]) ? {16'hffff, o_io_ledr[15:0]} : {16'h0000, o_io_ledr[15:0]};
                3'b010: per_data_o = o_io_ledr;
                3'b011: per_data_o = {24'h000000, o_io_ledr[7:0]};
                3'b100: per_data_o = {16'h0000, o_io_ledr[15:0]};
                default: per_data_o = 32'b0;
        endcase
    end
    else if (greenled_en && !i_lsu_wren) begin
        case(i_bmask)
                3'b000: per_data_o = (o_io_ledg[7]) ? {24'hffffff, o_io_ledg[7:0]} : {24'h000000, o_io_ledg[7:0]};
                3'b001: per_data_o = (o_io_ledg[15]) ? {16'hffff, o_io_ledg[15:0]} : {16'h0000, o_io_ledg[15:0]};
                3'b010: per_data_o = o_io_ledg;
                3'b011: per_data_o = {24'h000000, o_io_ledg[7:0]};
                3'b100: per_data_o = {16'h0000, o_io_ledg[15:0]};
                default: per_data_o = 32'b0;
        endcase
    end

    else if (led_30_en && !i_lsu_wren) begin
        case(i_bmask)
                3'b000: per_data_o = {25'h0, o_io_hex0};
                3'b001: per_data_o = {17'h0, o_io_hex1, 1'b0, o_io_hex0};
                3'b010: per_data_o = {1'b0, o_io_hex3, 1'b0, o_io_hex2, 1'b0, o_io_hex1, 1'b0, o_io_hex0};
                3'b011: per_data_o = {25'h0, o_io_hex0};
                3'b100: per_data_o = {17'h0, o_io_hex1, 1'b0, o_io_hex0};
                default: per_data_o = 32'b0;
        endcase        
    end

    else if (led_74_en && !i_lsu_wren) begin
        case(i_bmask)
                3'b000: per_data_o = {25'h0, o_io_hex4};
                3'b001: per_data_o = {17'h0, o_io_hex5, 1'b0, o_io_hex4};
                3'b010: per_data_o = {1'b0, o_io_hex7, 1'b0, o_io_hex6, 1'b0, o_io_hex5, 1'b0, o_io_hex4};
                3'b011: per_data_o = {25'h0, o_io_hex4};
                3'b100: per_data_o = {17'h0, o_io_hex5, 1'b0, o_io_hex4};
                default: per_data_o = 32'b0;
        endcase
    end

    else if (sw_en && !i_lsu_wren) begin
        case(i_bmask)
                3'b000: per_data_o = (i_io_sw[7]) ? {24'hffffff, i_io_sw[7:0]} : {24'h000000, i_io_sw[7:0]};
                3'b001: per_data_o = (i_io_sw[15]) ? {16'hffff, i_io_sw[15:0]} : {16'h0000, i_io_sw[15:0]};
                3'b010: per_data_o = i_io_sw;
                3'b011: per_data_o = {24'h000000, i_io_sw[7:0]};
                3'b100: per_data_o = {16'h0000, i_io_sw[15:0]};
                default: per_data_o = 32'b0;
        endcase
    end
    else per_data_o = 32'b0;
end

assign o_ld_data = (!i_reset) ? 32'h0 : per_data_o;


endmodule




module decoder_addr(
    input logic [5:0] lsu_addr,
    output logic [6:0] en_case
);
    always_comb begin
			if(lsu_addr[5:4] == 2'b00) en_case = 7'b1000000;
			else begin
				case(lsu_addr)  //{i_lsu_addr[28], i_lsu_addr[16], i_lsu_addr[15], i_lsu_addr[14], i_lsu_addr[13], i_lsu_addr[12]};
            6'b100000: en_case = 7'b0100000;    //addr_redled
            6'b100001: en_case = 7'b0010000;    //addr_greenled
            6'b100010: en_case = 7'b0001000;    //addr_seven_led_3-0
            6'b100011: en_case = 7'b0000100;    //addr_seven_led_7-4
            6'b100100: en_case = 7'b0000010;    //addr_LCD
            6'b110000: en_case = 7'b0000001;    //addr_switches
            default: en_case = 7'h0;
        endcase
		  end
    end
endmodule