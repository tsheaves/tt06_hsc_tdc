# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src/
PROJECT_SOURCES = \
    tt_um_hsc_tdc.sv \
    tdc/tdc_top.sv \
    tdc/delay_line/tdc_delay_line.sv \
    tdc/delay_line/rca.sv \
    tdc/pop_count/pop_count_simple.sv \
    tdc/pulse_gen/tdc_pg.sv \
    tdc/reg/capture_reg.sv

ifneq ($(GATES),yes)

# RTL simulation:
SIM_BUILD		     = sim_build/rtl
COMPILE_ARGS 		+= -I$(SRC_DIR)
COMPILE_ARGS        += -DFUNCTIONAL
COMPILE_ARGS        += -DSIM
COMPILE_ARGS        += -DUNIT_DELAY=\#1
VERILOG_SOURCES     += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))
# We need to include these for the std cell macro models
VERILOG_SOURCES     += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES     += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

else

# Gate level simulation:
SIM_BUILD		 = sim_build/gl
COMPILE_ARGS    += -DGL_TEST
COMPILE_ARGS    += -DUSE_POWER_PINS
COMPILE_ARGS    += -DSIM
COMPILE_ARGS    += -DUNIT_DELAY=\#1
COMPILE_ARGS    += -gspecify -ginterconnect -T max
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# this gets copied in by the GDS action workflow
VERILOG_SOURCES += $(PWD)/rename_gl/gln/tt_um_hsc_tdc.v

endif

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb.v 
TOPLEVEL = tb

# MODULE is the basename of the Python test file
MODULE = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
