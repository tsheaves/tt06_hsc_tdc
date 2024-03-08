class StdCellInstance:
    def __init__(self, inst_name="", loc=(0,0), orient="N"):
        self.inst_name =inst_name
#        self.cell_height=cell_dim[0]
#        self.cell_width=cell_dim[1]
        self.inst_loc_x = loc[0]
        self.inst_loc_y = loc[1]
        self.orient = orient
    
    def get_place_str(self):
        return(f"{self.inst_name} {self.inst_loc_x} {self.inst_loc_y} {self.orient}\n")
    
def gen_macro_cfg(instances=[], fh="../macro_placement.cfg"):
    with open(fh, "w") as f:    
        for inst in instances:
            f.write(inst.get_place_str())

if __name__ == '__main__':
    # Where the DL starts    
    dl_loc_init = (22.08, 10.88)
    tdc_len = 64

    # Geometry specs    
    grid_space_x = 0.460
    std_cell_height = 2.720

    # TT single tile
    max_x=153.64
    max_y=97.92

    # Width of cells in delay line
    cell_width_grid_dle=16            # Currently using sky130_fd_sc_hd__fa_1
    cell_width_grid_capt_reg=24       # Currently using sky130_fd_sc_hd__edfxtp_1
    cell_width_um_dle=grid_space_x*cell_width_grid_dle
    cell_width_um_capt_reg=grid_space_x*cell_width_grid_capt_reg

    # Create StdCell instances w/ placement attributes
    dl_loc = dl_loc_init
    insts=[]
    up = 1
    cell_orient = "S"
    # DL zig-zags vertically
    for i in range(tdc_len):
        if(cell_orient == "S"):
            cell_orient = "N"
        else:
            cell_orient = "S"
        # Delay line element  
        insts.append(StdCellInstance(f"tdc_inst.dl_inst.dl_genblk.dl.rca_genblk\\[{i}\\].FA", (dl_loc[0], dl_loc[1]), cell_orient))
        # Register
        insts.append(StdCellInstance(f"tdc_inst.dl_capt.capt_genblk\\[{i}\\].DFE", (round(dl_loc[0]+cell_width_um_dle+grid_space_x*10, 5), dl_loc[1]), cell_orient))
        # Calculate next macro Y location
        if(up):
            dl_loc_y=dl_loc[1]+std_cell_height
        else:
            dl_loc_y=dl_loc[1]-std_cell_height
        dl_loc_x = dl_loc[0]
        # Check boundary
        if(dl_loc_y > max_y or dl_loc_y < dl_loc_init[1]):
            dl_loc_x=dl_loc[0]+cell_width_um_dle+cell_width_um_capt_reg+grid_space_x*20
            dl_loc_y=dl_loc[1]           
            up = 0
        dl_loc = (round(dl_loc_x, 5), round(dl_loc_y,5))

    # Create macro placement config file
    gen_macro_cfg(insts)

