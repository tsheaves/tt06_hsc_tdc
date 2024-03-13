/*
   Filename: rca.v
    Version: 1.0
   Standard: Verilog
Description: Gauranteed to be an adder independent of inputs
     Author: Tyler Sheaves (@tsheaves)
*/
`define FA_CELL tt_export_sky130_fd_sc_hd__fa_1  

module rca #(parameter WIDTH=32) ( 
	input  [WIDTH-1:0] 	a, b,
	input 			    ci,
	output [WIDTH-1:0]	s,
	output			    co
    `ifdef USE_POWER_PINS
        , input  VGND
        , input  VPWR
        , input  VPB
        , input  VNB
    `endif  // USE_POWER_PINS
);

	(* keep *) wire [WIDTH:0] c;
	assign c[0] = ci;
	assign co = c[WIDTH];
	
	generate 
		genvar i;
		for(i=0; i<WIDTH; i=i+1) begin : rca_genblk
            (* keep *)
			`FA_CELL FA ( 
                .COUT(c[i+1]), 
                .CIN(c[i]), 
                .A(a[i]), 
                .B(b[i]), 
                .SUM(s[i]) 
                `ifdef USE_POWER_PINS
                    , .VGND(VGND)
                    , .VPWR(VPWR)
                    , .VPB(VPB)
                    , .VNB(VNB)
                `endif  // USE_POWER_PINS
            );
        end
   	endgenerate

endmodule
