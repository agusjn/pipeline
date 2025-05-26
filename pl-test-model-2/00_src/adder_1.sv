module adder_1 (
    X,
    Y,
    Cin,
    S,
    Cout
);
  input logic X, Y, Cin;
  output logic S, Cout;

  assign S = X ^ Y ^ Cin;
  assign Cout = (X & Y) | (Y & Cin) | (X & Cin);

endmodule
