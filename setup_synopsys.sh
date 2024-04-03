#! /bin/zsh
# 27-04-09 mrg Started LOG. Please track all changes here.
# 27-04-09 Upgraded ngspice to rework 19
# 03-05-09 Added 45nm FreePDK
# 03-05-09 Added Ciranova PyCell suite
# 07-05-09 Put Ciranova PyCell suite in separate config.
# 11-06-09 Update vcs,synplifyPro,syn to 2006.9
# 06-07-09 Add bluespec
# 06-20-09 Updated Cadence license server
# 08-28-09 Commented out bad license servers (xilinx, altera, chipeda)
# 09-18-09 Update Nangate to latest version
# 11-25-09 Added ADS license server and setup
# 12-01-09 Added nec2c
# 12-04-09 Added ADS 2008
# 12-11-09 Upgraded to SOC81, MMSIM70, IUS81, RC91
# 01-03-10 Upgraded ngspice to rework 20
# 05-10-10 Added ATI stream SDK
# 06-02-10 Updated to development version of ngspice.
# 06-03-10 Added starrc
# 06-23-10 Added ATI stream SDK 32-bit version too
# 06-29-10 Add sparc-elf from gaisler
# 08-04-10 Added Mentor Tessent
# 02-15-11 Added First Encounter (Removed SOC Encounter)
# 03-22-11 Installed 2012.10 HSPICE
# 06-30-11 Installed Helic VeloceRaptorX and techfiles
# 09-27-11 Reverted back to SCMOS NCSU design kit
# 01-23-12 Added Synopsys CosmoScope
# 01-26-12 Added Sonnet
# 07-03-12 Added Synopsys Nanotime
# 08-30-12 Upgraded to Calibre 2012.3_15.13
# 01-03-13 Upgraded to CosmosScope 2012.12
# 01-03-13 Upgraded to IC-615
# 04-01-13 Upgraded Spectre to SPB166 from SPB133
# 04-01-13 Upgraded HSpice to H-2013.03 from B-2008.09
# 04-02-13 Raj eliminated NCSU-CDK/PDK variables
# 04-03-13 Raj introduced MGC_TMPDIR variable
# 04-29-13 MRG removed old matlab paths
# 04-30-13 MRG added new matlab paths (R2012b)
# 05-17-13 MRG Added glade
# 08-12-13 Renau. Moved most of the LD_LIBRARY_PATH to setup_cadence.sh (conflicts). Commented with ##
# 02-20-14 Renau. added primerail
# 03-10-14 Mrg. Changed all paths to use SOFT.
# 05-06-15 MRG Updated Matlab license server
# 10-25-15 MRG Updated ngspice to ngspice-25
# 08-17-16 MRG Changed LM_LICENSE_FILE to new host
# 11-11-15 MRG Updated ngspice to ngspice-26
# 09-11-17 RTP Updated vivado to 2017.2
# 01-06-20 Updated vcs to 2019.06-SP2
####################################################################################
# Default terminal/color settings
#export PS1="\h:\w\$"

# SUN
if [ "`uname -m`" == "sparc64" ] ; then
  export PATH=${PATH}:/opt/csw/bin/:/opt/SUNWspro/bin/:/opt/csw/gcc4/bin/:/usr/ccs/bin
  export PATH=${PATH}:/opt/csw/sparc-sun-solaris2.8/bin/:/usr/openwin/bin/
  export PATH=${PATH}:/opt/SUNWspro/extra/bin
  export MANPATH=$MANPATH:/opt/SUNWspro/man/
  export PATH=${PATH}:/opt/Adobe/Acrobat7.0/bin
  export PATH=${PATH}:/usr/X11R6/bin
fi
####################################################################################
if [ -d "/mada/software" ]; then
	export SOFT=/mada/software
elif [ -d "/projects/mada/software" ]; then
	export SOFT=/projects/masc/software
else
	echo "Neither /mada nor /projects/masc is available"
fi

##########################
if [ "`uname -m`" == "x86_64" ] ; then
        export MINT_TARGET="opteron"
elif [ "`uname -m`" == "powerpc" ] ; then
        export MINT_TARGET="G5"
fi
export LD_LIBRARY_PATH=/usr/lib:/lib:/lib64

##########################
# Matlab
export PATH=${PATH}:${SOFT}/matlab/R2012b/bin

##########################
# Altera
#export QUARTUS_ROOTDIR=${SOFT}/altera/quartus/
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${QUARTUS_ROOTDIR}/lib
#export PATH=${PATH}:${QUARTUS_ROOTDIR}/bin/

