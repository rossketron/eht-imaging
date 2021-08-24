# SMILI Documentation (Preparation, External Libraries, and Dependencies)

This part follows the [SMILI installation guide](https://smili.readthedocs.io/en/latest/install.html) and it's relatively straight 
forward. I didn't change much, but I'll still include exactly what I did below.

## Preparation
Ubuntu users
```
sudo apt-get install build-essential pkg-config git vim gfortran
```

## External Libraries

#### OpenBLAS
Install, compile, and check for appropriate compiler flags
```
git clone https://github.com/xianyi/OpenBLAS
cd OpenBLAS

make USE_OPENMP=1 CC=gcc FC=gfortran
make PREFIX="$HOME/local" install

export PKG_CONFIG_PATH="$HOME/local"/lib/pkgconfig:$PKG_CONFIG_PATH
pkg-config --debug openblas 
```
$ Path position of 'openblas' is 1 </br>
$ Adding 'openblas' to list of known packages

#### FFTW3
Install, compile, and check for appropriate compiler flags. Check website for most recent version
```
wget http://www.fftw.org/fftw-3.3.9.tar.gz 
tar xzvf fftw-3.3.9.tar.gz
cd fftw-3.3.9

./configure --prefix="$HOME/local" --enable-openmp --enable-threads --enable-shared
make
make install

pkg-config --debug fftw3
```
$ Path position of 'fftw3' is 1 </br>
$ Adding 'fftw3' to list of known packages </br>
If you're not receiving the above message, enter this command:</br>
```
export PKG_CONFIG_PATH="$HOME/local"/lib/pkgconfig:$PKG_CONFIG_PATH
```

#### FINUFFT
```
PREFIX="$HOME/local"
cd $PREFIX

git clone https://github.com/flatironinstitute/finufft
cd finufft

cp make.inc.powerpc make.inc
```
Copy and paste into make.inc:
```
# Compilers
CXX=g++
CC=gcc
FC=gfortran

# (compile flags for use with GCC are as in linux makefile)
CFLAGS +=

# Your FFTW3's installation PREFIX
CFLAGS += -I$HOME/local/include
LIBS += -L$HOME/local/lib

# You can keep them
FFLAGS   = $(CFLAGS)
CXXFLAGS = $(CFLAGS) -DNEED_EXTERN_C

# OpenMP with GCC on OSX needs following...
OMPFLAGS = -fopenmp
OMPLIBS = -lgomp
```
Finufft Dependencies:
```
sudo apt-get install make build-essential libfftw3-dev
sudo apt-get install gfortran python3 python3-pip octave liboctave-dev

make test -j
```
$ 0 segfaults out of 8 tests done</br>
$ 0 fails out of 8 tests done</br>

Compile
```
make lib
```
Copy finufft.pc from smili directory
```
cd $HOME
git clone https://github.com/astrosmili/smili

cd $HOME/local/lib/pkgconfig
cp $HOME/smili/finufft.sample.pc finufft.pc


pkg-config --debug finufft
```
$ Path position of 'finufft' is 1</br>
$ Adding 'finufft' to list of known packages</br>

#### SMILI
Install and compile
```
cd $HOME/smili

./configure
make install
```
Use these commands if there are errors finding the libraries:
 
Example for OpenBLAS</br>
export OPENBLAS_LIBS="-L$HOME/local/lib -lopenblas"</br>
export OPENBLAS_CFLAGS="-I$HOME/local/include"</br>

Example for FFTW3</br>
export FFTW3_LIBS="-L$HOME/local/ib -lfftw3"</br>
export FFTW3_CFLAGS="-IY$HOME/local/include"</br>

Example for FINUFFT</br>
export FINUFFT_LIBS="-L$HOME/local/lib -lfftw3"</br>
export FINUFFT_CFLAGS="-I$HOME/local/include”</br>

</br>
Check if everything is installed properly. If you receive no errors, then you're ready to go! </br>
</br>
$ python</br>
Python 3.7.0 (default, Jun 28 2018, 13:15:42)</br>
[GCC 7.2.0] :: Anaconda, Inc. on linux</br>
Type "help", "copyright", "credits" or "license" for more information.</br>
>>> from smili import imdata, uvdata, imaging</br>
>>></br>



