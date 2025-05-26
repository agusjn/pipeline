module slt #(
    parameter N = 32
) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [N-1:0] o_slt
);

  logic eq,lt;

  // Instantiate the signed compare module
  compare_32 comp_inst (
      .a (a),
      .b (b),
      .lt(lt)
  );


  assign o_slt = lt ? 32'd1 : 32'd0;

endmodule
