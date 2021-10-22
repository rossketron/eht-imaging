FROM continuumio/miniconda3

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y \
    sudo \
    wget \
    tar \
    build-essential \
    git \
    vim \
    ssh \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-latex-recommended \
    cm-super

# Create user and define working dir as eht $HOME
RUN useradd -m eht && \
    echo "eht:eht" | chpasswd && adduser eht sudo
WORKDIR /home/eht

# Copy eht dirs over from local
COPY --chown=eht ../../Src_EHT .

# Create conda environment for EHT-Imaging
RUN conda env create -f EHT-Imaging/eht-imaging_environment.yml; exit 0 && \
    conda init && \
    echo 'conda activate eht-imaging' >> ~/.bashrc

RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/eht/.bashrc && \
    echo "conda activate eht-imaging" >> /home/eht/.bashrc
USER eht
