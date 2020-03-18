#----------------------------------------------------------------#
# Dockerfile to build a container for binary reverse engineering #
#----------------------------------------------------------------#

FROM phusion/baseimage:0.11
MAINTAINER david.frazer336@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y upgrade

#-------------------------------------#
# Install packages from Ubuntu repos  #
#-------------------------------------#
RUN apt-get install -y \
    sudo \
    build-essential \
    gcc-multilib \
    g++-multilib \
    gdb \
    gdb-multiarch \
    python-dev \
    python3-dev \
    python-pip \
    python3-pip \
    ipython \
    default-jdk \
    net-tools \
    nasm \
    cmake \
    rubygems \
    vim \
    tmux \
    git \
    binwalk \
    strace \
    ltrace \
    autoconf \
    socat \
    netcat \
    nmap \
    wget \
    tcpdump \
    exiftool \
    squashfs-tools \
    unzip \
    virtualenvwrapper \
    upx-ucl \
    man-db \
    manpages-dev \
    libtool-bin \
    bison \
    libini-config-dev \
    libssl-dev \
    libffi-dev \
    libglib2.0-dev \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libc6-dev-i386

RUN apt-get -y autoremove
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



# install radare2
RUN git clone https://github.com/radare/radare2.git /opt/radare2 && \
    cd /opt/radare2 && \
    git fetch --tags && \
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && \
    ./sys/install.sh  && \
    make symstall

ENTRYPOINT ["/bin/bash"]
