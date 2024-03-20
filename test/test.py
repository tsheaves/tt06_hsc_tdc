import cocotb
from cocotb.clock import Clock, Timer
from cocotb.triggers import ClockCycles, Timer

@cocotb.test()
async def test_tdc(dut):
    dut._log.info("Start")

    # Start launch at t=0
    cocotb.start_soon(Clock(dut.clk_launch, period=15, units="ns").start())
    await ClockCycles(dut.clk_launch, 1)
    # Phase delay, then start capture
    await Timer(6500, units='ps')
    cocotb.start_soon(Clock(dut.clk_capture, period=15, units="ns").start())
    await ClockCycles(dut.clk_capture, 1)
    await ClockCycles(dut.clk_launch, 1)

    # Reset and enable
    dut._log.info("Reset")
    # Enable the design
    dut.ena.value = 1
    # Select the toggle input
    dut.pg_src.value = 0
    # Bypass sync reg
    dut.pg_bypass.value = 1
    # Set the direct input
    dut.pg_in.value = 0
    # Assert reset
    dut.rst_n.value = 0
    # Give two ticks to propagate to both clocks
    await ClockCycles(dut.clk_launch, 2)
    # Deassert reset
    dut.rst_n.value = 1
    
    # Observe HW samples
    await ClockCycles(dut.clk_capture, 10)

    # Select the direct input
    dut.pg_src.value = 1
    # Bypass sync reg
    dut.pg_bypass.value = 1
    # Set the direct input
    dut.pg_in.value = 1
    
    # Observe HW samples
    await ClockCycles(dut.clk_capture, 10)

    # Need to add checks
    # assert dut.uo_out.value == 50
