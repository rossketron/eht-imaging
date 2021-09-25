# Ds9, ehtim, and ehtplot

These modules are needed to closely reproduce the M87 Black Hole images.

## [Ds9](https://sites.google.com/cfa.harvard.edu/saoimageds9/home)

Download tar file and extract

```
tar xzvf Downloads/ds9.ubuntu18.8.2.1.tar.gz
```
Set flags for ds9. libxss1 should already be installed, but double check

```
sudo mv ds9 /usr/local/bin
sudo chmod +x /usr/local/bin/ds9
sudo apt-get install libxss1
```
$ ds9
If installed correctly, the application should pop up

## [ehtim](https://github.com/achael/eht-imaging)

This part is a little bit on the complicated side, but is necessary to reproduce the black hole images. 

Install nfft library from dev site
```
wget https://www-user.tu-chemnitz.de/~potts/nfft/download/nfft-3.4.1.tar.gz
tar -zxf nfft-3.4.1.tar.gz
cd nfft-3.4.1
```
Set path to fftw3 to allow nfft configure to find fftw3 dependencies
```
export LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH

./configure --enable-all --enable-openmp --prefix=$HOME/nfft-3.4.1/install 

make
make install
```
PyNFFT
```
wget https://files.pythonhosted.org/packages/4c/3d/049200e44351861ca754f15d772ea14b0b447ee41f7b8d29f6357a674ca6/pyNFFT2-1.3.3.tar.gz
tar -xvf pyNFFT2-1.3.3.tar.gz
cd pyNFFT2-1.3.3/
```
You will have to edit the setup.py file by removing some conflicting compilation flags in extra_compile_args and adding paths to library_dirs and include_dirs.</br>
Lines 30 - 39 of the setup.py file should look like below after changes, no other changes are made to this file:
```
# Define utility functions to build the extensions
def get_common_extension_args():
    import numpy
    common_extension_args = dict(
        libraries=['nfft3_threads', 'nfft3', 'fftw3_threads', 'fftw3', 'm'],
        library_dirs=["$HOME/local/lib", "$HOME/nfft-3.4.1/install/lib"],
include_dirs=["$HOME/nfft-3.4.1/include", numpy.get_include()],
            )
        return common_extension_args
```
Run the setup.py file, then build and install
```
python setup.py build_ext -I $HOME/nfft-3.4.1/include/ -L $HOME/nfft-3.4.1/install/lib/ -R $HOME/nfft-3.4.1/install/lib/

python setup.py build
python setup.py install
```
Make sure dependencies are installed: 
```
pip install matplotlib
pip install argparse
pip install numpy
pip install networkx
pip install requests
pip install scikit-image
pip install ehtim
pip install --upgrade pandas
```
## ehtplot
ehtplot is essential in the post-processing part as we will need to add a colormap (afmhot_10us). I will cover this in later parts.






