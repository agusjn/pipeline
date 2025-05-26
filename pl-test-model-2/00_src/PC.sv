module pc_plus_4(
  input  logic [31:0] pc ,
  output logic [31:0] pc_four
);
  assign pc_four = pc + 4;

endmodule: pc_plus_4

///////////////////////////////////////////////////////////////////////////

module PC_block
(
  input  logic  i_clk ,
  input  logic  i_reset ,
  input  logic  pc_sel ,
  input  logic  i_stall,
  
  input  logic [31:0] i_alu_data ,
  output logic [31:0] o_pc
);
  
  logic [31:0] pc4 ;
  logic [31:0] pc_next ;
  
  pc_plus_4 PC_PLUS_4( 
    .pc ( o_pc ),
    .pc_four( pc4  ));
  
  mux2_1_32b PC_MUX (
    .data0_i( pc4        ),
    .data1_i( i_alu_data ),
    .sel_i  ( pc_sel   ),
    .data_o ( pc_next     ));

  always_ff @( posedge i_clk or negedge i_reset) begin : PC_FF
     if (!i_reset) begin
							o_pc <= 32'h0  ;
		end
    else if(!i_stall) begin
            o_pc <= o_pc;
    end
     else begin 
			o_pc <= pc_next;
			end
     end

  
endmodule: PC_block

///////////////////////////////////////////////////////////////////////////

module mux2_1_32b
(
  input  logic  sel_i ,

  input  logic [31:0] data0_i ,
  input  logic [31:0] data1_i ,

  output logic [31:0] data_o
);

  assign data_o = (sel_i) ? data1_i : data0_i ;
  
endmodule: mux2_1_32b