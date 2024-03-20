/*
   Filename: tb_tdc.sv
    Version: 1.0
   Standard: SystemVerilog 2012
Description: Simple tdc presynthesis test
     Author: Tyler Sheaves (@tsheaves)
*/
`timescale 1ns/1ps
module tb_tdc();

    import tdc_pkg::*;

    localparam N = 64;
    localparam cl2N = $clog2(N);
    localparam F_CLK = 66000000;
    localparam T_CLK_PS = (1/F_CLK)*10**12;
    localparam T_CLK_PS_DIV2 = T_CLK_PS/2;

    bit 
        capture_clk,
        launch_clk,
        rst_n, 
        ena;

    logic [cl2N:0]
        hw;

    logic [$clog2(N):0]
        y, 
        y_simple_sv, 
        y_simple_loop;

    logic
        bump, 
        bump_r;

    `ifdef USE_POWER_PINS
        logic 
            VGND, 
            VPWR;
        assign VGND = 1'b0;
        assign VPWR = 1'b1;
    `endif

    logic
        pg_in,
        pg_tog,
        pg_src,
        pg_bypass;

    logic [7:0] 
        ui_in,
        uo_out,
        hw;

    always_comb ui_in = {2'b00, pg_tog, pg_in, pg_bypass, pg_src, capture_clk, launch_clk};
    always_comb hw = {1'b0, uo_out[6:0]};    

    /////////////////  Launch Clock //////////////////
    // Explicit clock starts w/ posedge at t0
    initial begin
        forever begin
            #(T_CLK_PS_DIV2)
            capture_clk = 1'b1;
            #(T_CLK_PS_DIV2)
            capture_clk = 1'b0; 
        end
    end 

    /////////////////  Capture Clock /////////////////
    // Setting bump will phase shift by 10ps
    //  reset resynchronizes capture to launch
    initial begin
        forever begin
            if(!rst_n)
                @(posedge launch_clk);
            else if(bump==0 && bump_r==1)
                #10;
            #(T_CLK_PS_DIV2)
            capture_clk = 1'b1;
            #(T_CLK_PS_DIV2)
            capture_clk = 1'b0;
        end
    end

    always@(posedge capture_clk)
        bump_r <= bump;  
    
    always@(posedge launch_clk)
        if(!rst_n)
            pg_tog <= 1'b0;
        else
            pg_tog <= ~pg_tog;           

    /////////////////// TDC Tasks ///////////////////

    task rst_tdc;
        @(posedge launch_clk);
        rst_n <= 1'b0;
        @(posedge capture_clk);
        @(posedge capture_clk);
        rst_n <= 1'b1;
    endtask

    task bump_tdc;
        @(posedge capture_clk);
        bump <= 1'b1;
        @(posedge capture_clk);
        bump <= 1'b0;
    endtask

    task pg_toggle_byp;
        pg_in <= 1'b0;
        pg_src <= PG_TOG;
        pg_bypass <= BYPASS;
    endtask

    task pg_toggle_reg;
        pg_in <= 1'b0;
        pg_src <= PG_TOG;
        pg_bypass <= REG;
    endtask

    task pg_in_0_reg;
        pg_in <= 1'b0;
        pg_src <= PG_IN;
        pg_bypass <= REG;
    endtask

    task pg_in_1_reg;
        pg_in <= 1'b1;
        pg_src <= PG_IN;
        pg_bypass <= REG;
    endtask

    task pg_in_0_byp;
        pg_in <= 1'b0;
        pg_src <= PG_IN;
        pg_bypass <= BYPASS;
    endtask

    task pg_in_1_byp;
        pg_in <= 1'b1;
        pg_src <= PG_IN;
        pg_bypass <= BYPASS;
    endtask
    
    initial begin
        $dumpfile("tb_tdc.vcd");
        $dumpvars;
        @(posedge capture_clk);
        ena <= 1'b0;
        rst_tdc();
        
        repeat(100) begin
            repeat(10)
                @(posedge launch_clk);
            bump_tdc();
        end
        
        $finish();
    end

    ////////// DUT //////////
    tt_um_hsc_tdc tdc_inst (
        `ifdef USE_POWER_PINS
            .VGND(VGND),
            .VPWR(VPWR),
        `endif
        .clk(),             // unused clk pin
        .ena(ena),
        .rst_n(rst_n),
        .ui_in(ui_in),
        .uio_in(),          // unused GPIO
        .uio_oe(),          // unused GPIO
        .uio_out(uo_out),   // unused GPIO
        .uo_out(uo_out)
    );

    endmodule
