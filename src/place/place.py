class StdCellInstance:
    def __init__(self, inst_name="", cell_dim=(0, 0), loc=(0,0), orient="N"):
        self.inst_name =inst_name
        self.cell_height=cell_dim[0]
        self.cell_width=cell_dim[1]
        self.inst_loc_x = loc[0]
        self.inst_loc_y = loc[1]
        self.orient = orient
    
    def get_place_str(self):
        return(f"{self.inst_name} {self.inst_loc_x} {self.inst_loc_y} {self.orient}\n")
    
def gen_macro_cfg(instances=[], fh="./macro_placement.cfg"):
    with open(fh, "w") as f:    
        for inst in instances:
            f.write(inst.get_place_str())

if __name__ == '__main__':
    # Where the DL starts    
    dl_loc_init = (73.6, 5.44)

    # Geometry specs    
    grid_space_x = 0.460
    std_cell_height = 2.720

    # TT single tile
    max_x=161
    max_y=111 

    # Width of cells in delay line
    cell_width_grid_dle=16            # Currently using sky130_fd_sc_hd__fa_1
    cell_width_grid_capt_reg=24       # Currently using sky130_fd_sc_hd__edfxtp_1
    cell_width_um_dle=grid_space_x*cell_width_grid_dle
    cell_width_um_capt_reg=grid_space_x*cell_width_grid_capt_reg

    # X-space between DL element and register
    insts = []
    tdc_len = 64

    # Create instances
    dl_loc = dl_loc_init
  
    for i in range(tdc_len):
        # Delay line element  
        inst_dl  = StdCellInstance(f"tdc_inst.dl_inst.dl_genblk.dl.rca_genblk\\[{i}\\].FA", (dl_loc[0], dl_loc[1]), "N")
        # Register
        inst_reg = StdCellInstance(f"tdc_inst.dl_inst.dl_genblk.dl.rca_genblk\\[{i}\\].FA", (dl_loc[0], dl_loc[1]+2*cell_width_um), "N")
        # Calculate next macro location
        dl_loc[1]=dl_loc[1]+cell_height
        if(next_pos_y+cell_height > max_y):
            dl_loc[0]=dl_loc[0]+cell_width_um_dle+cell_width_um_capt_reg
            cell_height = -1*cell_height

    gen_macro_cfg(insts)

