module sll #(parameter N = 32) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [N-1:0] o_sll
);

    always_comb begin
        case (b[4:0]) 
            5'b00000: o_sll = a;
            5'b00001: o_sll = {a[N-2:0], 1'b0};
            5'b00010: o_sll = {a[N-3:0], 2'b0};
            5'b00011: o_sll = {a[N-4:0], 3'b0};
            5'b00100: o_sll = {a[N-5:0], 4'b0};
            5'b00101: o_sll = {a[N-6:0], 5'b0};
            5'b00110: o_sll = {a[N-7:0], 6'b0};
            5'b00111: o_sll = {a[N-8:0], 7'b0};
            5'b01000: o_sll = {a[N-9:0], 8'b0};
            5'b01001: o_sll = {a[N-10:0], 9'b0};
            5'b01010: o_sll = {a[N-11:0], 10'b0};
            5'b01011: o_sll = {a[N-12:0], 11'b0};
            5'b01100: o_sll = {a[N-13:0], 12'b0};
            5'b01101: o_sll = {a[N-14:0], 13'b0};
            5'b01110: o_sll = {a[N-15:0], 14'b0};
            5'b01111: o_sll = {a[N-16:0], 15'b0};
            5'b10000: o_sll = {a[N-17:0], 16'b0};
            5'b10001: o_sll = {a[N-18:0], 17'b0};
            5'b10010: o_sll = {a[N-19:0], 18'b0};
            5'b10011: o_sll = {a[N-20:0], 19'b0};
            5'b10100: o_sll = {a[N-21:0], 20'b0};
            5'b10101: o_sll = {a[N-22:0], 21'b0};
            5'b10110: o_sll = {a[N-23:0], 22'b0};
            5'b10111: o_sll = {a[N-24:0], 23'b0};
            5'b11000: o_sll = {a[N-25:0], 24'b0};
            5'b11001: o_sll = {a[N-26:0], 25'b0};
            5'b11010: o_sll = {a[N-27:0], 26'b0};
            5'b11011: o_sll = {a[N-28:0], 27'b0};
            5'b11100: o_sll = {a[N-29:0], 28'b0};
            5'b11101: o_sll = {a[N-30:0], 29'b0};
            5'b11110: o_sll = {a[N-31:0], 30'b0};
            5'b11111: o_sll = {a[N-32:0], 31'b0};
            default:  o_sll = 32'hDEADBEEF;
        endcase
    end

endmodule