##########################
# Xilinx (installed in mascd1) xps and ise
# use USB to upload bitfiles (impact)
#export XIL_IMPACT_USE_LIBUSB=1
#export XILINX="${SOFT}/xilinx/14.4/ISE_DS/ISE"
#export XILINX_EDK="${SOFT}/xilinx/14.4/ISE_DS/EDK"
#export PATH=${PATH}:${SOFT}/xilinx/11.1/EDK/bin/lin64:${SOFT}/xilinx/11.1/ISE/bin/lin64
#alias xps="PATH=/bin:/usr/bin/:/sbin/:${SOFT}/xilinx/11.1/EDK/bin/lin64/:${SOFT}/xilinx/11.1/ISE/bin/lin64/ ${SOFT}/xilinx/11.1/EDK/bin/lin64/xps"
export PATH=${PATH}:${SOFT}/xilinx/Vivado/2017.2/bin
export PATH=${PATH}:${SOFT}/xilinx/Vivado_HLS/2017.2/bin

##########################
# Mentor Graphics
export VSIM_HOME=${SOFT}/mentor/modeltech/
if [ "`uname -m`" == "sun4v" ]; then
  export CALIBRE_HOME=${SOFT}/mentor/calibre/aoi_cal_2017.3_29.23
  #export CALIBRE_HOME=${SOFT}/mentor/calibre/ixl_cal_2008.3_16.12
  #export CALIBRE_HOME=${SOFT}/mentor/calibre/ixl_cal_2007.1_24.22
#  #export CALIBRE_HOME=${SOFT}/mentor/calibre/ixl_cal_2007.4_14.15
else
  export CALIBRE_HOME=${SOFT}/mentor/calibre/aoi_cal_2017.3_29.23
  export MGC_HOME=$CALIBRE_HOME
  #export CALIBRE_HOME=${SOFT}/mentor/calibre/ixl_cal_2012.3_15.13
  #export MGC_HOME=${SOFT}/mentor/calibre/ixl_cal_2008.3_16.12
  #export CALIBRE_HOME=${SOFT}/mentor/calibre/ixl_cal_2008.3_16.12
  #export MGC_HOME=${SOFT}/mentor/calibre/ixl_cal_2007.1_24.22
  #export CALIBRE_HOME=${SOFT}/mentor/calibre/ixl_cal_2007.1_24.22
  #export MGC_HOME=${SOFT}/mentor/calibre/ixl_cal_2007.4_14.15
  #export CALIBRE_HOME=${SOFT}/mentor/calibre/ixl_cal_2007.4_14.15
fi
export PATH=$PATH:${VSIM_HOME}/bin
export PATH=$PATH:${CALIBRE_HOME}/bin
export TESSENT_HOME=${SOFT}/mentor/tessent90
export PATH=$PATH:${TESSENT_HOME}/bin
export MGC_TMPDIR=/tmp


##########################
# Bluespec
#export BLUESPECDIR=${SOFT}/I

##########################
# Cadence
#export CDS_LIC_FILE="5280@ftpnew.cse.ucsc.edu <mailto:5280@ftpnew.cse.ucsc.edu>"
export CDS_LIC_FILE="5280@lmserv.soe.ucsc.edu <mailto:5280@lmserv.soe.ucsc.edu>"
export CDS_INST_DIR=${SOFT}/cadence
export PATH=${PATH}:/mada/software/cadence/INNOVUS162/bin
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/mada/software/cadence/INNOVUS162/tools.lnx86/lib/64bit

#Alegro
#export PATH=$PATH:${SOFT}/cadence/SPB163/tools/pcb/bin/
#export PATH=$PATH:${SOFT}/cadence/SPB163/tools/bin/
export PATH=$PATH:${SOFT}/cadence/SPB166/tools/pcb/bin/
export PATH=$PATH:${SOFT}/cadence/SPB166/tools/bin/
#Ultrasim
export PATH=$PATH:${SOFT}/cadence/MMSIM70/tools/bin
export MMSIMHOME=${SOFT}/cadence/MMSIM70/
export MMSIM_PATH=${SOFT}/cadence/MMSIM70/tools/bin
#export PATH=$PATH:${SOFT}/cadence/MMSIM61/tools/bin
#export MMSIMHOME=${SOFT}/cadence/MMSIM61/
#export MMSIM_PATH=${SOFT}/cadence/MMSIM61/tools/bin

