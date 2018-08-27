#!/bin/bash

set -e
shopt -s nullglob

if [ "$1" == "--help" ]; then
    echo "Usage: run_fmask.sh FMASK_OPTIONS"
    exit 0
fi

MCROOT=/usr/local/MATLAB/MATLAB_Runtime/v93
INDIR=/mnt/input-dir
WORKDIR=/work
OUTDIR=/mnt/output-dir

# ensure that workdir is clean
rm -rf $WORKDIR
mkdir -p $WORKDIR
cd $WORKDIR

ls -l $INDIR

for f in $INDIR/*; do
    ln -s $(readlink -f $f) $WORKDIR/$(basename $f)
done

ls -l $WORKDIR

# run fmask
/usr/GERS/Fmask_4_0/application/run_Fmask_4_0.sh $MCROOT "$@"

# copy outputs from workdir
ls -l $WORKDIR

for f in $WORKDIR/FMASK_DATA/*; do
    cp $f $OUTDIR
done

rm -rf $WORKDIR