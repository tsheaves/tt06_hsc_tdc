/*
   Filename: capture_reg.v
    Version: 1.0
   Standard: Verilog
Description: Gauranteed to be an n-bit DFFE register independent of inputs
     Author: Tyler Sheaves (@tsheaves)
*/
`define REG_CELL sky130_fd_sc_hd__edfxtp_1  

(* techmap_celltype = "$dffe" *)
module dff_reg (Q, D, CLK, EN);
	parameter WIDTH = N;
	parameter CLK_POLARITY = 1;

	input CLK;
    input EN;
	(* force_downto *)
	input [WIDTH-1:0] D;
	(* force_downto *)
	output reg [WIDTH-1:0] Q;
    
	generate 
		genvar i;
		for(i=0; i<n; i=i+1) begin : rca_genblk
			`REG_CELL DFF(.Q(Q[i]), .CLK(clk), .D(D[i]), .DE(EN));
        end
   	endgenerate    

endmodule
