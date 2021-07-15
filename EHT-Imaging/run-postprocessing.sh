#!/usr/bin/env bash

# Traverse output dir and apply post-processing to each .fits file
for d in 095 096 100 101; do
    python eht-imaging_postprocessing.py \
        -i  ./pipeline-output/SR1_M87_2017_${d}.fits \
        -o  ./pipeline-output/SR1_M87_2017_${d}_processed.pdf \
        --all
done
