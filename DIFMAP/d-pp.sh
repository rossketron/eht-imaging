#!/usr/bin/env bash
for f in *.fits; do # only place lo-band noresidual fits files here or find some way to only select files with "lo" and ".noresidual.fits" in the name
        python difmap-postprocessing.py -i $f -o ../data/difmap-pdfs/raw-${f%.*}.pdf
done

for f in *.fits; do
        python difmap-postprocessing.py -i $f --all
done
