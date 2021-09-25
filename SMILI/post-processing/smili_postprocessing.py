import matplotlib
matplotlib.use('Agg')
import os
import argparse
import ehtim as eh
import numpy as np

#-------------------------------------------------------------------------------
# Load command-line arguments
#-------------------------------------------------------------------------------
parser = argparse.ArgumentParser(description="Script to convert EHT_Difmap fits files to pdf images")
parser.add_argument('-i', '--infile' , default=""   , help="input FITS file")
parser.add_argument('-o', '--outfile', default=""   , help="output PDF file")
parser.add_argument('-s', '--scale'  , default=False, help="display scale in output"          , action='store_true')
parser.add_argument('-b', '--beam'   , default=False, help="display beam size in output"      , action='store_true')
parser.add_argument('-l', '--blur'   , default=False, help="apply Gaussian blur to image"     , action='store_true')
parser.add_argument('-a', '--all'    , default=False, help="perform all post-processing steps", action='store_true')
args = parser.parse_args()

if(args.outfile == ""):
   args.outfile = args.infile[:-5]+'_processed.pdf'
print("Exporting PDF to", args.outfile)
if(args.scale or args.all): scale = 'scale'
else: scale = 'none'

# Load fits file into image object
im_obj = eh.image.load_fits(args.infile)
params = [9.018e-11, 9.018e-11, 0] # This is for SMILI (18.6 uas)

# Create color map of afmhot_10us, vals copied from ehtplot/color/ctabs/afmhot_10us.ctab file
colors = np.loadtxt("afmhot_10us.cmap", delimiter=" ", unpack=False)
newcmp = matplotlib.colors.ListedColormap(colors)

# Uncomment this to apply restoring beam
# if(args.blur or args.all): im_obj = im_obj.blur_gauss(params)


if(args.beam or args.all): im_obj.display(cbar_unit=['Tb'], cbar_orientation='horizontal', cfun=newcmp, beamparams=params, label_type=scale, export_pdf=args.outfile)

