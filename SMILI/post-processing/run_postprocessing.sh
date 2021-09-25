#!/usr/bin/env bash
# Traverse output dir and apply post-processing to each .fits file
for d in 095 096 100 101; do
    python smili_postprocessing.py \
        -i  ./smili_reconstructions/SR1_M87_2017_${d}_lo_hops_netcal_StokesI.fits \
        -o  ./post/SR1_M87_2017_lo_${d}_processed.pdf \
	-a
    

done
