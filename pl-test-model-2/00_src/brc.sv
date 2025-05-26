module brc (
  input  logic [31:0] i_rs1_data, i_rs2_data,
  input  logic        i_brc_un,
  output logic        o_brc_less, o_brc_equal
);

  addsub addsubcomp (
    .inA         (i_rs1_data   ),
    .inB         (i_rs2_data   ),
    .neg_sel     (1'b1       ),
    .unsigned_sel(i_brc_un),
    .result      (           ),
    .less_than   (o_brc_less    ),
    .equal       (o_brc_equal   )
  );

endmodule

module addsub (
  input  [31:0] inA         ,
  input  [31:0] inB         ,
  input         neg_sel     ,
  input         unsigned_sel,
  output [31:0] result      ,
  output        less_than   ,
  output        equal
);

  wire [32:0] extendedA, extendedB;
  assign extendedA = unsigned_sel ? {1'b0, inA} : {1'(inA[31]), inA};
  assign extendedB = unsigned_sel ? {1'b0, inB} : {1'(inB[31]), inB};

  wire [32:0] newB;
  assign newB = neg_sel ? (~extendedB + 1'b1) : extendedB;

  assign {less_than, result} = extendedA + newB;

  assign equal = (result == 32'd0);
endmodule