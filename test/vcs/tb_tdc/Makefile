VHEADERS = ""

COMPILE_ARGS    += +define+GL
COMPILE_ARGS    += +define+FUNCTIONAL
# COMPILE_ARGS    += +define+USE_POWER_PINS
COMPILE_ARGS    += +define+SIM
COMPILE_ARGS    += +define+UNIT_DELAY
VSOURCES        = $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VSOURCES        += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

SVSOURCES = \
	../../../src/tdc/*.sv \
	../../../src/tdc/reg/*.sv \
	../../../src/tdc/pkg/tdc_pkg.sv \
    ../../../src/tdc/delay_line/*.sv \
    ../../../src/tdc/pop_count/pop_count_simple.sv \
    ../../../src/tdc/pulse_gen/tdc_pg.sv \
    ../../../src/tt_um_hsc_tdc.sv

TBSVSOURCES = \
	./tb_tdc.sv

GL_VSOURCES = \
	${PDK_ROOT}/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
    ${PDK_ROOT}/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
    ../../../runs/wokwi/results/final/verilog/gl/tt_um_hsc_tdc.v \
    ./tb_tdc.sv

GL_SDF = \
    ../../../runs/wokwi/results/final/sdf/tt_um_hsc_tdc.sdf

GL_FLAGS = \
    +define+USE_POWER_PINS +define+GL

SDF_FLAGS     = $(GL_FLAGS) 
SDF_FLAGS    += -sdf typ:tt_um_hsc_tdc:$(GL_SDF)

VCS_VFLAGS   += -notice -M -L -ntb_opts tb_timescale=1ns/1ps -lca
VCS_VFLAGS   += -sverilog +v2k +neg_tchk -full64 -line -licqueue -q
VCS_VFLAGS   += -assert svaext
VCS_VFLAGS   += +warn=noLCA_FEATURES_ENABLED
VCS_VFLAGS   += +warn=noMC-FCNAFTMI
VCS_VFLAGS   += +lint=all,TFIPC-L,noSVA-UA,noSVA-NSVU,noVCDE,noSVA-AECASR
VLDFLAGS     += -Wl,--no-as-needed
VCS_LDFLAGS  += $(foreach def,$(VLDFLAGS),-LDFLAGS "$(def)")
VCS_INCLUDES += $(foreach inc,$(VINCLUDES),+incdir+"$(inc)")
VCS_DEFINES  += $(foreach def,$(VDEFINES),+define+"$(def)")
VCS_FLAGS     = $(VCS_LDFLAGS) $(VCS_VFLAGS) $(VCS_INCLUDES) $(VCS_DEFINES)
VCS_FLAGS    += +plusarg_save +vcs+vcdpluson +vcs+vcdplusmemon +memcbk -debug_pp -assert enable_diag

VCS_VSOURCES  = $(VHEADERS) $(SVSOURCES) $(TBSVSOURCES) -v $(VSOURCES)

VCS_TOP       = tb_tdc

.PHONY: sim
.PHONY: compile
.PHONY: simv
.PHONY: clean

sim_func: clean simv compile
	./simv -assert report+quiet+success

sim_gl: clean simv compile_gl
	./simv -assert report+quiet+success


compile:
	vcs +define+ASSERT_ON -top $(VCS_TOP) $(VCS_FLAGS) $(COMPILE_ARGS) $(VCS_VSOURCES) 

compile_gl:
	vcs +define+ASSERT_ON -top $(VCS_TOP) $(GL_VSOURCES) $(SDF_FLAGS) $(VCS_FLAGS) 

clean:
	rm -rf ucli.key
	rm -rf .cxl* *.jou
	rm -rf *.daidir *.tmp
	rm -rf *.jou
	rm -rf *.vcs.log
	rm -rf vc_hdrs.h
	rm -rf *.debug *.profile
	rm -rf *.vcd
	rm -rf *.report
	rm -rf *.vpd
	rm -rf simv*
	rm -rf csrc
	rm -rf *.disablelog

