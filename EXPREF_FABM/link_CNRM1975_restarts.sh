CURR_DIR=$PWD/RESTARTS
ANNA_DIR=/work/n01/n01/annkat/MissAtl/nemo/cfgs/se-eORCA025/EXP_CNRM_HIST/RESTARTS
YUTI_DIR=/work/n01/shared/yuti/se-ORCA025_restart_trc_zps/split_8090

ln -sf $ANNA_DIR/CNRM_hist_19760101_restart_*.nc $CURR_DIR
ln -sf $YUTI_DIR/* $CURR_DIR/

cd $CURR_DIR

rename SENEMO CNRM_hist *nc
rename S0_00000000 19760101 *.nc
