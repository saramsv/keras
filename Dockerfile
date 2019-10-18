# docker-keras - Keras in Docker for reproducible deep learning

FROM tensorflow/tensorflow:1.14.0

MAINTAINER audrism  <audris@mockus.org>

# install debian packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    dbus \
    openssh-server \
    lsof sudo \
    libssl-dev \
    vim \
    git \
    wget curl lsb-release \
    tmux zip \
    # install essentials
    # requirements for numpy
    libopenblas-base \
    # requirements for keras
	libopenblas-dev \
	liblapack-dev \
	libtiff5-dev \
	zlib1g-dev \
	libsm6 libxext6 libfontconfig1 libxrender1 \
	r-recommended r-base-dev r-cran-car r-cran-rcolorbrewer r-cran-fastcluster \		
&& apt-get clean \
 && rm -rf /var/lib/apt/lists/*


RUN pip --no-cache-dir install opencv-python jupyter pymongo





RUN if [ ! -d /var/run/sshd ]; then mkdir /var/run/sshd; chmod 0755 /var/run/sshd; fi
COPY *.sh /bin/

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/$NB_USER
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && mkdir $HOME/.ssh && chown -R $NB_USER:users $HOME 
COPY *.py $HOME/ 
COPY id_rsa_gcloud.pub $HOME/.ssh/authorized_keys
RUN cd $HOME && wget https://github.com/fchollet/deep-learning-models/releases/download/v0.2/resnet50_weights_tf_dim_ordering_tf_kernels_notop.h5
RUN chown -R $NB_USER:users $HOME && chmod -R og-rwx $HOME/.ssh