# ncverlog/ncsim -- must come before virtuoso
export NCV_HOME=${SOFT}/cadence/IUS81
##export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SOFT}/cadence/IUS81/tools.lnx86/lib
#export NCV_HOME=${SOFT}/cadence/IUS62
export PATH=$PATH:${NCV_HOME}/tools.lnx86/bin/

# Virtuoso / IC tools
#export CDS_ROOT=${SOFT}/cadence/IC615/tools.lnx86
export CDS_ROOT=${SOFT}/cadence/IC611/tools.lnx86
#export CDS_ROOT=${SOFT}/cadence/IC5141/tools.lnx86
#export CDS_ROOT=${SOFT}/cadence/ICOA5251/tools.lnx86
export PATH=$PATH:$CDS_ROOT/bin
#export OA_HOME=${SOFT}/cadence/IC615/share/oa
export OA_UNSUPPORTED_PLAT=linux_rhel40_gcc44x
export OA_HOME=${SOFT}/cadence/IC611/share/oa
#export OA_HOME=${SOFT}/cadence/ICOA5251/share/oa
#export OA_HOME=${SOFT}/cadence/OA22/share/oa
export PATH=$PATH:${SOFT}/cadence/ICC11241/tools.lnx86/iccraft/bin/
#export PATH=$PATH:${SOFT}/cadence/IC615/tools.lnx86/dfII/bin
export PATH=$PATH:${SOFT}/cadence/IC611/tools.lnx86/dfII/bin
#export PATH=$PATH:${SOFT}/cadence/ICOA5251/tools.lnx86/dfII/bin
##export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SOFT}/cadence/ICC11241/tools.lnx86/lib
#export LD_LIBRARY_PATH=${SOFT}/cadence/ICOA5251/share/oa/lib/linux_rhel30_64/opt
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SOFT}/cadence/IC615/share/oa/lib/linux_rhel40_gcc44x_64/opt
##export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SOFT}/cadence/IC611/share/oa/lib/linux_rhel40_gcc44x_64/opt
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SOFT}/cadence/ICOA5251/share/oa/lib/linux_rhel30_32/opt

# Signalstorm
export SS_HOME=${SOFT}/cadence/TSI61
export PATH=$PATH:${SS_HOME}/tools.lnx86/bin

# RC (rc -64)
export CDN_SYNTH_ROOT=${SOFT}/cadence/RC91/tools.lnx86/
#export CDN_SYNTH_ROOT=${SOFT}/cadence/RC72/tools.lnx86/

# First Encounter
export PATH=$PATH:${SOFT}/cadence/EDI91/tools.lnx86/bin/
export PATH=$PATH:${SOFT}/cadence/EDI91/bin/
##export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SOFT}/cadence/EDI91/tools.lnx86/lib

# SoC encounter
#export PATH=$PATH:${SOFT}/cadence/SOC81/tools.lnx86/bin/
#export PATH=$PATH:${SOFT}/cadence/SOC81/bin/
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SOFT}/cadence/SOC81/tools.lnx86/lib
#export PATH=$PATH:${SOFT}/cadence/SOC71/tools.lnx86/bin/
#export PATH=$PATH:${SOFT}/cadence/SOC71/bin/
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SOFT}/cadence/SOC71/tools.lnx86/lib

# Encounter Test
export PATH=$PATH:${SOFT}/cadence/ET31/bin/
# VoltageStorm
#export PATH=$PATH:${SOFT}/cadence/SEV41/tools.lnx86/sev/bin/64bit
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SOFT}/cadence/ICC11241/share/oa/lib/linux_rhel30_64/opt/

##########################
# NCSU CDK
#export CDK_DIR=${SOFT}/techfiles/ncsu
#export CDK_DIR=${SOFT}/techfiles/NCSU_CDK_1.5.1
#export CDK_DIR=${SOFT}/techfiles/ncsu-cdk-1.6.0.beta
export PDK_DIR=${SOFT}/techfiles/FreePDK45
export FREEPDK45="/mada/software/techfiles/FreePDK45"

#export SYSTEM_CDS_LIB_DIR=$CDK_DIR/cdssetup
#export CDS_SITE=$CDK_DIR
#export USE_NCSU_CDK

export CDSHOME=${SOFT}/cadence/IC611

export SKIP_CDS_DIALOG
export CDS_Netlisting_Mode=Analog
#export LD_ASSUME_KERNEL=2.4.1
export OA_MODE=opt
export OA_BIT=32

