# EHT-Imaging Pipeline Installation and Dependency Installations

## __Clone Repository and Set-up for Dependency Installation__

Make sure system dependencies are installed -- use system package manager (The commands below assume Ubuntu, but you should change to your package manager):
```
sudo apt-get install -y wget tar git \
                        texlive-xetex \
                        texlive-fonts-recommended \
                        texlive-latex-recommended \
                        cm-super
```

Clone and traverse to the EHT-Imaging directory:
```
cd ~
git clone git@github.com:TauferLab/Src_EHT.git
cd Src_EHT/EHT-Imaging
```
</br>

------------------------------------------------------------


## __There are two options for installation dependending on your machine. Option 1 is the recommended method for X86_64 architectures (Intel). Option 2 will be required to install on systems with POWER architectures (IBM).__
1. __[This uses Conda and Pip to install dependencies via the provided `environment.yml` file.](#option-1-recommended)__
2. __[This uses Spack to install most dependencies but requires manual installation of the nfft and pynfft dependencies.](#option-2-neccessary-for-power-systems)__

-------------------------------------
</br>

# __Option 1 (recommended)__

### __Install Anaconda3 Package Manager__ -- _if not already installed_
You will need to find the version for your system at the bottom of this [page](https://www.anaconda.com/products/individual).
Copy the link and paste in place of the link in the wget command below. The link in the command below is for the Ubuntu/Linux download.
```
wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
bash Anaconda-latest-Linux-x86_64.sh
```
Follow the installation procedures for installing Anaconda after running the Anaconda installation script above.

### __Create Conda Environment__
Use the provided `EHT-Imaging_environment.yml` file to create the conda environment. This will install all of the needed pipeline dependencies automatically.
```
conda env create --file config/eht-imaging_environment.yml
conda activate eht-imaging
```

### __A few minor syntax changes are needed to address errors that are in the ehtim package which prevent the pipeline from running successfully.__
The paths to each file in the below steps assume that Anaconda is installed in the default location (the `$HOME` directory). If a custom install location was used, the paths will need to be changed to reflect this.

1. On `line 322` of `~/anaconda3/envs/eht-imaging/libs/python3.8/site-packages/ehtim/imager.py`, remove the `.decode()` portion of the `print(response.message.decode())` statement. the new statements on `line 322` should look as below.
```
print(response.message)
```

2.  On `line 508` and `line 556` of `~/anaconda3/envs/eht-imaging/libs/python3.8/site-packages/ehtim/obsdata.py`, add `dtype=object` to the statements. The new statements on `line 508` and `line 556` should look as below.
```
np.array(datalist, dtype=object)
```

### __Install the ehtplot library__
```
# Clone the library repo
git clone https://github.com/liamedeiros/ehtplot.git
cd ehtplot

# Add __init__.py file containing the word "pass" to 'extra' directory
# This resolves issue with installation not including the installation of the 'extra' module
echo "pass" > ehtplot/extra/__init__.py

# Install → this installs ehtplot into your current python's
# site-packages directory
python setup.py install
```
### __All depencies are installed__ -- Go [here](#Running-The-Pipeline) for documentation on running the pipeline
---------------------------
</br>

# __Option 2 (neccessary for POWER systems):__

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
There is a link for download and build instructions for nfft [here](https://www-user.tu-chemnitz.de/~potts/nfft/installation.php). Download the file, extract it, and build.
All necessary instructions are given below. This assumes installation into a `~/software/installs` directory used for manually installed software. These files can be placed elsewhere, however, the paths to `nfft-3.4.1` in preceding commands should be adjusted accordingly if placed in a location other than `~/software/installs`.
```
cd $HOME/software/installs
wget https://www-user.tu-chemnitz.de/~potts/nfft/download/nfft-3.4.1.tar.gz
tar -zxf nfft-3.4.1.tar.gz
rm nfft-3.4.1.tar.gz
cd nfft-3.4.1

## Replace `/home/cketron2/` with the path to your home directory 
./configure --enable-all --enable-openmp --prefix=/home/cketron2/software/install nfft-3.4.1/install --with-fftw3=/home/cketron2/spack/opt/spack/linux-rhel7-power9le/gcc-9.3.0/fftw-3.3.9-42lwbg7vmqhoanklu7bcpvrroswze3eu/ LDFLAGS="-L/home/cketron2/spack/opt/spack/linux-rhel7-power9le/gcc-9.3.0/fftw-3.3.9-42lwbg7vmqhoanklu7bcpvrroswze3eu/lib"

make
make install
```

### __Manually install pynfft v.1.3.3__
Download the pynfft tar-file and extract it
```
cd $HOME/software/installs
wget https://files.pythonhosted.org/packages/4c/3d/049200e44351861ca754f15d772ea14b0b447ee41f7b8d29f6357a674ca6/pyNFFT2-1.3.3.tar.gz 
tar -xvf pyNFFT2-1.3.3.tar.gz
rm pyNFFT2-1.3.3.tar.gz
cd pyNFFT2-1.3.3/
```

You will have to edit the `setup.py` file by removing some conflicting compilation flags in `extra_compile_args` and adding paths to `library_dirs` and `include_dirs`.

Lines 30 - 39 of the `pyNFFT2-1.3.3/setup.py` file should look like below after changes (replace `/home/cketron2/` with the path to your home directory, no other changes are made to this file:
```
30 # Define utility functions to build the extensions
31 def get_common_extension_args():
32    import numpy
33    common_extension_args = dict(
34        libraries=['nfft3_threads', 'nfft3', 'fftw3_threads', 'fftw3', 'm'],
35        library_dirs=["/home/cketron2/spack/opt/spack/linux-rhel7-power9le/gcc-9.3.0/fftw-3.3.9-42lwbg7vmqhoanklu7bcpvrroswze3eu/lib", "/home/cketron2/software/installs/nfft-3.4.1/install/lib"],
36        include_dirs=["/home/cketron2/spack/opt/spack/linux-rhel7-power9le/gcc-9.3.0/fftw-3.3.9-42lwbg7vmqhoanklu7bcpvrroswze3eu/include", "/home/cketron2/software/installs/nfft-3.4.1/include", numpy.get_include()],
37        extra_compile_args='-O3 -fstrict-aliasing -ffast-math'.split(),
38        )
39    return common_extension_args
```

Run the setup.py file, then build and install
```
python setup.py build_ext -I $HOME/software/installs/nfft-3.4.1/include/ -L $HOME/software/installs/nfft-3.4.1/install/lib/ -R $HOME/software/installs/nfft-3.4.1/install/lib/

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

A few minor syntax changes need to be made to address errors that are in the ehtim package which prevent it from running successfully. This assumes spack is installed in your $HOME directory. If the root spack folder is in a different directory, the paths to files below should be modified accordingly. The `[machine]` section of path will need to be modified to the machine that you are using. You can press `tab` while typing path to see a list of possible machines.

- On `line 322` of `~/spack/opt/spack/[machine]/gcc-9.3.0/python-3.8.8-4gxiwokjydtnlzoynruwjoeupyvhrpbc/lib/python3.8/site-packages/ehtim/imager.py`, remove the `.decode()` portion of the `print(response.message.decode())` statement. the new statements on `line 322` should look as below.
```
print(response.message)
```

- On `line 508` and `line 556` of `~/spack/opt/spack/[machine]/gcc-9.3.0/python-3.8.8-4gxiwokjydtnlzoynruwjoeupyvhrpbc/lib/python3.8/site-packages/ehtim/obsdata.py`, add `dtype=object` to the statements. The new statements on `line 508` and `line 556` should look as below.
```
np.array(datalist, dtype=object)
```

### __Install the ehtplot library__
```
# Clone the library repo
git clone https://github.com/liamedeiros/ehtplot.git
cd ehtplot

# Add __init__.py file containing the word "pass" to 'extra' directory
# This resolves issue with installation not including the installation of the 'extra' module
echo "pass" > ehtplot/extra/__init__.py

# Install → this installs ehtplot into your current python's
# site-packages directory
python setup.py install
```
---------------------------
</br>

__All of the dependencies are now installed. In order to execute the pipeline and produce images, follow the instructions [here](https://github.com/TauferLab/Src_EHT/blob/main/EHT-Imaging/docs/PIPELINE.md). In order to run the Jupyter Notebook, follow the instructions [here](https://github.com/TauferLab/Src_EHT/blob/main/EHT-Imaging/docs/NOTEBOOK.md).__
