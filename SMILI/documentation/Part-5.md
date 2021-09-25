# Post Processing
The black hole images shown in Paper IV uses the afmhot_10us colormap as well as a restoring beam for blurring. ```run_postprocessing.sh``` should run ```smili_postprocessing.py``` for the four days of observation and output a pdf of the image. There are some notable commands and edits you can make to the code depending on each output. Be sure to reference the [post-processing](https://github.com/jacobleonard545/EHT-SMILI/tree/main/post-processing) repository.

<br>

### Applying afmhot_10us
```
colors = np.loadtxt("afmhot_10us.cmap", delimiter=" ", unpack=False)
newcmp = matplotlib.colors.ListedColormap(colors)
```

### Restoring Beam (blur)
```
if(args.blur or args.all): im_obj = im_obj.blur_gauss(params)
```

### Extra Notes
* Remove ```cbar_orientation='horizontal'``` for units
* Remove ```beamparams=params``` to remove circle

<br>

Notes on averaging the images as mentioned in the paper are still in progress.
