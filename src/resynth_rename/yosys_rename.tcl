set PDK_ROOT  $env(PDK_ROOT)
set TOP_MODULE $env(TOP_MODULE)
yosys -import

read_liberty -lib -ignore_miss_dir -setattr blackbox $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/lib/*
read_verilog -lib $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd__blackbox.v
read_verilog -vlog95 $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
read_verilog gate_level_netlist.v;

prep -top $TOP_MODULE;
rename -hide */c:*[*; 
rename -enumerate -pattern bracket_% */c:$auto$rename*;
write_verilog renamed_gl_netlist.v;
