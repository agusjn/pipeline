module srl #(parameter N = 32) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [N-1:0] o_srl
);

    always_comb begin
        case (b[4:0]) 
            5'b00000: o_srl = a;
            5'b00001: o_srl = {1'd0, a[N-1:1]};
            5'b00010: o_srl = {2'd0, a[N-1:2]};
            5'b00011: o_srl = {3'd0, a[N-1:3]};
            5'b00100: o_srl = {4'd0, a[N-1:4]};
            5'b00101: o_srl = {5'd0, a[N-1:5]};
            5'b00110: o_srl = {6'd0, a[N-1:6]};
            5'b00111: o_srl = {7'd0, a[N-1:7]};
            5'b01000: o_srl = {8'd0, a[N-1:8]};
            5'b01001: o_srl = {9'd0, a[N-1:9]};
            5'b01010: o_srl = {10'd0, a[N-1:10]};
            5'b01011: o_srl = {11'd0, a[N-1:11]};
            5'b01100: o_srl = {12'd0, a[N-1:12]};
            5'b01101: o_srl = {13'd0, a[N-1:13]};
            5'b01110: o_srl = {14'd0, a[N-1:14]};
            5'b01111: o_srl = {15'd0, a[N-1:15]};
            5'b10000: o_srl = {16'd0, a[N-1:16]};
            5'b10001: o_srl = {17'd0, a[N-1:17]};
            5'b10010: o_srl = {18'd0, a[N-1:18]};
            5'b10011: o_srl = {19'd0, a[N-1:19]};
            5'b10100: o_srl = {20'd0, a[N-1:20]};
            5'b10101: o_srl = {21'd0, a[N-1:21]};
            5'b10110: o_srl = {22'd0, a[N-1:22]};
            5'b10111: o_srl = {23'd0, a[N-1:23]};
            5'b11000: o_srl = {24'd0, a[N-1:24]};
            5'b11001: o_srl = {25'd0, a[N-1:25]};
            5'b11010: o_srl = {26'd0, a[N-1:26]};
            5'b11011: o_srl = {27'd0, a[N-1:27]};
            5'b11100: o_srl = {28'd0, a[N-1:28]};
            5'b11101: o_srl = {29'd0, a[N-1:29]};
            5'b11110: o_srl = {30'd0, a[N-1:30]};
            5'b11111: o_srl = {31'd0, a[N-1:31]};
            default:  o_srl = 32'h0; 
        endcase
    end

endmodule
