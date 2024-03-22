import cocotb
from cocotb.clock import Clock, Timer
from cocotb.triggers import ClockCycles, Timer, RisingEdge, FallingEdge
from cocotb.decorators import coroutine


# TODO: move elsewhere
class TDCCtrl:
    
    def __init__(self, clk_period, dut):
        self.clk_period=clk_period
        self.dut=dut
        self.clock_launch_coru=None
        self.clock_capt_coru=None
        self.theta_ps=0
        self.n_samples=0
        self.hw_samples= {
            "THETA_PS"   : [],
            "HW_SAMPLES" : []
        }
        self.src_ctrl = {
            "PG_IN"  : 0,
            "PG_TOG" : 1 
        }
        self.reg_bypass = {
            "BYPASS" : 0,
            "REG"    : 1
        }
    
    @cocotb.coroutine
    def set_theta_ps(self, theta_ps):
        self.theta_ps=theta_ps
        yield cocotb.start_soon(self.__kill_clks__())
        yield cocotb.start_soon(self.__start_clks__())
    
    @cocotb.coroutine
    def reset_design(self):
        yield cocotb.start_soon(self.__reset_design__())

    @cocotb.coroutine
    def pg_cfg(self, pg_src="PG_IN", pg_byp="PG_REG"):
        match (pg_src, pg_byp):
            case ("PG_IN", "PG_BYPASS"):
                yield cocotb.start_soon(self.__pg_in_byp_reg__())
            case ("PG_IN", "PG_REG"):
                yield cocotb.start_soon(self.__pg_in_reg__())
            case ("PG_TOG", "PG_BYPASS"):
                yield cocotb.start_soon(self.__pg_tog_byp_reg__())
            case ("PG_TOG", "PG_REG"):
                yield cocotb.start_soon(self.__pg_tog_reg__())

    @cocotb.coroutine
    def get_samples(self, n):
        self.n_samples = n
        yield cocotb.start_soon(self.__get_samples__())         

    async def __start_clks__(self):
        await Timer(self.clk_period, units='ns')        
        # Start launch at t=0
        self.clock_launch_coru = cocotb.start_soon(Clock(self.dut.clk_launch, period=self.clk_period, units="ns").start())
        await ClockCycles(self.dut.clk_launch, 1)
        # Phase delay, then start capture
        await Timer(self.theta_ps, units='ps')
        self.clock_capt_coru   = cocotb.start_soon(Clock(self.dut.clk_capture, period=self.clk_period, units="ns").start())
        await ClockCycles(self.dut.clk_capture, 1)
        await ClockCycles(self.dut.clk_launch, 1)
    
    async def __kill_clks__(self):
        if(self.clock_launch_coru != None):
            await ClockCycles(self.dut.clk_launch, 1)
            self.clock_launch_coru.kill()
        if(self.clock_capt_coru != None):
            await ClockCycles(self.dut.clk_capture, 1)
            self.clock_capt_coru.kill()
        self.clock_launch_coru = None
        self.clock_capt_coru = None
        await Timer(self.clk_period, units='ns')     

    async def __reset_design__(self):
        # Enable the design
        await Timer(self.clk_period, units='ns')
        self.dut.ena.value = 1
        self.dut.rst_n.value = 0
        await Timer(self.clk_period, units='ns')
        self.dut.rst_n.value = 1
    
    async def __pg_in_byp_reg__(self):
        await ClockCycles(self.dut.clk_launch, 1)
        self.dut.pg_src.value = self.src_ctrl["PG_IN"]
        self.dut.pg_bypass.value = self.reg_bypass["BYPASS"]
        await ClockCycles(self.dut.clk_launch, 1)
    
    async def __pg_in_reg__(self):
        await ClockCycles(self.dut.clk_launch, 1)
        self.dut.pg_src.value = self.src_ctrl["PG_IN"]
        self.dut.pg_bypass.value = self.reg_bypass["REG"]
        await ClockCycles(self.dut.clk_launch, 1)

    async def __pg_tog_byp_reg__(self):
        await ClockCycles(self.dut.clk_launch, 1)
        self.dut.pg_src.value = self.src_ctrl["PG_TOG"]
        self.dut.pg_bypass.value = self.reg_bypass["BYPASS"]
        await ClockCycles(self.dut.clk_launch, 1)

    async def __pg_tog_reg__(self):
        await ClockCycles(self.dut.clk_launch, 1)
        self.dut.pg_src.value = self.src_ctrl["PG_TOG"]
        self.dut.pg_bypass.value = self.reg_bypass["REG"]
        await ClockCycles(self.dut.clk_launch, 1)

    async def __get_samples__(self):
        # If the pg is toggling and clocks are active, collect n traces
        await ClockCycles(self.dut.clk_launch, 1)
        if(self.dut.pg_src.value == self.src_ctrl["PG_TOG"]):
            if(self.clock_launch_coru != None and self.clock_capt_coru != None):
                print("here")
                for i in range(self.n_samples):
                    hws = []            
                    self.hw_samples["THETA_PS"].append(self.theta_ps)
                    # Wait for a rising edge of the toggle input
                    await RisingEdge(self.dut.pg_tog)
                    # If register is active wait for pipeline delay
                    if(self.dut.pg_src.value == self.reg_bypass["REG"]):
                        await ClockCycles(self.dut.clk_launch, 1)
                    for j in range(6):                
                        # Get the next four capture clk and sample
                        await ClockCycles(self.dut.clk_capture, 1)
                        # Sample hw
                        hws.append(int(self.dut.hw.value))
                    self.hw_samples["THETA_PS"].append(hws)
        await ClockCycles(self.dut.clk_launch, 1) 

@cocotb.test()
async def test_tdc(dut):
    dut._log.info("Start")
    f_clk_ns = 20
    tdc_ctrl = TDCCtrl(f_clk_ns, dut)
    for theta_ps in range(0, f_clk_ns*1000+1, 100):
        set_theta_thread = cocotb.start_soon(tdc_ctrl.set_theta_ps(theta_ps))
        await set_theta_thread
        reset_thread = cocotb.start_soon(tdc_ctrl.reset_design())
        await reset_thread
        pg_cfg_thread = cocotb.start_soon(tdc_ctrl.pg_cfg("PG_TOG", "PG_REG"))
        await pg_cfg_thread
        get_samples_thread = cocotb.start_soon(tdc_ctrl.get_samples(2))
        await get_samples_thread
    print(tdc_ctrl.hw_samples) 
#    await samples_thread
#    print(tdc_ctrl.hw_samples)