##########################
# OSU Stdcell libraries
#export OSUcells=${SOFT}/techfiles/osu_soc_v2.7/synopsys
export OSUcells=${SOFT}/techfiles/osu_soc_v2.7/cadence
#export PATH=${PATH}:${OSUcells}/flow/bin
#export CDS_SITE=${SOFT}/techfiles/osu_soc_v2.7/cadence/ic/local

##########################
# OpenAccess
# this conflicts with OA version needed for Virtuoso/Cadence
# if you need to do OA development, source the settings in
# ${SOFT}/setup_oa226.sh
#
#export OA_PATH=${SOFT}/oa2.2.6
#export OA_MODE=opt
#export OA_BIT=32
#export PATH=$PATH:$OA_PATH/bin
#export LD_LIBRARY_PATH=$OA_PATH/lib/linux_rhel30_64/opt
#

##########################
# lp_solve
export PATH=$PATH:${SOFT}/lp_solve_5.5/lp_solve
##export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${SOFT}/lp_solve_5.5/lpsolve55

##########################
# magic
export PATH=${PATH}:${SOFT}/magic/bin
export MANPATH=${MANPATH}:${SOFT}/magic/man
export CAD_ROOT=${SOFT}/magic/lib
##########################
# irsim
export PATH=${PATH}:${SOFT}/irsim/bin
export MANPATH=${MANPATH}:${SOFT}/irsim/man
##########################
# netgen
export PATH=${PATH}:${SOFT}/netgen/bin


##########################
# synopsys
export PATH=$PATH:${SOFT}/synopsys/verdi/Verdi_N-2017.12/bin
export PATH=$PATH:${SOFT}/synopsys/icwbev_plus/D-2010.06-14/bin/
export PATH=$PATH:${SOFT}/synopsys/identify/N-2017.09-SP1/bin/
export PATH=$PATH:${SOFT}/synopsys/xa/N-2017.12/bin/
export PATH=$PATH:${SOFT}/synopsys/lc/N-2017.12-SP1/bin/

export PATH=$PATH:${SOFT}/synopsys/fpga/N-2017.09-SP1/bin/
# VCS
#export VCS_ARCH_OVERRIDE=linux
#export VCS_TARGET_ARCH=amd64
#export VCS_HOME=${SOFT}/synopsys/vcs-mx/N-2017.12-1/
#export VCS_HOME=${SOFT}/synopsys/vcs-mx/K-2015.09-SP2-14
export VCS_HOME=/mada/software/synopsys/vcs/P-2019.06-SP2
#export VCS_HOME=/mada/software/synopsys/vcs/T-2022.06
# export VCS_HOME=/mada/software/synopsys/vcs/T-2022.06-1/
export PATH=${PATH}:${VCS_HOME}/bin
export MANPATH=$MANPATH:${VCS_HOME}/doc/man

# Technology files
export TECH_TSMC40=${SOFT}/techfiles/TSMCHOME/digital/Front_End/verilog/tcbn40lpbwp_120a/tcbn40lpbwp.v
export TECH_STM90=${SOFT}/techfiles/cmos90/CORE90GPLVT_2.2/behaviour/verilog/CORE90GPLVT.v
export TECH_SAED32=${SOFT}/techfiles/saed32/SAED32_EDK/lib/stdcell_hvt/verilog/saed32nm_hvt.v
# Synthesis
export SYN_HOME=${SOFT}/synopsys/syn/N-2017.09-SP2
export PATH=${PATH}:${SYN_HOME}/bin
## Milkyway (before STARRC)
#export PATH=${PATH}:${SOFT}/synopsys/mw/bin/AMD.64
# Magellan
#export MG_HOME=${SOFT}/synopsys/magellan/
#export PATH=${PATH}:${SOFT}/synopsys/magellan/amd64/ctg/bin
# STARRC
#export PATH=${PATH}:${SOFT}/synopsys/starrc/amd64_starrc/bin
# Formality
#export PATH=${PATH}:${SOFT}/synopsys/fm/N-2017.09-SP2/bin
export PATH=${PATH}:${SOFT}/synopsys/fm/R-2020.09-SP2/bin/
## Astro
#export PATH=${PATH}:${SOFT}/synopsys/astro/bin
#export PATH=${PATH}:${SOFT}/synopsys/astroiu/bin
#export PATH=${PATH}:${SOFT}/synopsys/astrorail/bin
#export PATH=${PATH}:${SOFT}/synopsys/ns/bin
#export PATH=${PATH}:${SOFT}/synopsys/psyn/bin
# Hspice,ngspice,etc
#export PATH=${PATH}:${SOFT}/synopsys/hspice/linux
export PATH=${PATH}:${SOFT}/synopsys/I-2013.12-1/hspice/bin
export HSPICE_64=1
export PATH=${PATH}:${SOFT}/ngspice-28/bin
# Cosmoscope
export PATH=${PATH}:${SOFT}/synopsys/CosmosScope64/H-2012.12/ai_bin
alias cosmos='${SOFT}/synopsys/CosmosScope/H-2012.12/ai_bin/cscope'
alias cosmos64='${SOFT}/synopsys/CosmosScope64/I-2013.12/ai_bin/cscope'
# Nanotime
#export PATH=${PATH}:${SOFT}/synopsys/G-2012.06/bin
# ICW (GDS)
##alias icwbev="LD_LIBRARY_PATH=${SOFT}/synopsys/D-2010.06-14icw/lib/amd64/ ${SOFT}/synopsys/icw/bin/amd64/icwbev"
#export PATH=${PATH}:${SOFT}/synopsys/icw/bin/amd64

