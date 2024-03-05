module tdc_top #(
    parameter N=64,    
    parameter DL_TYPE="RCA",
    parameter POP_METHOD="SV",
    parameter N_SYNC=2 // Must be gt 0
)(
    input logic
        clk_launch,
        clk_capture,
        rst,
        en,    
    input logic 
        pg_src,
        pg_bypass,
    input logic
        pg_in,
        pg_tog,
    output [$clog2(N):0]
        hw
);

logic 
    pg_out;
logic [N-1:0]
    dl_out_r [N_SYNC:0];

tdc_pg pg(
	.clk_launch,
	.rst(rst), 
    .en(en),
    .pg_in(pg_in), 
    .pg_tog(pg_tog),	
    .pg_src(pg_src),
  	.pg_bypass(pg_bypass),
  	.pg_out(pg_out)
);

delay_line #(
    .N(N),
    .DL_TYPE(DL_TYPE)
) dl_inst ( 
	.in(pg_out),
	.dl_out(dl_out_r[0])
);

// Combined capture & sync stages
integer i;
always@(posedge clk_capture)
   for(i=1; i<N_SYNC+1; i=i+1)
        dl_out_r[i] <= dl_out_r[i-1]; 

// Can swap out if needed for performance
pop_count_simple #(
    .N(N),
    .POP_METHOD(POP_METHOD)
) pc_inst (
		.clk(clk_capture), 
        .rst(rst),
        .en(en),
		.x(dl_out_r[N_SYNC]),
		.y(hw)
);

endmodule
