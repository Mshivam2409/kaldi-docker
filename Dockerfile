FROM ubuntu:latest
LABEL maintainer="mshivam@iitk.ac.in"

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    g++ \
    make \
    automake \
    autoconf \
    bzip2 \
    unzip \
    wget \
    sox \
    libtool \
    git \
    subversion \
    python2.7 \
    python3 \
    zlib1g-dev \
    ca-certificates \
    gfortran \
    patch \
    ffmpeg \
    vim && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN git clone --depth 1 https://github.com/Mshivam2409/kaldi.git /opt/kaldi #EOL
RUN    cd /opt/kaldi/tools && \
    ./extras/install_mkl.sh 
RUN cd /opt/kaldi/tools && make
RUN   cd /opt/kaldi/src && \
    ./configure --shared && \
    make depend -j $(nproc) && \
    make -j $(nproc) && \
    find /opt/kaldi -type f \( -name "*.o" -o -name "*.la" -o -name "*.a" \) -exec rm {} \; && \
    find /opt/intel -type f -name "*.a" -exec rm {} \; && \
    find /opt/intel -type f -regex '.*\(_mc.?\|_mic\|_thread\|_ilp64\)\.so' -exec rm {} \; && \
    rm -rf /opt/kaldi/.git
WORKDIR /opt/kaldi/