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
);
	
    generate
	    case(DL_TYPE)
		    "RCA": begin : dl_genblk
                logic keep_co;
			    (* keep *)
			    rca #(.n(N)) dl (
				    .a({N{1'b1}}),
				    .b({N{1'b1}}),
				    .ci(in),
				    .s(dl_out),
				    .co(keep_co)
			    );
            end
	    endcase
    endgenerate

endmodule
