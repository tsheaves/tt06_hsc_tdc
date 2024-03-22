# Define clocks for launch and capture
set lc_period $::env(CLOCK_PERIOD)

create_clock [get_ports ui_in[0]]  -name launch_clk -period ${lc_period}
create_clock [get_ports ui_in[1]]  -name capture_clk -period ${lc_period}

set input_delay_value [expr ${lc_period} * $::env(IO_PCT)]
set output_delay_value [expr ${lc_period} * $::env(IO_PCT)]

set_clock_groups -group launch_clk -group capture_clk -asynchronous -allow_paths

# Achievable constraints between launch and capture clocks
set_min_delay -ignore_clock_latency -from [get_clocks launch_clk] -to [get_clocks capture_clk]  0.0
set_max_delay -ignore_clock_latency -from [get_clocks launch_clk] -to [get_clocks capture_clk] [expr "${lc_period}/2"]

# Constrain input delays
set_input_delay  -clock [get_clocks launch_clk]  -min 0.5 [get_ports {ui_in[2] ui_in[3] ui_in[4] ui_in[5] ui_in[6] ui_in[7]}] 
set_input_delay  -clock [get_clocks launch_clk]  -max 0.5 [get_ports {ui_in[2] ui_in[3] ui_in[4] ui_in[5] ui_in[6] ui_in[7]}] 

set_max_delay -ignore_clock_latency -from [get_clocks launch_clk] -to [get_clocks capture_clk] 0.0 
set_max_delay -ignore_clock_latency -from [get_clocks launch_clk] -to [get_clocks capture_clk] 0.0

# Constrain output delays
set_output_delay  -min -1.5 -clock [get_clocks capture_clk] [get_ports {uo_out[0] uo_out[1] uo_out[2] uo_out[3] uo_out[4] uo_out[5] uo_out[6] uo_out[7]}]
set_output_delay  -max  1.5 -clock [get_clocks capture_clk] [get_ports {uo_out[0] uo_out[1] uo_out[2] uo_out[3] uo_out[4] uo_out[5] uo_out[6] uo_out[7]}]

# Misc
# Copied from default OpenLane SDC 
set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]
if { [info exists ::env(MAX_TRANSITION_CONSTRAINT)] } {
    set_max_transition $::env(MAX_TRANSITION_CONSTRAINT) [current_design]
}

if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL)] } {
    set ::env(SYNTH_CLK_DRIVING_CELL) $::env(SYNTH_DRIVING_CELL)
}

if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL_PIN)] } {
    set ::env(SYNTH_CLK_DRIVING_CELL_PIN) $::env(SYNTH_DRIVING_CELL_PIN)
}

set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) [get_ports {ui_in[2] ui_in[3] ui_in[4] ui_in[5] ui_in[6] ui_in[7]}]
set_driving_cell -lib_cell $::env(SYNTH_CLK_DRIVING_CELL) -pin $::env(SYNTH_CLK_DRIVING_CELL_PIN) [get_ports {ui_in[0]}]
set_driving_cell -lib_cell $::env(SYNTH_CLK_DRIVING_CELL) -pin $::env(SYNTH_CLK_DRIVING_CELL_PIN) [get_ports {ui_in[1]}]

set cap_load [expr $::env(SYNTH_CAP_LOAD) / 1000.0]
puts "\[INFO\]: Setting load to: $cap_load"
set_load  $cap_load [all_outputs]

# clock jitter
puts "\[INFO\]: Setting clock uncertainity to: $::env(SYNTH_CLOCK_UNCERTAINTY)"
set_clock_uncertainty $::env(SYNTH_CLOCK_UNCERTAINTY) [get_clocks launch_clk]
set_clock_uncertainty $::env(SYNTH_CLOCK_UNCERTAINTY) [get_clocks capture_clk]

# clock slew
puts "\[INFO\]: Setting clock transition to: $::env(SYNTH_CLOCK_TRANSITION)"
set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [get_clocks launch_clk]
set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [get_clocks capture_clk]

# make everything worse by SYNTH_TIMING_DERATE
puts "\[INFO\]: Setting timing derate to: [expr {$::env(SYNTH_TIMING_DERATE) * 100}] %"
set_timing_derate -early [expr {1-$::env(SYNTH_TIMING_DERATE)}]
set_timing_derate -late [expr {1+$::env(SYNTH_TIMING_DERATE)}]

