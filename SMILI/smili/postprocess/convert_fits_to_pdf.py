import matplotlib
matplotlib.use('Agg')
import os
import argparse
import ehtim as eh

#-------------------------------------------------------------------------------
# Load command-line arguments
#-------------------------------------------------------------------------------
parser = argparse.ArgumentParser(description="Scipt to convert eht fits files to pdf image")
parser.add_argument('-i' , '--infile'  ,   default="" ,help="input UVFITS file")
parser.add_argument('-o' , '--outfile' ,   default="" ,help="output PDF file")
args = parser.parse_args()

# Load fits file into image object
im_obj = eh.image.load_fits(args.infile)
params = [9.018e-11, 9.018e-11, 0]

# Blur with gaussian fwhm params and display
# im_obj = im_obj.blur_gauss(params)
im_obj.display(cbar_unit=['Tb'], label_type='none', beamparams=params, export_pdf=args.outfile)

