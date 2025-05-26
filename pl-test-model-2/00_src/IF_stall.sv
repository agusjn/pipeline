module IF_stall(
    input logic i_clk, i_reset, enable,
    input logic [31:0] i_pc_next,
    output logic [31:0] o_pc_next
);

always_ff @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) o_pc_next <= 32'h0;
    else if(!enable) o_pc_next <= o_pc_next;
    else o_pc_next <= i_pc_next;
end

endmodule