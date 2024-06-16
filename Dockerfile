# Use a base image with essential tools
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
    build-essential \
    nasm \
    bison \
    vim \
    tree \
    flex \
    libgmp3-dev \
    libmpc-dev \
    libmpfr-dev \
    texinfo \
    wget \
    xz-utils \
    zlib1g-dev \
    xorriso 

# Define versions
ENV BINUTILS_VERSION=2.40
ENV GCC_VERSION=12.2.0

# Set up directory structure
RUN mkdir -p /src /opt/cross

# Download and build Binutils
RUN cd /src && \
    wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.xz && \
    tar -xf binutils-$BINUTILS_VERSION.tar.xz && \
    mkdir -p build-binutils && \
    cd build-binutils && \
    ../binutils-$BINUTILS_VERSION/configure --target=i686-elf --prefix=/opt/cross --with-sysroot --disable-nls --disable-werror && \
    make -j$(nproc) && \
    make install

# Download and build GCC
RUN cd /src && \
    wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz && \
    tar -xf gcc-$GCC_VERSION.tar.xz && \
    mkdir -p build-gcc && \
    cd build-gcc && \
    ../gcc-$GCC_VERSION/configure --target=i686-elf --prefix=/opt/cross --disable-nls --enable-languages=c,c++ --without-headers && \
    make -j$(nproc) all-gcc && \
    make -j$(nproc) all-target-libgcc && \
    make install-gcc && \
    make install-target-libgcc

# Add cross compiler to path
ENV PATH="/opt/cross/bin:$PATH"

# Clean up
RUN rm -rf /src/*

# Set up working directory
WORKDIR /workspace

# Define entrypoint
ENTRYPOINT ["/bin/bash"]

