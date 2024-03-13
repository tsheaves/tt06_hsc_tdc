/*
   Filename: capture_reg.v
    Version: 1.0
   Standard: Verilog
Description: Gauranteed to be an n-bit DFFE register independent of inputs
     Author: Tyler Sheaves (@tsheaves)
*/
`define REG_CELL tt_export_sky130_fd_sc_hd__edfxtp_1  

module capture_reg 
#(parameter WIDTH=1)
(
    output [WIDTH-1:0] Q  ,
    input              CLK,
    input [WIDTH-1:0]  D  ,
    input              EN
    `ifdef USE_POWER_PINS
        , input  VGND
        , input  VPWR
        , input  VPB
        , input  VNB
    `endif  // USE_POWER_PINS
);
    
	generate 
		genvar i;
		for(i=0; i<WIDTH; i=i+1) begin : capt_genblk
            (* keep *)
			`REG_CELL DFE(
                .Q(Q[i]),
                .CLK(CLK), 
                .D(D[i]), 
                .DE(EN)
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
