# EHT-Imaging Pipeline Installation and Dependency Installations

### __Setup directories with pipeline code and data__
```
# Make sure wget and tar are installed -- use system package manager:
sudo apt install -y wget
sudo apt install -y tar

# Create a new directory for installing / running pipeline
cd ~
mkdir eht-imaging
cd eht-imaging

# Clone the pipelines repo for image reconstruction
git clone https://github.com/eventhorizontelescope/2019-D01-02.git
cd 2019-D01-02

# Download compressed uvfits files from repo
wget https://github.com/eventhorizontelescope/2019-D01-01/raw/master/EHTC_FirstM87Results_Apr2019_uvfits.tgz

# Extract uvfits files to: ./2019/data/[single_file]
mkdir -p data
tar -xvzf EHTC_FirstM87Results_Apr2019_uvfits.tgz -C data --strip-components=1
```

### There are 2 options for installation. Option 1 is the recommended method for non-POWER systems. Option 2 will be required to install on systems with POWER architectures.
- Option 1 will use conda and pip to install all dependencies
- Option 2 will use spack to install most dependencies but will require the manual installation of the nfft and pynfft dependencies.

## __Option 1 (recommended):__

### __Install Anaconda package manager and create a new environment__
You will need to find the version for your system at the bottom of this [page](https://www.anaconda.com/products/individual).
Copy the link and paste in place of the link in the wget command below. This link is for the Ubuntu/Linux download.
```
wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
bash Anaconda-latest-Linux-x86_64.sh
```
Follow the installation procedures for installing Anaconda after running bash script above.

Create a new conda environment using python v3.8.10
```
conda create -n eht-imaging-condaenv python=3.8.10
conda activate eht-imaging-condaenv
```

### __Begin installing dependencies in your environment__
```
conda install pip
```
Check to make sure that pip returns with the one inside your conda env. This should be at `$HOME/anaconda3/envs/eht-imaging-condaenv/bin/pip` if you followed the default install location for Anaconda.
```
which pip
```
If this returns a different pip than the one in your conda environment, you can still use pip to install, but you will have to include the path to the pip you want to use. For example, in the code block below, you would replace `pip` with `$HOME/anaconda3/envs/eht-imaging-condaenv/bin/pip` to utilize the conda environment with your pip dependency installations. There are other ways to resolve this, but I feel that this is the simplest and easiest method.
```
pip install matplotlib
pip install argparse
pip install numpy
pip install networkx
pip install requests
pip install scikit-image
pip install ehtim
conda install -c conda-forge pynfft
```
__All of the dependencies are installed and you should be able to run the pipeline__

## __Option 2 (neccessary for POWER systems):__

### __Install spack, gcc-9.3.0 compiler, and python v.3.8.8__
Install and set up spack if not already installed.
```
cd ~
git clone https://github.com/spack/spack.git
. spack/share/spack/setup-env.sh
```

Install gcc compiler and add to spack's available compilers.
```
cd ~
spack install gcc@9.3.0
spack compiler add $(spack location -i gcc@9.3.0)
spack load gcc@9.3.0
```
Install python v.3.8.8.
```
spack install python@3.8.8 %gcc@9.3.0
spack load python@3.8.8
```

### __Install all of the available spack dependencies__
The dependencies in this code block should install with no issues.
```
spack install py-matplotlib@3.3.4 %gcc@9.3.0
spack load py-matplotlib@3.3.4
spack install py-argparse@1.4.0 %gcc@9.3.0
spack load py-argparse@1.4.0
spack install py-numpy@1.20.1 %gcc@9.3.0
spack load py-numpy@1.20.1
spack install py-networkx@2.4 %gcc@9.3.0
spack load py-networkx@2.4
spack install py-requests@2.24.0 %gcc@9.3.0
spack load py-requests@2.24.0
spack install py-scikit-image@0.17.2 %gcc@9.3.0
spack load py-scikit-image@0.17.2
```
The nfft package will not install directly from spack, but you can install all of its dependencies via spack and then manually install the needed nfft package.
```
spack install --only dependencies nfft@3.4.1 %gcc@9.3.0
```

### __Manually install nfft v.3.4.1__
You will need to add the lib directory of fftw3 to `LD_LIBRARY_PATH` to allow nfft to find it during installation.
```
export LD_LIBRARY_PATH=$HOME/spack/opt/spack/linux-rhel7-power9le/gcc-9.3.0/fftw-3.3.9-42lwbg7vmqhoanklu7bcpvrroswze3eu/lib:$LD_LIBRARY_PATH
```
There is a link for download and build instructions for nfft [here].(https://www-user.tu-chemnitz.de/~potts/nfft/installation.php). Download the file, extract it, and build.
All necessary instructions are given below.
```
wget https://www-user.tu-chemnitz.de/~potts/nfft/download/nfft-3.4.1.tar.gz
tar -zxf nfft-3.4.1.tar.gz
cd nfft-3.4.1

./configure --enable-all --enable-openmp --prefix=$HOME/nfft-3.4.1/install --with-fftw3=$HOME/spack/opt/spack/linux-rhel7-power9le/gcc-9.3.0/fftw-3.3.9-42lwbg7vmqhoanklu7bcpvrroswze3eu/ LDFLAGS="-L/$HOME/spack/opt/spack/linux-rhel7-power9le/gcc-9.3.0fftw-3.3.9-42lwbg7vmqhoanklu7bcpvrroswze3eu/lib"

make
make install
```

### __Manually install pynfft v.1.3.3__
Download the pynfft tar-file and extract it
```
wget https://files.pythonhosted.org/packages/4c/3d/049200e44351861ca754f15d772ea14b0b447ee41f7b8d29f6357a674ca6/pyNFFT2-1.3.3.tar.gz 
tar -xvf pyNFFT2-1.3.3.tar.gz
cd pyNFFT2-1.3.3/
```

You will have to edit the `setup.py` file by removing some conflicting compilation flags in `extra_compile_args` and adding paths to `library_dirs` and `include_dirs`.

Lines 30 - 39 of the `pyNFFT2-1.3.3/setup.py` file should look like below after changes, no other changes are made to this file:
```
30 # Define utility functions to build the extensions
31 def get_common_extension_args():
32    import numpy
33    common_extension_args = dict(
34        libraries=['nfft3_threads', 'nfft3', 'fftw3_threads', 'fftw3', 'm'],
35        library_dirs=["$HOME/spack/opt/spack/linux-rhel7-power9le/gcc-9.3.0/fftw-3.3.9-42lwbg7vmqhoanklu7bcpvrroswze3eu/lib", "$HOME/man-libs/eht-imaging-pipeline/nfft-3.4.1/install/lib"],
36        include_dirs=["$HOME/spack/opt/spack/linux-rhel7-power9le/gcc-9.3.0/fftw-3.3.9-42lwbg7vmqhoanklu7bcpvrroswze3eu/include", "$HOME/man-libs/eht-imaging-pipeline/nfft-3.4.1/include", numpy.get_include()],
37        extra_compile_args='-O3 -fstrict-aliasing -ffast-math'.split(),
38        )
39    return common_extension_args
```

Run the setup.py file, then build and install
```
python setup.py build_ext -I $HOME/nfft-3.4.1/include/ -L $HOME/nfft-3.4.1/install/lib/ -R $HOME/nfft-3.4.1/install/lib/

python setup.py build
python setup.py install
```

### __Install the remaining spack dependencies and EHTIM package__
First install the remaining dependencies
```
spack install py-pip@20.2 %gcc@9.3.0
spack load py-pip@20.2
spack install py-scipy@1.6.1 %gcc@9.3.0
spack load py-scipy@1.6.1
spack install py-astropy@4.0.1 %gcc@9.3.0 
spack load py-astropy@4.0.1 
spack install py-ephem@3.7.7.1 %gcc@9.3.0
spack load py-ephem@3.7.7.1
spack install py-h5py@3.2.1 %gcc@9.3.0
spack load py-h5py@3.2.1
spack install py-future@0.18.2 %gcc@9.3.0
spack load py-future@0.18.2
spack install py-pandas@1.2.3 %gcc@9.3.0
spack load py-pandas@1.2.3
```

Now install the EHTIM package using spack's py-pip.
```
pip install ehtim
```

You will have to add fftw3 to your path for ehtim to find it at runtime. This command will need to be completed after each time that your shell is re-sourced.
```
export LD_LIBRARY_PATH=$HOME/spack/opt/spack/linux-rhel7-power9le/gcc-9.3.0/fftw-3.3.9-42lwbg7vmqhoanklu7bcpvrroswze3eu/lib:$LD_LIBRARY_PATH
```

A few minor syntax changes need to be made to address errors that are in the ehtim package which prevent it from running successfully.

- On line 322 of `<path-to-ehtim>/imager.py`, remove the `.decode()` portion of the `print(response.message.decode())` statement. the new statements on lines 322 should look as below.
```
print(response.message)
```

- On lines 508 and 556 of `<path-to-ehtim>/obsdata.py`, add `dtype=object` to the statements. The new statements on lines 508 and 556 should look as below.
```
np.array(datalist, dtype=object)
```

__All of the dependencies are installed and you should be able to run the pipeline__
