# Executing Pipeline

Clone the 2019-D01-02 from the [EHT Github Repo](https://github.com/eventhorizontelescope)
```
cd $HOME
git clone https://github.com/eventhorizontelescope/2019-D01-02.git
cd 2019-D01-02
```
Download compressed uvfits files from repo and extract them to: ./2019/data/[single_file]
```
wget https://github.com/eventhorizontelescope/2019-D01-01/raw/master/EHTC_FirstM87Results_Apr2019_uvfits.tgz

mkdir -p data
tar -xvzf EHTC_FirstM87Results_Apr2019_uvfits.tgz -C data --strip-components=1
```
Make the following changes:
* Change 'python2' to 'python' in both .py code (example_driver.py & smili_imaging_pipeline.py)
* In smili_imaging_pipeline.py, change all 'xrange' to 'range'
</br>
Once the changes have been made, you can execute the pipeline with the following command

```
./run.sh
```


</br>
I included my smili directory when I ran the driver code for comparison. It should create a folder ('smili_reconstruction') with the input, selfcal output, precal output, and .fits output. You can view the .fits image using ds9 or ehtim of all four observation days. You'll notice that the output doesn't quite match the images shown in the papers, so the next step will demonstrate the post-processing edits.
