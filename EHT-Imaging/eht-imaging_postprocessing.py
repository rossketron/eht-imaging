import matplotlib
matplotlib.use('Agg')
import os
import argparse
import ehtim as eh

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
params = [8.29e-11, 8.29e-11, 0] # This is for EHT-Imaging (17.1 uas)

if(args.blur or args.all): im_obj.blur_gauss(params)

if(args.beam or args.all): im_obj.display(cbar_unit=['Tb'], label_type=scale, beamparams=params, export_pdf=args.outfile)
else: im_obj.display(cbar_unit=['Tb'], label_type=scale, export_pdf=args.outfile)
