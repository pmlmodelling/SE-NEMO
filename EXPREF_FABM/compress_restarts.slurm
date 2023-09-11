#!/bin/bash
#SBATCH --job-name=CMPR
#SBATCH --output=out-CMPR-%j.out
#SBATCH --time=06:00:00
#SBATCH --account=n01-sanh
##SBATCH --partition=serial
##SBATCH --qos=serial
#SBATCH --partition=standard
#SBATCH --qos=standard
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=128

#sbatch --export=ITER=4464,SPIN=$nn_spin_cycle_rbld_rst compress_restarts.slurm

module load PrgEnv-gnu
module load cray-hdf5-parallel
module load cray-netcdf-hdf5parallel

CURR_DIR=$PWD
SERIAL=$(printf "%08d" $ITER)
INDIR=$CURR_DIR/RESTARTS
OUTDIR=$CURR_DIR/RESTARTS_PROCESSED

mkdir -p $OUTDIR

rm timing_compr_$SERIAL.txt
touch timing_compr_$SERIAL.txt
echo start: >> timing_compr_$SERIAL.txt
ls -lhrt timing_compr_$SERIAL.txt >> timing_compr_$SERIAL.txt

cd $INDIR
if [ $SPIN -ge 4 ]
then
  rst=$( ls "$NAM"_"$SERIAL"_restart.nc )
  rst_ice=$( ls "$NAM"_"$SERIAL"_restart_ice.nc )
  rst_trc=$( ls "$NAM"_"$SERIAL"_restart_trc.nc )
else
  rst=$( ls "$NAM"_S?_"$SERIAL"_restart.nc )
  rst_ice=$( ls "$NAM"_S?_"$SERIAL"_restart_ice.nc )
  rst_trc=$( ls "$NAM"_S?_"$SERIAL"_restart_trc.nc )
fi

rst=${rst:0:-3}
rst_ice=${rst_ice:0:-3}
rst_trc=${rst_trc:0:-3}
cd $CURR_DIR

echo compressing $rst
nccopy -s -k 4 -d 5 $INDIR/$rst.nc $OUTDIR/$rst.nc && rm $INDIR/$rst.nc && rm $INDIR/"$rst"_????.nc || echo restart failed!

touch timing_compr_$SERIAL.txt
echo done restart: >> timing_compr_$SERIAL.txt
ls -lhrt timing_compr_$SERIAL.txt >> timing_compr_$SERIAL.txt

echo compressing $rst_ice
nccopy -s -k 4 -d 5 $INDIR/$rst_ice.nc $OUTDIR/$rst_ice.nc && rm $INDIR/$rst_ice.nc && rm $INDIR/"$rst_ice"_????.nc || echo restart_ice failed!

touch timing_compr_$SERIAL.txt
echo done restart_ice: >> timing_compr_$SERIAL.txt
ls -lhrt timing_compr_$SERIAL.txt >> timing_compr_$SERIAL.txt

echo compressing $rst_trc
srun --distribution=block:block --hint=nomultithread --unbuffered nccopy -s -k 4 -d 5 $INDIR/$rst_trc.nc $OUTDIR/$rst_trc.nc && rm $INDIR/$rst_trc.nc && rm $INDIR/"$rst_trc"_????.nc  || echo restart_trc failed!

touch timing_compr_$SERIAL.txt
echo done restart_trc: >> timing_compr_$SERIAL.txt
ls -lhrt timing_compr_$SERIAL.txt >> timing_compr_$SERIAL.txt
