module adder_32 (
    X,
    Y,
    T,
    S,
    Cout
);

  parameter N = 32;
  input logic [N-1:0] X, Y;
  input logic T;
  output logic [N-1:0] S;
  output logic Cout;
  logic C0, C2, C1, C3, C4, C5,C6,C7;
  logic [N-1:0] Y_SUB;

//   T = 0 => add
//   T =1=>sub
//   assign T = 1'b0;
//   assign T = 1'b1;
  assign Y_SUB[3:0] = {4{T}} ^ Y[3:0];
  assign Y_SUB[7:4] = {4{T}}^ Y[7:4];
  assign Y_SUB[11:8] = {4{T}} ^ Y[11:8];
  assign Y_SUB[15:12] = {4{T}} ^ Y[15:12];

  assign Y_SUB[19:16] = {4{T}} ^ Y[19:16];
  assign Y_SUB[23:20] = {4{T}}^ Y[23:20];
  assign Y_SUB[27:24] = {4{T}} ^ Y[27:24];
  assign Y_SUB[31:28] = {4{T}} ^ Y[31:28];
//   assign Y_SUB[N-1:0] = {4{T}} ^ Y[N-1:0];



  adder_4 add1(X[3:0], Y_SUB[3:0],T, S[3:0], C0);
  adder_4 add2(X[7:4], Y_SUB[7:4],C0, S[7:4], C1);
  adder_4 add3(X[11:8], Y_SUB[11:8],C1, S[11:8], C2);
  adder_4 add4(X[15:12], Y_SUB[15:12],C2, S[15:12], C3);

  adder_4 add5(X[19:16], Y_SUB[19:16],C3, S[19:16], C4);
  adder_4 add6(X[23:20], Y_SUB[23:20],C4, S[23:20], C5);
  adder_4 add7(X[27:24], Y_SUB[27:24],C5, S[27:24], C6);
  adder_4 add8(X[31:28], Y_SUB[31:28],C6, S[31:28], Cout); 

endmodule