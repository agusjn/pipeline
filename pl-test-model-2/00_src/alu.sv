module alu #(parameter W = 32)(
    input  logic [31:0] i_operand_a,
    input  logic [31:0] i_operand_b,
    input  logic [ 3:0] i_alu_op,
    output logic [31:0] o_alu_data
);
  logic [W-1:0] alu_add;
  logic [W-1:0] alu_sub;
  logic [W-1:0] alu_xor;
  logic [W-1:0] alu_and;
  logic [W-1:0] alu_or;
  logic [W-1:0] alu_sll;
  logic [W-1:0] alu_srl;
  logic [W-1:0] alu_sra;
  logic [W-1:0] alu_slt;
  logic [W-1:0] alu_sltu;

  localparam ADD = 4'b0000;
  localparam SUB = 4'b0001;
  localparam SLT = 4'b0010;
  localparam SLTU = 4'b0011;
  localparam XOR = 4'b0100;
  localparam OR = 4'b0101;
  localparam AND = 4'b0110;
  localparam SLL = 4'b0111;
  localparam SRL = 4'b1000;
  localparam SRA = 4'b1001;


  //xor
  assign alu_xor = i_operand_a ^ i_operand_b;
  //and
  assign alu_and = i_operand_a & i_operand_b;
  //or
  assign alu_or  = i_operand_a | i_operand_b;
  //add 
  adder_32 add1 (
      i_operand_a,
      i_operand_b,
      0,
      alu_add
  );
  //sub 
  adder_32 sub1 (
      i_operand_a,
      i_operand_b,
      1,
      alu_sub
  );
  //slt
  slt slt1 (
      .a(i_operand_a),
      .b(i_operand_b),
      .o_slt(alu_slt)
  );
  //sltu
  sltu sltu1 (
      .a(i_operand_a),
      .b(i_operand_b),
      .o_sltu(alu_sltu)
  );
  //sll
  sll sll1 (
      i_operand_a,
      i_operand_b,
      alu_sll
  );
  //srl
  srl srl1 (
      i_operand_a,
      i_operand_b,
      alu_srl
  );
  //sra
  sra sra1 (
      i_operand_a,
      i_operand_b,
      alu_sra
  );

  always @(*) begin
    case (i_alu_op)
      ADD: o_alu_data <= alu_add;
      SUB: o_alu_data <= alu_sub;
      XOR: o_alu_data <= alu_xor;
      AND: o_alu_data <= alu_and;
      OR: o_alu_data <= alu_or;
      SLL: o_alu_data <= alu_sll;
      SRL: o_alu_data <= alu_srl;
      SRA: o_alu_data <= alu_sra;
      SLT: o_alu_data <= alu_slt;
      SLTU: o_alu_data <= alu_sltu;
      default: o_alu_data <= 32'hDEADBEEF;
    endcase
  end
endmodule
