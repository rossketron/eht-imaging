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

if [[ ! -d data ]]; then
    echo "========= Data not yet unpacked, executing ../unpack_data.sh ================="
    cd ../
    bash unpack_data.sh
    cd scripts
    echo "======================= Finished Unpacking Data =============================="
fi

if [[ ! -d ../../output/EHT-Imaging ]]; then
    echo "========= Creating output directory at ../output/pipeline =============="
    mkdir -p ../output/pipeline
fi

echo "=============== Beginning EHT-Imaging Pipeline Execution ========================="
for d in 095 096 100 101; do
    python eht-imaging_pipeline.py \
        -i  ../data/uvfits/SR1_M87_2017_${d}_lo_hops_netcal_StokesI.uvfits \
        -i2 ../data/uvfits/SR1_M87_2017_${d}_hi_hops_netcal_StokesI.uvfits \
        -o  ../output/pipeline/SR1_M87_2017_${d}.fits \
       --savepdf \
       --imgsum
done
echo "=============== Finished EHT-Imaging Pipeline Execution ========================="
echo "                                                                                 "
echo "================== Beginning EHT-Imaging Post-processing ========================"
bash run-postprocessing.sh
echo "================== Finished EHT-Imaging Post-processing ========================="
