FROM debian:9
LABEL org.opencontainers.image.authors="Hui-Hong YOU <hiroshi@miyabi-hiroshi.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://archive.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security/ stretch/updates main contrib non-free" >> /etc/apt/sources.list

RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y \
    build-essential \
    gcc-aarch64-linux-gnu \
    libncurses5-dev \
    libssl-dev \
    bc \
    bison \
    flex \
    python2.7 \
    python-minimal \
    git \
    xz-utils \
    libelf-dev \
    kmod && \
    apt-get clean && \
    ln -sf /usr/bin/python2.7 /usr/bin/python

ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-

WORKDIR /build

CMD ["/bin/bash"]
