#!/bin/bash
#SBATCH --job-name=RBLD
#SBATCH --output=out-rbld-%j.out
#SBATCH --time=06:00:00
#SBATCH --account=n01-pml
##SBATCH --partition=serial
##SBATCH --qos=serial
#SBATCH --partition=standard
#SBATCH --qos=standard
#SBATCH --nodes=1
##SBATCH --ntasks-per-node=2
##SBATCH --cpus-per-task=64
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=128
##SBATCH --mem=125G

# submit with:
# sbatch --export=ITER=4464,SPIN=1 rebuild_restart.slurm

#rsync -aP /work/n01/n01/annkat/TOOLS_NEMO/r4.0.4/tools/REBUILD_NEMO/BLD/bin/rebuild_nemo.exe .

#module load PrgEnv-gnu
module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1

CURR_DIR=$PWD
SERIAL=$(printf "%08d" $ITER)
INDIR=$PWD/RESTARTS
OUTDIR=$PWD/RESTARTS_PROCESSED

mkdir -p $OUTDIR

rm nam_rebuild_trc
rm nam_rebuild_ice
rm nam_rebuild

if [ $SPIN -ge 4 ] #NB: hardcoded 3y spin cycle
then
  ndom=$(ls -1 $INDIR/"$NAM"_"$SERIAL"_restart_trc_????.nc | wc -l)
  echo -e "&nam_rebuild\nfilebase='"$INDIR"/"$NAM"_"$SERIAL"_restart_trc'\nndomain=$ndom\n/" >> nam_rebuild_trc
  echo -e "&nam_rebuild\nfilebase='"$INDIR"/"$NAM"_"$SERIAL"_restart_ice'\nndomain=$ndom\n/" >> nam_rebuild_ice
  echo -e "&nam_rebuild\nfilebase='"$INDIR"/"$NAM"_"$SERIAL"_restart'\nndomain=$ndom\n/" >> nam_rebuild
else
  ndom=$(ls -1 $INDIR/"$NAM"_S"$SPIN"_"$SERIAL"_restart_trc_????.nc | wc -l)
  echo -e "&nam_rebuild\nfilebase='"$INDIR"/"$NAM"_S"$SPIN"_"$SERIAL"_restart_trc'\nndomain=$ndom\n/" >> nam_rebuild_trc
  echo -e "&nam_rebuild\nfilebase='"$INDIR"/"$NAM"_S"$SPIN"_"$SERIAL"_restart_ice'\nndomain=$ndom\n/" >> nam_rebuild_ice
  echo -e "&nam_rebuild\nfilebase='"$INDIR"/"$NAM"_S"$SPIN"_"$SERIAL"_restart'\nndomain=$ndom\n/" >> nam_rebuild
fi

echo $SERIAL

rm timing_rbld_$SERIAL
touch timing_rbld_$SERIAL
echo start: >> timing_rbld_$SERIAL
ls -lhrt timing_rbld_$SERIAL >> timing_rbld_$SERIAL


# THIS RUNS!
# restaret_trc takes 5h 26m on compressed files, 2h on uncompressed files
echo ...REBUILDING RESTARTS...
srun --distribution=block:block --hint=nomultithread --unbuffered ./rebuild_nemo.exe nam_rebuild_trc
srun --distribution=block:block --hint=nomultithread --unbuffered ./rebuild_nemo.exe nam_rebuild_ice
srun --distribution=block:block --hint=nomultithread --unbuffered ./rebuild_nemo.exe nam_rebuild

touch timing_rbld_$SERIAL
echo rebuild completed >> timing_rbld_$SERIAL
ls -lhrt timing_rbld_$SERIAL >> timing_rbld_$SERIAL

echo Done.
