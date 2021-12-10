# Data Validation

## Docker Instructions
1. Please run the following command from the external directory that contains the Src_EHT repository: `docker build --tag validate_data -f Src_EHT/data_validation/data_validation.dockerfile .` This will build the Docker container image.
   * Docker image is now on our DockerHub [here](https://hub.docker.com/r/globalcomputinglab/reproducibility-eht/tags). Pull the `data-validation` container using the command `docker pull globalcomputinglab/reproducibility-eht:data-validation`.

2. Once it has finished building the image, please run the following command: `docker run -it -p 9000:8888 validate_data`. This runs the container and forwards everything from port 8888 in the container to the local machine's port 9000. This will allow you to interact with the container locally.

3. Voila! The Docker container should be ready to go! But first, **_please validate the data integrity_** by moving on to the "Data Integrity Validation Instructions" section below.


## Data Integrity Validation Instructions

1. Please download the tar file that contains the data from [here](https://datacommons.cyverse.org/browse/iplant/home/shared/commons_repo/curated/EHTC_FirstM87Results_Apr2019/EHTC_FirstM87Results_Apr2019_csv.tgz) to your local machine.

2. Once downloaded, please check the md5sum of the data on your local machine by running the following command: 
   * For Linux users: `md5sum EHTC_FirstM87Results_Apr2019_csv.tgz`
   * For Mac users:  `md5 EHTC_FirstM87Results_Apr2019_csv.tgz`
   * For Windows users: `certutil -hashfile EHTC_FirstM87Results_Apr2019_csv.tgz MD5`

3. To find the checksum of the container image, please open a new terminal window/tab. Then, run the following command: `docker images --digests`. 

4. The md5sum of the data should be matching to this: `fe11e10a4f9562cb6a2846206d86860c`. The md5sum of the container should be matching to this: `______ (will be updated)`. 
   * If the checksums are matching, this means that the data in the repository and the container image have not been corrupted or modified. **_Everything should be ready to use!_**

   * If in the case that the md5sum has been changed for the data, please check that the command you used to download the data is correct and check that the data repository has not been updated. If the checksum of the container image is different, please follow the steps below: 
     * To remove the old container, first get the image id by running `docker images globalcomputinglab/reproducibility-eht:data-validation`. Then run `docker rmi <IMAGE ID>`.
     * Please re-pull this container image by doing the following command: `docker pull globalcomputinglab/reproducibility-eht:data-validation`.

5. Once the data integrity has been validated and all is well, please move on to the "Data Validation Jupyter Notebook Instructions" section below!


## Data Validation Jupyter Notebook Instructions
1. Once inside the container, please run `bash unpack_data.sh` from the root directory (`/home/eht`) in the container. It will untar all of the data required for the script to run and make the necessary directories.

1. To easily view all files and run the notebook in the Jupyter Lab GUI, please run `jLab`. It is an alias for the command `jupyter lab --ip 0.0.0.0 --no-browser`. This will allow you to use a Jupyter Lab GUI to easily navigate around the repository.

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
   
#### Notes:
* In order to view the images produced, which are formatted as `.eps`, you will need to download the images to your local machine in order to view them. Just right click on the files in the left navigation bar and click on "Download".


