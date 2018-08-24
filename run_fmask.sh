#!/bin/bash

set -e

ls -l /work

MCROOT=/usr/local/MATLAB/MATLAB_Runtime/v93
/usr/GERS/Fmask_4_0/application/run_Fmask_4_0.sh $MCROOT "$@"