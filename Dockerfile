FROM quay.io/oouyang/docker-adb
MAINTAINER Owen Ouyang <owen.ouyang@live.com>

ENV SHELL=/bin/bash

RUN apt-get install -y software-properties-common
RUN add-apt-repository "deb http://archive.canonical.com/ trusty partner"
RUN add-opt-repository ppa:webupd8team/java
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install --no-install-recommends \
              autoconf2.13 \
              bison \
              bzip2 \
              ccache \
              curl \
              flex \
              gawk \
              gcc \
              g++ \
              g++-multilib \
              gcc-4.6 \
              g++-4.6 \
              g++-4.6-mutilib \
              git \
              lib32ncurses5-dev \
              lib32z1-dev \
              zlib1g:amd64 \
              zlib1g-dev:amd64 \
              zlib1g:i386 \
              zlib1g-dev:i386 \
              libgl1-mesa-dev \
              libx11-dev \
              make \
              zip \
              libxml2-utils \
              python \
              oracle-java6-installer \
              dosfstools \
              libxrender1 \
              libasound2 \
              libatk1.0 \
              libice6 

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 1
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 2
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 1
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.6 1
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 2
RUN update-alternatives --set gcc "/usr/bin/gcc-4.6"
RUN update-alternatives --set g++ "/usr/bin/g++-4.6"

RUN apt-get update


# Clean up any files used by apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
