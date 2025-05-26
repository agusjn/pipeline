module compare_32 #(parameter N = 32)(
    input logic [N-1:0] a,
    input logic [N-1:0] b,

    output logic eq,
    output logic lt
);
  logic eq_temp;
  logic lt_temp;
  logic eq_temp_2c;
  logic lt_temp_2c;

  logic [N-1:0] a_c;
  logic [N-1:0] b_c;

  logic [N-1:0] a_2c;
  logic [N-1:0] b_2c;



  assign a_c = ~a;
  assign b_c = ~b;

  adder_32 adder1 (
      .X(a_c),
      .Y(32'h1),
      .T(1'b0),
      .S(a_2c)
  );
  adder_32 adder2 (
      .X(b_c),
      .Y(32'h1),
      .T(1'b0),
      .S(b_2c)
  );
  
  compare_32_u compare_0 (
      .a (a[N-1:0]),
      .b (b[N-1:0]),
      .eq(eq_temp),
      .lt(lt_temp)
  );
  compare_32_u compare_1 (
      .a (a_2c[N-1:0]),
      .b (b_2c[N-1:0]),
      .eq(eq_temp_2c),
      .lt(lt_temp_2c)
  );
  
  always @(*) begin
    if (!a[N-1] && !b[N-1]) begin
      eq <= eq_temp;
      lt <= lt_temp;
    end else if (a[N-1] && b[N-1]) begin
      eq <= eq_temp_2c;
		lt <= !(lt_temp_2c+eq);
    end else if (!a[N-1] && b[N-1]) begin
      eq <= 0;
      lt <= 0;
	end else if (a[N-1] && !b[N-1]) begin
      eq <= 0;
      lt <= 1;
    end 
  end
endmodule
