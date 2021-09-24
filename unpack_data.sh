#!/bin/bash
mkdir -p images
mkdir -p data_validation/data
tar -xvzf EHTC_FirstM87Results_Apr2019_uvfits.tgz -C data_validation/data --strip-components=1
tar -xvzf EHTC_FirstM87Results_Apr2019_csv.tgz -C data_validation/data --strip-components=1
mkdir -p data_validation/data/csv/converted