/*
   Filename: tb_tdc.sv
    Version: 1.0
   Standard: SystemVerilog 2012
Description: Simple tdc presynthesis test
     Author: Tyler Sheaves (@tsheaves)
*/
`timescale 1ns/1ps
module tb_tdc();

    localparam N = 64;
    localparam F_CLK = 66000000;
    localparam T_CLK_PS = (1/F_CLK)*10**12
    localparam T_CLK_PS_DIV2 = T_CLK_PS/2;

    bit 
        clk, rst_n, ena;
    logic [N-1:0]
        ;
    logic [$clog2(N):0]
        y, y_simple_sv, y_simple_loop;
    
    int bump_delay_delay_ps;

    // Setting bump will phase shift
    initial begin
	capture_clk = 1'b0;
	#(T_CLK_PS_DIV2);
	capture_clk = 1'b1;
	#(T_CLK_PS_DIV2); 
    end

    initial begin
	forever begin
		fork 
		// Await bump signal - processed synchronously w.r.t capture clk
		begin
			while(1) begin
				@(posedge capture_clk)
					if(bump)
						break;
		end
		begin
			
		end
		join_any
		
	end
	#10000 clk = 0;
	#10000 clk = 1;
    end
	
  
    initial begin
        $dumpfile("tb_tdc.vcd");
        $dumpvars;
        @(posedge clk)
        rst <= 1'b1;
        en <= 1'b0; 
        ////////// Test corner cases ////////// 
        @(posedge clk)
        x <= {N{1'b1}};
        rst <= 1'b0;
        en <= 1'b1;
        @(posedge clk)
        x <= {N{1'b0}};
        ////////// Test random data ////////// 
        repeat(100000) begin
            @(posedge clk);
            x <= {$urandom(), $urandom()};
            rst <= 1'b0;
        end
        $finish();
    end
    
    ////////// DUT //////////

    

    endmodule
