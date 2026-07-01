FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -yq sudo build-essential git nano vim\
          python3-yaml libncursesw5 \
          python3 man bash diffstat gawk chrpath wget cpio \
          texinfo lzop apt-utils bc screen libncurses5-dev locales \
          libc6-dev doxygen libssl-dev dos2unix xvfb x11-utils \
          g++-multilib libssl-dev zlib1g-dev \
          libtool libtool-bin procps python3-distutils pigz socat \
          zstd iproute2 lz4 iputils-ping \
          curl libtinfo5 net-tools xterm rsync u-boot-tools unzip zip lsb-release dnsutils

RUN rm -rf /var/lib/apt-lists/*
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN dpkg-reconfigure dash

RUN groupadd wouter -g 1000
RUN useradd -ms /bin/bash -p wouter wouter -u 1000 -g 1000 && \
        usermod -aG sudo wouter && \
        echo "wouter:wouter" | chpasswd


RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV LANG en_US.utf8

WORKDIR /home/wouter/work
RUN chown -R wouter:wouter /home/wouter/work

USER wouter

RUN echo "source /opt/xilinx/2025.2/Petalinux/settings.sh" >> ~/.bashrc

RUN git config --global user.email "wouter@eldarmail.nl" && git config --global user.name "Wouter Schoenmakers"

