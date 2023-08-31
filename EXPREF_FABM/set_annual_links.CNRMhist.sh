#!/bin/bash
# Command line arguments:
#   $1: rundir
#   $2: simulation year

#INPUT_PATH=/work/n01/n01/...
INDIR_Ndep=/work/n01/shared/yuti/se-ORCA025_Ndep/
INDIR_Fedep=/work/n01/shared/yuti/se-ORCA025_Fedep/
INDIR_pCO2a=/work/n01/shared/yuti/se-ORCA025_pCO2a/
INDIR_ADY=/work/n01/shared/yuti/se-ORCA025_ADY_clim/
INDIR_RIVERS=/work/n01/shared/yuti/se-ORCA025_CNRM_hist/


RUNPATH=$PWD
yn=$1             # curr year
yb=$(( $yn-1 ))   # previous year
ya=$(( $yn+1 ))   # next year

ln -sf  $INDIR_Ndep/eORCA025_r015-r010_007_004v2_N_dep_ISIMIP_y${yn}.nc $RUNPATH/eORCA025_N_dep_ISIMIP_y${yn}.nc
ln -sf  $INDIR_Ndep/eORCA025_r015-r010_007_004v2_N_dep_ISIMIP_y${yb}.nc $RUNPATH/eORCA025_N_dep_ISIMIP_y${yb}.nc
ln -sf  $INDIR_Ndep/eORCA025_r015-r010_007_004v2_N_dep_ISIMIP_y${ya}.nc $RUNPATH/eORCA025_N_dep_ISIMIP_y${ya}.nc

#cheat to do 2019 & 2020
#ln -sf  $INDIR_Ndep/eORCA025_r015-r010_007_004v2_N_dep_ISIMIP_y2018.nc $RUNPATH/eORCA025_N_dep_ISIMIP_y${yn}.nc
#ln -sf  $INDIR_Ndep/eORCA025_r015-r010_007_004v2_N_dep_ISIMIP_y2018.nc $RUNPATH/eORCA025_N_dep_ISIMIP_y${yb}.nc
#ln -sf  $INDIR_Ndep/eORCA025_r015-r010_007_004v2_N_dep_ISIMIP_y2018.nc $RUNPATH/eORCA025_N_dep_ISIMIP_y${ya}.nc

ln -sf  $INDIR_Fedep/eORCA025_r015-r010_007_004v2_Fe_dep_GESAMP.nc $RUNPATH/eORCA025_Fe_dep_GESAMP.nc

ln -sf $INDIR_RIVERS/CNRM_river_BGC_y${yn}.nc ${RUNPATH}/RIVERS/CNRMhist_BGC_y${yn}.nc
ln -sf $INDIR_RIVERS/CNRM_river_BGC_y${ya}.nc ${RUNPATH}/RIVERS/CNRMhist_BGC_y${ya}.nc
ln -sf $INDIR_RIVERS/CNRM_river_BGC_y${yb}.nc ${RUNPATH}/RIVERS/CNRMhist_BGC_y${yb}.nc
ln -sf $INDIR_RIVERS/runoff_socoefr_v2.nc  ./RIVERS/runoff_socoefr_v2.nc


ln -sf  $INDIR_pCO2a/eORCA025_v2_pCO2a_global_y${yn}.nc $RUNPATH/eORCA025_pCO2a_global_y${yn}.nc
ln -sf  $INDIR_pCO2a/eORCA025_v2_pCO2a_global_y${yb}.nc $RUNPATH/eORCA025_pCO2a_global_y${yb}.nc
ln -sf  $INDIR_pCO2a/eORCA025_v2_pCO2a_global_y${ya}.nc $RUNPATH/eORCA025_pCO2a_global_y${ya}.nc

ln -sf  $INDIR_ADY/eORCA025_r015-r010_007_004v2_ady.nc ${RUNPATH}/eORCA025-CCI-ady-broadband-climatology.nc
