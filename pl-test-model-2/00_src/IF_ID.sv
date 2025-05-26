module IF_ID (
  input logic             i_clk, i_reset, enable, flush,
  input logic     [31:0] i_PC, i_instr,
  output logic [31:0] o_PC, o_instr
);

  always_ff @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin
      o_PC   <= 32'd0;
      o_instr <= 32'd0;
    end 
    else if(flush) begin
      o_PC   <= 32'd0;
      o_instr <= 32'd0;
    end else if(!enable) begin
      o_PC   <= o_PC;
      o_instr <= o_instr;
    end
    else begin
      o_PC <= i_PC;
      o_instr <= i_instr;
    end
  end

endmodule