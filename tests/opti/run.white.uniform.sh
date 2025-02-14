#!/bin/bash

export OMP_NUM_THREADS=4
ntask=2

schedule="schedules/schedule.opti.txt"
cmb_input="ffp10_lensed_scl_100_nside0512.fits"

outdir=out/opti/white_uniform
mkdir -p $outdir/ml
mkdir -p $outdir/pd

# ML run
logfile=$outdir/ml/run.log
echo "Writing $logfile"
mpirun -np $ntask ./so_mappraiser.py \
    $(< sat.par) \
    --thinfp 64 \
    --schedule $schedule \
    --scan_map.file $cmb_input \
    --mappraiser.lagmax 1 \
    --mappraiser.downscale 3000 \
    --variable_model.use_white \
    --variable_model.uniform \
    --out $outdir/ml \
    >$logfile 2>&1

# PD run
logfile=$outdir/pd/run.log
echo "Writing $logfile"
mpirun -np $ntask ./so_mappraiser.py \
    $(< sat.par) \
    --thinfp 64 \
    --schedule $schedule \
    --scan_map.file $cmb_input \
    --mappraiser.lagmax 1 \
    --mappraiser.downscale 3000 \
    --mappraiser.pair_diff \
    --variable_model.use_white \
    --variable_model.uniform \
    --out $outdir/pd \
    >$logfile 2>&1
