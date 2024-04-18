import cocotb
import os
import cocotb.utils as utils
from cocotb.clock import Clock, Timer
from cocotb.triggers import ClockCycles, Timer, RisingEdge, FallingEdge
from cocotb.decorators import coroutine
from tdc_test_utility import TDCTestUtility

@cocotb.test()
async def test_tdc(dut):
    dut._log.info("Start")
    gates = os.environ['GATES']

    tdc_ctrl = TDCTestUtility(
        clk_period_ns=54, 
        dut=dut, 
        dl_cell="sky130_fd_sc_hd__fa_2",
        meas_start="PULSE RISING",
        is_inverted=True
    )
    
    dut._log.info("Starting clocks.")
    clock_strt_thread = cocotb.start_soon(tdc_ctrl.start_clocks())
    await clock_strt_thread

    dut._log.info("Resetting design.")
    reset_thread = cocotb.start_soon(tdc_ctrl.reset_design())
    await reset_thread

    dut._log.info("Configuring the pulsegenerator to toggle w/ register bypass.")    
    pg_cfg_thread = cocotb.start_soon(tdc_ctrl.pg_cfg("PG_TOG", "PG_BYPASS"))
    await pg_cfg_thread

    if gates == "yes":
        dut._log.info("Collecting samples with 100ps theta increments from 0 to 2*f_clk.")
        for theta_ps in range(0, 2*tdc_ctrl.clk_period_ns*1000+1, 100):
            set_theta_thread = cocotb.start_soon(tdc_ctrl.set_theta_ps(theta_ps))
            await set_theta_thread
            get_samples_thread = cocotb.start_soon(tdc_ctrl.get_pulse_response_gl())
            await get_samples_thread
        # Make the plot
        tdc_ctrl.plot_theta_sweep("theta_sweep.png")

    else:
        dut._log.info("Capturing some samples.")
        for theta_ps in range(1, 1001, 10):
            set_theta_thread = cocotb.start_soon(tdc_ctrl.set_theta_ps(theta_ps))
            await set_theta_thread
            get_samples_thread = cocotb.start_soon(tdc_ctrl.check_pulse_response_rtl())
            await get_samples_thread