# ICC
export PATH=${PATH}:${SOFT}/synopsys/icc/N-2017.09-SP2/bin
# Vera
#if [ "`uname -m`" == "sun4v" ]; then
  #export VERA_HOME=${SOFT}/synopsys/vera/vera_vA-2007.12_sparcOS5
#else
  #export VERA_HOME=${SOFT}/synopsys/vera/vera_vA-2007.12_amd64
#fi
#export PATH=${PATH}:${VERA_HOME}/bin
# Primetime
export PTS_HOME=${SOFT}/synopsys/pts/N-2017.12/
export PATH=${PATH}:${PTS_HOME}/bin
# Primepower?
#export PPS_HOME=${SOFT}/synopsys/pps
#export PATH=${PATH}:${PPS_HOME}/bin
# Nanosim
#export NS_HOME=${SOFT}/synopsys/ns
#export PATH=${PATH}:${NS_HOME}/bin

##########################
# CHIP EDA (chipmason)
#export PATH=$PATH:${SOFT}/chipeda/chipmason-4.0.9/bin

##########################
# ADS
#export HPEESOF_DIR=${SOFT}/ADS2009U1
#export PATH=$PATH:${SOFT}/ADS2009U1/bin
export HPEESOF_DIR=${SOFT}/ADS2008
export PATH=$PATH:${SOFT}/ADS2008/bin
# nec2c
export PATH=$PATH:${SOFT}/nec2c/bin

##########################
# Licenses
export LM_LICENSE_FILE="27000@license.soe.ucsc.edu"
#export LM_LICENSE_FILE="1718@lmserv-new.soe.ucsc.edu"                   # Matlab
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":1800@ftpnew.cse.ucsc.edu"    # altera
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":27002@ftpnew.cse.ucsc.edu"   # maple
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":1717@lmserv-new.soe.ucsc.edu"  # mentor
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":2200@ftpnew.cse.ucsc.edu"    # xilinx
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":2100@lmserv.soe.ucsc.edu"    # xilinx
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":1709@ftpnew.cse.ucsc.edu"    # synplicity
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":5280@lmserv.cse.ucsc.edu"  # cadence
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":27007@ftpnew.cse.ucsc.edu"  # ADS
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":27001@ftpnew.cse.ucsc.edu" # synopsys
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":27003@lmserv.soe.ucsc.edu" # synopsys
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":27009@ftpnew.cse.ucsc.edu" # chipeda
#export LM_LICENSE_FILE=$LM_LICENSE_FILE":27001@lmserv.soe.ucsc.edu" # bluespec
# MAN PATH
export MANPATH=$MANPATH:/usr/share/man:${SYN_HOME}/doc/syn/man

##########################
# CUDA Path
export PATH=$PATH:/usr/local/cuda/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib

##########################
# Helic VeloceRaptorX
export HELIC_ROOT=$SOFT/helic_2011.24.1
# for gf 28nm
export HELIC_PDK_ROOT=$SOFT/techfiles/hc_cmos28hpp_8U1x_2T16x_LB
export VRF_ROOT=$SOFT/techfiles/VeloceRF_v1.6_cmos28g/vlc_8U1x_2T16x_LB
# for tsmc 45nm
#export HELIC_PDK_ROOT=$SOFT/techfiles/hc_tsmcN45_1p8m_5X0Y2R
#export VRF_ROOT=$SOFT/techfiles/VeloceRF_v1.6_tsmcN45/vlc_1p8m_5X0Y2R

