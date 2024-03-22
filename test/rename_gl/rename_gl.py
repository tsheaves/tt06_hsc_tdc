#!/usr/bin/env python
# coding: utf-8

# In[1]:


import glob
import os
import shutil

# Clear SDF dir
if os.path.exists("./renamed_sdf"):
    shutil.rmtree("./renamed_sdf")
os.mkdir("./renamed_sdf")
os.mkdir("./renamed_sdf/multicorner")
corners = ["min", "nom", "max"]
for corner in corners:
    os.mkdir("./renamed_sdf/multicorner/" + corner)

# Clear gln dir
if os.path.exists("./gln"):
    shutil.rmtree("./gln")
os.mkdir("./gln")


# In[10]:


# Get all GL netlists
gl_netlists = glob.glob("../../runs/wokwi/results/final/verilog/gl/*.v", recursive=True)

# Rename SDF - easy just replace /. with _
for gln in gl_netlists:
    with open(gln, "r") as f:
        # Crappy regex rules - must be modified for different toolchain
        gln_lines = f.readlines()
        out_lines = []
        correct_lst = []
        for line in gln_lines:
            if("input " in line or "output " in line or "wire [" in line):
                line_start = line
                # keepers for multi-bit nets to multi-bit nets
                if("[") in line:
                    line_range = line.split("[")[1]
                    line_range = line_range.split("]")[0]
                    idx_start  = int(line_range.split(":")[1].strip(" "))
                    idx_end    = int(line_range.split(":")[0].strip(" "))
                    wire_name  = line.split("]")[1].strip(";\n").strip(" ")
                    # Build structure to correct overwrites for inputs and outputs
                    correct_lst.append({"name": wire_name, "idx_start":idx_start, "idx_end":idx_end})
                    line_start = line
                        
            else:
                line_start = line.replace("[", "_").replace("]", "")
                
            if("\\" in line):
                # port connection
                if("(\\" in line):
                    rn_line = line_start.split("(\\")
                    rn_line_pre = rn_line[0]+"("
                    rn_line = rn_line[1].split(")")
                    rn_line_rn = rn_line[0].replace(".", "_")
                    if(";\n" == rn_line[-1]):
                        rn_line_end = ")" + "".join(rn_line[1:-2]) + ");\n"
                    else: 
                        rn_line_end = ")" + "".join(rn_line[1:])
                # wire
                elif("wire \\" in line):
                    rn_line = line_start.split("wire \\")
                    rn_line_pre = rn_line[0]+"wire "
                    rn_line = rn_line[1]
                    rn_line_rn = ""
                    rn_line_end = rn_line.replace(".", "_")
                # instance
                else:
                    rn_line = line_start.split("\\")
                    rn_line_pre = rn_line[0]
                    rn_line = rn_line[1].split("(")
                    rn_line_rn = rn_line[0].replace(".", "_")
                    rn_line_end = "(" + "(".join(rn_line[1:])
                    
                out_line = rn_line_pre + rn_line_rn + rn_line_end
                print(out_line)
                out_lines.append(rn_line_pre + rn_line_rn + rn_line_end)
                        
            else:
                out_lines.append(line_start)

    gln_renamed = "".join(out_lines)
                    
    # Fix I/O
    print(correct_lst)
    for io in correct_lst:
        for idx in range (io["idx_start"], io["idx_end"] + 1):
            gln_renamed = gln_renamed.replace("("+io["name"]+"_"+str(idx), "(" + io["name"]+"["+str(idx)+"]")
            gln_renamed = gln_renamed.replace(" "+io["name"]+"_"+str(idx), " " + io["name"]+"["+str(idx)+"]")
    
    out_fh = "./gln/" + os.path.basename(gln)
    with open(out_fh, "w") as f:
        f.write(gln_renamed)


# In[2]:


# Get all SDF Files
sdfs = glob.glob("../../runs/wokwi/results/final/sdf/**/*.sdf", recursive=True)
# Rename SDF - easy just replace /. with _
for sdf in sdfs:
    with open(sdf, "r") as f:
        output_sdf = f.read().replace("\.", "_").replace("\[","_").replace("\]", "")
    # Figure out where to store output SDF
    parent = os.path.basename(os.path.dirname(sdf))
    if(parent != "sdf"):
        out_fh = "./renamed_sdf/multicorner/" + parent + "/" + os.path.basename(sdf)
    else:
        out_fh = "./renamed_sdf/" + os.path.basename(sdf)

    with open(out_fh, "w") as f:
        f.write(output_sdf)


# In[33]:


get_ipython().system('jupyter nbconvert --to script rename_gl.ipynb')


# In[ ]:




