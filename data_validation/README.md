# Data Validation

### Docker Instructions
1. Please retrieve and/or build the Docker image according to the following methods:
   * **Build image LOCALLY:** Please run the following command from the external directory that contains the Src_EHT repository: `docker build --tag validate_data -f Src_EHT/data_validation/data_validation.dockerfile .` This will build the Docker container image.
   * **Pull [Docker Hub Image](https://hub.docker.com/r/globalcomputinglab/reproducibility-eht/tags):** Pull the `data-validation` container using the command `docker pull globalcomputinglab/reproducibility-eht:data-validation`.

2. Please run the image according to how you retrieved the Docker image:
   * **Building image LOCALLY:** Once it has finished building the image, please run the following command: `docker run -it -p 9000:8888 validate_data`. This runs the container and forwards everything from port 8888 in the container to the local machine's port 9000. This will allow you to interact with the container locally.
   * **Pulled Docker image:** Please run `docker run -it -p 9000:8888 globalcomputinglab/reproducibility-eht:data-validation /bin/bash` to start running the container.

3. Once inside the container, please run `bash unpack_data.sh` from the root directory (`/home/eht`) in the container. It will untar all of the data required for the script to run and make the necessary directories.

4. **Voila! The Docker container should be ready to go!** Please move on to the "Data Validation Jupyter Notebook Instructions" section below.



### Data Validation Jupyter Notebook Instructions
1. To easily view all files and run the notebook in the Jupyter Lab GUI, please run `jLab`. It is an alias for the command `jupyter lab --ip 0.0.0.0 --no-browser`. This will allow you to use a Jupyter Lab GUI to easily navigate around the repository.
   * If you do not have visualization capabilities, please run `python ReproducePlots.py` in the `data_validation/` directory. You can ignore the rest of the steps, but please read the "Notes" section. 

2. In your local machine’s browser, type `localhost:9000`. It should ask for a token. Please copy and paste the token given by Jupyter log that you see in the Docker container's terminal (token=…. - it will be a long chain of numbers and characters).

3. In order to produce the plots that validate the data, please open the `ReproducePlots.ipynb` Jupyter Notebook in the Jupyter Lab GUI. 

4. Once opened, run all of the cells.
   - If certain plots are desired, there are instructions to indicate what sections correspond to those plots. 
   - They will create plots of the data at refined or coarse levels.

#### Options for Reproducing Different Plots:
1. High and Low Frequencies for Each Day _**(8 Plots Total)**_
2. Combined High and Low Frequencies for Each Day _**(4 Plots Total)**_
3. Replica of Paper IV's Figure 1 _**(3 Plots Total)**_
   - _**Recommend running this section because this validates what is in the original paper!**_
   
   
  
### Notes:
* In order to view the images produced, which are formatted as `.eps`, you will need to download the images to your local machine in order to view them. Just right click on the files in the left navigation bar and click on "Download".
