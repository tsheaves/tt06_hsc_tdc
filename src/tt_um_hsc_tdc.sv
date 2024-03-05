/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_hsc_tdc (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

assign uio_oe = 8'hFF;
assign uio_out = 8'h00;

localparam DL_TYPE="RCA";
localparam POP_METHOD ="SV";
localparam N = 64;
localparam N_SYNC = 2;

localparam N_o = $clog2(N);

generate
    // Tie down output pins - required
    if(N_o < 7) begin : uo_tiedown_genblk
        always_comb begin
            uo_out[7:N_o+1] = {7-N_o{1'b0}}; 
        end
    end
endgenerate

logic
    clk_launch, 
    clk_capture,
    pg_src,
    pg_bypass,
    pg_in,
    pg_tog;

logic [N_o:0]
    hw;

// Pin mapping
always_comb begin
    clk_launch    = ui_in[0];
    clk_capture   = ui_in[1];
    pg_src        = ui_in[2];
    pg_bypass     = ui_in[3];
    pg_in         = ui_in[4];
    pg_tog        = ui_in[5];
    uo_out[N_o:0] = hw;
end

tdc_top #(
    .N(64),
    .DL_TYPE(DL_TYPE),
    .N_SYNC(N_SYNC),
    .POP_METHOD(POP_METHOD)
) tdc_inst (
    .clk_launch(clk_launch),
    .clk_capture(clk_capture),
    .rst(!rst_n),
    .en(ena),    
    .pg_src(pg_src),
    .pg_bypass(pg_bypass),
    .pg_in(pg_in),
    .pg_tog(pg_tog),
    .hw(hw)
);

endmodule
