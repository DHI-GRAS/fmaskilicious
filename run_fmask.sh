#!/bin/bash

set -e
shopt -s nullglob

MCROOT=/usr/local/MATLAB/MATLAB_Runtime/v96


# parse command line
if [ $# -lt 2 ] || [ "$1" == "--help" ]; then
    echo "Usage: run_fmask.sh SCENE_ID GRANULE FMASK_OPTIONS"
    exit 0
fi

SCENE_ID="$1"
shift
GRANULE="$1"
shift

INDIR=/mnt/input-dir/$SCENE_ID.SAFE
WORKDIR=/work/$SCENE_ID.SAFE
OUTDIR=/mnt/output-dir

if [ ! -d "$INDIR" ]; then
    echo "Error: no SAFE file found for scene ID $SCENE_ID"
    exit 1
fi


# ensure that workdir is clean
if [ -d $WORKDIR ]; then
    rm -rf $WORKDIR
fi
mkdir -p $WORKDIR


# symlink safe data into workdir
for f in $INDIR/*; do
    if [ "$(basename $f)" != "GRANULE" ]; then
        ln -s $(readlink -f $f) $WORKDIR/$(basename $f)
    fi
done


# run fmask for every granule in SAFE
for granule_path in "$INDIR/GRANULE/$GRANULE"; do
    granule=$(basename $granule_path)
    echo "Processing granule $granule"

    granuledir=$WORKDIR/GRANULE/$granule
    mkdir -p $granuledir

    # symlink granule data into workdir
    for f in $INDIR/GRANULE/$granule/*; do
        ln -s $(readlink -f $f) $granuledir/$(basename $f)
    done

    # call fmask
    cd $granuledir
    /usr/GERS/Fmask_4_3/application/run_Fmask_4_3.sh $MCROOT "$@"

    if [ ! -d $granuledir/FMASK_DATA ]; then
        echo "Error while running FMask on granule $granule"
        exit 1
    fi

    # copy outputs from workdir
    mkdir -p $OUTDIR/$granule
    for f in $granuledir/FMASK_DATA/*; do
        cp $f $OUTDIR/$granule
    done
done


rm -rf $WORKDIR
