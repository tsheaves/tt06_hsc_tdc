// `timescale 1ns/1ps
module tdc_top #(
    parameter N=64,    
    parameter DL_TYPE="RCA",
    parameter POP_METHOD="SV",
    parameter N_SYNC=1 // Must be gt 0
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
    dl_out,
    capt_out,
    sync_out;

logic [N-1:0]
    capt_reg_r [N_SYNC:0];

tdc_pg pg(
	.clk_launch(clk_launch),
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
	.dl_out(dl_out)
);

////////////////// TODO: Place in separate module 

// Capture register - separated for placement
capture_reg #(
    .WIDTH(N)
) dl_capt (   
    .D(dl_out), 
    .Q(capt_out), 
    .EN(en), 
    .CLK(clk_capture)
);

// Capture sync stages
always_comb capt_reg_r[0] = capt_out;
genvar i;
generate
    for(i=1; i<=N_SYNC; i=i+1) begin : genblk_capt
        always_ff@(posedge clk_capture)
            if(rst)
                capt_reg_r[i] <= {N{1'b0}};
            else if(en)
                capt_reg_r[i] <= capt_reg_r[i-1];
    end
endgenerate
always_comb sync_out = capt_reg_r[N_SYNC];

////////////////// 

// Can swap out if needed for performance
pop_count_simple #(
    .N(N),
    .POP_METHOD(POP_METHOD)
) pc_inst (
		.clk(clk_capture), 
        .rst(rst),
        .en(en),
		.x(sync_out),
		.y(hw)
);

endmodule
