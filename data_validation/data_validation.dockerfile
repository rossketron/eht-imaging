FROM continuumio/miniconda3

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y \
    sudo \
    wget \
    tar \
    curl \
    build-essential \
    git \
    vim \
    ssh 

# Create user and define working dir as eht $HOME
RUN useradd -m eht && \
    echo "eht:eht" | chpasswd && adduser eht sudo
WORKDIR /home/eht

# Copy eht dirs over from local
COPY --chown=eht Src_EHT .

# Create conda environment for EHT-Imaging
RUN conda env create -f data_validation/data_validation_environment.yml; exit 0 && \
    conda init 
    # conda init && \
    # echo 'conda activate data_validation' >> ~/.bashrc

RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/eht/.bashrc && \
    echo "conda activate data_validation" >> /home/eht/.bashrc

RUN echo "########################################################################" && \
    echo "#                              ALIASES                                 #" && \
    echo "########################################################################" && \
    echo "alias jLab='jupyter lab --ip 0.0.0.0 --no-browser'"

USER eht