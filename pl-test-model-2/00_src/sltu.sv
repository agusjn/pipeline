module sltu #(
    parameter N = 32
) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [N-1:0] o_sltu
);

  logic eq,lt;

  // Instantiate the signed compare module
  compare_32_u comp_inst (
      .a (a),
      .b (b),
      .lt(lt)
  );


  assign o_sltu = lt ? 32'd1 : 32'd0;

endmodule
