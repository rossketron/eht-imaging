#!/usr/bin/env bash
#
# Copyright (C) 2019 The Event Horizon Telescope Collaboration
#
# Traverse the data directory and run eht-imaging_pipeline on each day's
# lo and hi band .uvfits files. 
# 
# To save .pdf of final image, uncomment --savepdf arg.
# To save .pdf of image summary statistics, uncomment --imsum (This doesn't work currently)
#

# Check if Data is available, if not, then unpack the provided tarball
if [[ ! -d ../data ]]; then
    echo "========= Data not yet unpacked, executing ../unpack_data.sh ================="
    cd ../
    bash unpack_data.sh
    cd EHT-Imaging/
    echo "======================= Finished unpacking Data =============================="
fi

for d in 095 096 100 101; do
    python eht-imaging_pipeline.py \
        -i  ../data/uvfits/SR1_M87_2017_${d}_lo_hops_netcal_StokesI.uvfits \
        -i2 ../data/uvfits/SR1_M87_2017_${d}_hi_hops_netcal_StokesI.uvfits \
        -o        ./pipeline-output/SR1_M87_2017_${d}.fits
       --savepdf
       #--imsum
done
