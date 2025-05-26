module adder_4 (
    X,
    Y,
    T,
    S,
    Cout
);

  parameter N = 4;
  input logic [N-1:0] X, Y;
  output logic [N-1:0] S;
  output logic Cout;
  input logic T;
  logic C0, C2, C1;

//   T = 0 => add
//   T =1=>sub

adder_1 ADD0(X[0],Y[0],T,S[0],C0);
adder_1 ADD1(X[1],Y[1],C0,  S[1],C1);
adder_1 ADD2(X[2],Y[2],C1,  S[2],C2);
adder_1 ADD3(X[3],Y[3],C2,  S[3],Cout);
  
endmodule
