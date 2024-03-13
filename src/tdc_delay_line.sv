/*
   Filename: tdc_delay_line.sv
    Version: 1.0
   Standard: SystemVerilog 2012
Description: Create a delay line using vmacros
     Author: Tyler Sheaves (@tsheaves)
*/
module delay_line #(
    parameter N=64,
    parameter DL_TYPE="RCA"
) ( 
	input 
        in,
	output [N-1:0]
        dl_out
    `ifdef USE_POWER_PINS
        , input  VGND
        , input  VPWR
        , input  VPB
        , input  VNB
    `endif  // USE_POWER_PINS
);
	
    generate
	    case(DL_TYPE)
		    "RCA": begin : dl_genblk
                (* keep *) logic 
                    keep_co;
			    (* keep *) rca #(.WIDTH(N)) dl (
				    .a({N{1'b1}}),
				    .b({N{1'b1}}),
				    .ci(in),
				    .s(dl_out),
				    .co(keep_co)
                    `ifdef USE_POWER_PINS
                        , .VGND(VGND)
                        , .VPWR(VPWR)
                        , .VPB(VPB)
                        , .VNB(VNB)
                    `endif  // USE_POWER_PINS
			    );
            end
	    endcase
    endgenerate

endmodule
