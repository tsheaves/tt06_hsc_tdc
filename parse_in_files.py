import os
from subprocess import Popen, PIPE
from glob import glob
import shutil

def clear_dir(target_dir):
    if(os.path.isdir(target_dir)):
        shutil.rmtree(target_dir)
    os.mkdir(target_dir)


if __name__ == '__main__':
    # Prefix for cell rename
    std_cell_prefix="tt_export_"

    # Get EVs
    OPENLANE_ROOT=os.getenv('OPENLANE_ROOT')
    PDK_ROOT=os.getenv('PDK_ROOT')
    USER=os.getenv('USER')
    UID=os.geteuid()
    GID=os.getegid()
    CWD=os.getcwd()

    # Library within PDK
    LIB_PDK="sky130A/libs.ref"
    TECH="sky130_fd_sc_hd"

    # Tech path
    TECH_PATH=f"{PDK_ROOT}/{LIB_PDK}/{TECH}"

    # Get GDS file paths
    GDS_FILES=glob(TECH_PATH+f"/gds/{TECH}*.gds")

    clear_dir('./gds')

    # Build a Klayout script that reads in a GDS and prefixes all cells
    kl_script = []
    kl_script.append(f'prefix_str="{std_cell_prefix}_*"')
    kl_script.append("layout = RBA::Layout::new")
    kl_script.append("layout.read($input)")
    kl_script.append("layout.each_cell do |cell|")
    kl_script.append("\tcell_name = layout.cell_name(cell.cell_index)")
    kl_script.append("\tnew_cell_name = prefix_str.gsub(/#/, cell.cell_index.to_s).gsub(/\\*/, cell_name)")
    kl_script.append("\tif cell_name != new_cell_name")
    kl_script.append("\t\tlayout.rename_cell(cell.cell_index, new_cell_name)")
    kl_script.append("\tend")
    kl_script.append("end")
    kl_script.append(f"layout.write($output)")

    # Write script to CWD - this is the project directory in the OpenLane container
    kl_script_name="klayout_script.rb"
    with open(kl_script_name, "w") as f_kl:
        f_kl.write("\n".join(kl_script))

    # Construct docker klayout command
    klayout_cmd_docker  = ['docker']
    klayout_cmd_run=[]
    klayout_cmd_run.append('run')
    klayout_cmd_run.append(f'-v {OPENLANE_ROOT}:/openLANE_flow')
    klayout_cmd_run.append(f'-v {PDK_ROOT}:{PDK_ROOT}')
    klayout_cmd_run.append(f'-v {CWD}:/project') 
    klayout_cmd_run.append(f'-v {CWD}/gds:/project/gds') 
    klayout_cmd_run.append(f'-e PDK_ROOT={PDK_ROOT}')
    klayout_cmd_run.append(f'-u {UID}:{GID}')
    klayout_cmd_run.append(f'efabless/openlane')

    # Prefix all GDS files
    for f_gds in GDS_FILES:
        out_name=std_cell_prefix + os.path.basename(f_gds)
        klayout_cmd_run.append(f'klayout -b -r /project/{kl_script_name} -rd input={f_gds} -rd output=/project/gds/{out_name}')
        run_str = [" ".join(klayout_cmd_run)]
        print(klayout_cmd_docker + run_str)
        kl_proc = Popen(klayout_cmd_docker + run_str, stdout=PIPE, stderr=PIPE)
        stdout, stderr = kl_proc.communicate()

    # Command to check GDS afterward:
    # docker run -it -v $OPENLANE_ROOT:/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -v $PWD:/project -e PDK_ROOT=$PDK_ROOT -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -e QT_GRAPHICSSYSTEM="native" -u $(id -u $USER):$(id -g $USER) efabless/openlane klayout -s /project/tt_export_sky130_fd_sc_hd.gds -l $PDK_ROOT/sky130A/libs.tech/klayout/tech/sky130A.lyp 

    # Add prefix to cell names in lef & lib files
    # Tech file paths
    LIB_FILES=glob(TECH_PATH+f"/lib/{TECH}*.lib")
    LEF_FILES=glob(TECH_PATH+f"/lef/{TECH}*.lef")

    clear_dir('./lib')
    clear_dir('./lef')

    shutil.rmtree
    for f_lib in LIB_FILES:
        out_name='./lib/' + std_cell_prefix + os.path.basename(f_lib)
        shutil.copyfile(f_lib, f"./{out_name}")
        # Add prefix to all cells
        # Read in the file
        with open(f'./{out_name}', 'r') as f_lib:
          filedata = f_lib.read()

        # Replace the target string
        filedata = filedata.replace(TECH, std_cell_prefix+TECH)

        # Write the file out again
        with open(f'./{out_name}', 'w') as f_lib:
          f_lib.write(filedata)

    for f_lef in LEF_FILES:
        out_name= './lef/' + std_cell_prefix + os.path.basename(f_lef)
        shutil.copyfile(f_lef, f"./{out_name}")
        # Add prefix to all cells
        # Read in the file
        with open(f'./{out_name}', 'r') as f_lef:
          filedata = f_lef.read()

        # Replace the target string
        filedata = filedata.replace(TECH, std_cell_prefix+TECH)

        # Write the file out again
        with open(f'./{out_name}', 'w') as f_lef:
          f_lef.write(filedata)
        

