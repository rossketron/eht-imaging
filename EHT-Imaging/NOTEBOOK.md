# Jupyter Notebook Showing the EHT-Imaging imaging pipeline used by the Event Horizon Telescope Collaboration to produce the M87* Black Hole Images

## Installation / Environment Set-Up
### In order to run this notebook please follow the commands below to create a conda environment with the necessary packages and dependencies.
#### __Install Anaconda package manager and create a new environment__ -- _if Anaconda is not already installed_
You will need to find the version for your system at the bottom of this [page](https://www.anaconda.com/products/individual).
Copy the link and paste in place of the link in the wget command below. This link is for the Ubuntu/Linux download.
```
wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
bash Anaconda-latest-Linux-x86_64.sh
```
Follow the installation procedures for installing Anaconda after running bash script above.

#### __Create a new conda environment from the `.yml` file in this repository__
```
conda env create --file eht-imaging_environment.yml
```
This installs all necessary dependencies, including the needed Jupyter products to run the notebook.
#### __To run the notebook in Jupyter Lab__
```
jupyter lab
```
If you are using the WSL in Windows, you will need to use `jupyter lab --no-browser` to run the notebook
