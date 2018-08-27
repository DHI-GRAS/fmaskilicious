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

ls -l $INDIR

for f in $INDIR/*; do
    if [ "$(basename $f)" != "GRANULE" ]; then
        ln -s $(readlink -f $f) $WORKDIR/$(basename $f)
    fi
done

# run fmask for every granule in SAFE
for granule_path in $INDIR/GRANULE/*; do
    granule=$(basename $granule_path)
    echo "Processing granule $granule"

    granuledir=$WORKDIR/GRANULE/$granule
    mkdir -p $granuledir
    for f in $INDIR/GRANULE/$granule/*; do
        ln -s $(readlink -f $f) $granuledir/$(basename $f)
    done
    ls -l $granuledir

    # call fmask
    cd $granuledir
    /usr/GERS/Fmask_4_0/application/run_Fmask_4_0.sh $MCROOT "$@"

    # copy outputs from workdir
    mkdir -p $OUTDIR/$granule
    for f in $granuledir/FMASK_DATA/*; do
        cp $f $OUTDIR/$granule
    done
done

ls -l $WORKDIR
ls -l $WORKDIR/GRANULE/*

rm -rf $WORKDIR