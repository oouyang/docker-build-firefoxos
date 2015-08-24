FROM quay.io/alaska/baseimage
MAINTAINER Owen Ouyang <owen.ouyang@live.com>

ENV SHELL=/bin/bash \
    WORK_USER="docker" \
    WORK_HOME="/build" \
    GIT_EMAIL="rename@to.your.mail" \
    GIT_NAME="rename to your name" \
    LOG_DIR="/var/log/docker" \
    TERM=dumb \
    B2G_REPO="https://github.com/mozilla-b2g/B2G.git" \
    CCACHE_DIR="/build/ccache" \
    CCACHE_UMASK=002

RUN apt-get install -y software-properties-common
RUN add-apt-repository "deb http://archive.canonical.com/ trusty partner"
RUN add-apt-repository ppa:webupd8team/java
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
              autoconf2.13 \
              bison \
              ccache \
              distcc \
              flex \
              gawk \
              gcc \
              g++ \
              g++-multilib \
              gcc-4.6 \
              g++-4.6 \
              g++-4.6-multilib \
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
              dosfstools \
              libxrender1 \
              libasound2 \
              libatk1.0 \
              libice6 \
              wget \
              curl \
              python-setuptools \
              python-virtualenv \
              python-pip \
              android-tools-adb \
              android-tools-fastboot \
              python-dev \
              libusb-1.0-0 \
              libusb-1.0-0-dev \
              usbutils \
              unzip \
              openssh-server \
              supervisor \
              libfontconfig1:amd64 \
              libxcomposite-dev \
              libgtk2.0-0 \
              libxtst6:amd64 \
              libxtst6:i386 \
              libxt-dev

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 1
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 2
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 1
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.6 1
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 2
RUN update-alternatives --set gcc "/usr/bin/gcc-4.6"
RUN update-alternatives --set g++ "/usr/bin/g++-4.6"

# why install java failed?
#              oracle-java8-installer \
# https://gist.github.com/mugli/8720670
# Enable silent install
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
RUN apt-get install -y oracle-java8-installer
# Not always necessary, but just in case...
RUN update-java-alternatives -s java-8-oracle
# Setting Java environment variables
RUN apt-get install -y oracle-java8-set-default

# Clean up any files used by apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add usb device rules
ADD 51-android.rules /etc/udev/rules.d/51-android.rules

RUN git config --global user.email "${GIT_EMAIL}"
RUN git config --global user.name "${GIT_NAME}"

RUN mkdir -p /var/run/sshd /var/log/supervisor /etc/supervisor/conf.d/ 
RUN echo [program:sshd] > /etc/supervisor/conf.d/supervisord.conf
RUN echo command=/usr/sbin/sshd -D >> /etc/supervisor/conf.d/supervisord.conf

# add user
RUN groupadd -r ${WORK_USER} -g 1000 && useradd -r -u 1000 -s /bin/bash -m -g ${WORK_USER} ${WORK_USER}
RUN echo "${WORK_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# USER ${WORK_USER}
EXPOSE 22 5037

VOLUME ["${WORK_HOME}", "${LOG_DIR}"]
WORKDIR ${WORK_HOME}

# --privileged --expose 5037 -v /dev/bus/usb:/dev/bus/usb
RUN echo nameserver 8.8.8.8 >> /etc/resolv.conf
RUN ccache --max-size 10GB
CMD ["/sbin/my_init"]
