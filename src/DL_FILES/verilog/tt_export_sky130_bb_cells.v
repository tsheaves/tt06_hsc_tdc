`timescale 1ns / 1ps
`default_nettype none

(* blackbox *)
module tt_export_sky130_fd_sc_hd__fa_1 (
    output COUT,
    output SUM ,
    input  A   ,
    input  B   ,
    input  CIN
    `ifdef USE_POWER_PINS
        , input  VGND
        , input  VPWR
        , input  VPB
        , input  VNB
    `endif  // USE_POWER_PINS
);
endmodule

(* blackbox *)
module tt_export_sky130_fd_sc_hd__edfxtp_1 (
    output Q  ,
    input  CLK,
    input  D  ,
    input  DE
    `ifdef USE_POWER_PINS
        , input  VGND
        , input  VPWR
        , input  VPB
        , input  VNB
    `endif  // USE_POWER_PINS
);
endmodule