export HCLMD_LICENSE_FILE=5175@lmserv.soe.ucsc.edu
# add to .cdsinit
#$VRF_ROOT/setup/.cdsinit 
#$HELIC_ROOT/tools/vrx/setup/.cdsinit
# copy to working dir
#$HELIC_ROOT/tools/cds/data.reg

##########################
# Glade
export GLADE_HOME=${SOFT}/glade
export PATH=$GLADE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$GLADE_HOME/lib:$LD_LIBRARY_PATH
#export PYTHONPATH=/usr/lib/python2.7:$GLADE_HOME/bin
#export PYTHONHOME=/usr/lib/python2.7

##########################
# Sonnet
export SONNET_DIR=${SOFT}/sonnet
export PATH=$PATH:$SONNET_DIR/bin
export LM_LICENSE_FILE=$LM_LICENSE_FILE:7852@lmserv.soe.ucsc.edu

##########################
# CodeAnalysis (Profiling AMD in mada1)
export PATH=$PATH:/opt/CodeAnalyst/bin/

##########################
# MIPS64 diet setup
export PATH=$PATH:${SOFT}/mips/install-mips-img-linux-gnu/bin

##########################
# Ruby RVM setup
if [ -f "/etc/profile.d/rvm.sh" ]; then
  source /etc/profile.d/rvm.sh
fi

##########################
# Cadence Stratus (HLS)
export PATH=$PATH:${SOFT}/cadence/stratus19/bin

##########################
# RISC-V setup
#export RISCV=/mada/software/riscv/
#export PATH=$RISCV/bin:$PATH

##########################
# ATI Stream Path
if [ "`uname -m`" == "x86_64" ]; then
  export ATISTREAMSDKROOT=${SOFT}/ati-stream-sdk-v2.1-lnx64
  export PATH=$PATH:$ATISTREAMSDKROOT/bin/x86_64
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ATISTREAMSDKROOT/lib/x86_64
else
  export ATISTREAMSDKROOT=${SOFT}/ati-stream-sdk-v2.1-lnx32
  export PATH=$PATH:$ATISTREAMSDKROOT/bin/x86
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ATISTREAMSDKROOT/lib/x86
fi

if [ "$MADA_SETUP" != "1" ]; then
	if [ "$(id -G | grep 513)" != "" ]; then 
		export MADA_SCRAP=/local/scrap/masc/$USER
	elif [ "$(id -G | grep 1186)" != "" ]; then 
		export MADA_SCRAP=/local/scrap/vama/$USER
	elif [ "$(id -G | grep 1026)" != "" ]; then 
		export MADA_SCRAP=/local/scrap/vlsi/$USER
	else
		unset MADA_SCRAP
	fi

	if [ -d /local/scrap/ -a ! -d $MADA_SCRAP ]; then
		mkdir -p $MADA_SCRAP
		mkdir -p $MADA_SCRAP/bazel_cache
	fi
	if [ ! -d $HOME/.cache/bazel ]; then
		ln -sf $MADA_SCRAP/bazel_cache $HOME/.cache/bazel
	fi
fi

export MADA_SETUP=1
if [ -z "$NOBANNER" ]; then
if [ "`tty`" != "not a tty" ]; then
  echo '========================================================================'
  echo '$$$$$$$$$$$$$$$$$ $$$$$       _/      _/    _/_/      _/_/_/    _/_/_/  '
  echo '$$$$$$$          $$$$$  $    _/_/  _/_/  _/    _/  _/        _/         '
  echo '$$$$$   $$$$$$$$$$$   $$$   _/  _/  _/  _/_/_/_/    _/_/    _/          '
  echo '$$$$   $$$$$$$$$$$$$   $$  _/      _/  _/    _/        _/  _/           '
  echo '$$$$   $$$$$  $$   $$  $$ _/      _/  _/    _/  _/_/_/      _/_/_/      '
  echo '$$$$   $$$$  $$$$$$$$$  $  M I C R O                                    '
  echo '$$      $$$$$$$$$$$$$$  $    A R C H I T E C T U R E  L A B             '
  echo '$  $$$   $$$$$$$$$ $$$  $      S A N T A                                '
  echo '  $$$$$   $$$$     $$   $        C R U Z                                '
  echo '   $$$$$   $$$$$$$$$$  $$                                               '
  echo '   $$$$$$    $$$$$$   $$$  UNIVERSITY OF CALIFORNIA, SANTA CRUZ         '
  echo '========================================================================'
fi
fi

