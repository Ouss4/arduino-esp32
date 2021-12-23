FROM ubuntu:20.04

RUN apt-get update -qq && DEBIAN_FRONTEND="noninteractive" apt-get install -y -qq --no-install-recommends \
  curl \
  xz-utils \
  flex \
  file \
  bison \
  gperf \
  libncurses5-dev \
  make \
  cmake \
  g++ \
  git \
  python3 \
  python-is-python3 \
  python3-pip \
  python3-setuptools \
  python3-pexpect \
  python3-venv \
  libffi-dev \
  libssl-dev \
  libusb-1.0 \
  build-essential \
  gcc \
  gcc-multilib \
  wget \
  lib32z1-dev \
  libc6-dev-i386 \
  gettext \
  libcurl4-openssl-dev \
  xxd \
  unzip \
  ccache \
  libglib2.0-dev \
  libfdt-dev \
  libpixman-1-dev \
  zlib1g-dev \
  libgcrypt-dev \
  ninja-build \
  expect \
  && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386

# Download the toolchains and add them to the PATH.
RUN mkdir xtensa-esp32-elf-gcc && \
  curl -s -L "https://github.com/espressif/crosstool-NG/releases/download/esp-2021r2/xtensa-esp32-elf-gcc8_4_0-esp-2021r2-linux-amd64.tar.gz" \
  | tar -C xtensa-esp32-elf-gcc --strip-components 1 -xz
ENV PATH="/xtensa-esp32-elf-gcc/bin:$PATH"

RUN mkdir riscv32-esp-elf-gcc && \
  curl -s -L "https://github.com/espressif/crosstool-NG/releases/download/esp-2021r2/riscv32-esp-elf-gcc8_4_0-esp-2021r2-macos.tar.gz" \
  | tar -C riscv32-esp-elf-gcc --strip-components 1 -xz
ENV PATH="/riscv32-esp-elf-gcc/bin:$PATH"

RUN mkdir xtensa-esp32s2-elf-gcc && \
  curl -s -L "https://github.com/espressif/crosstool-NG/releases/download/esp-2021r2/xtensa-esp32s2-elf-gcc8_4_0-esp-2021r2-linux-amd64.tar.gz" \
  | tar -C xtensa-esp32s2-elf-gcc --strip-components 1 -xz
ENV PATH="/xtensa-esp32s2-elf-gcc/bin:$PATH"

RUN mkdir xtensa-esp32s3-elf-gcc && \
  curl -s -L "https://github.com/espressif/crosstool-NG/releases/download/esp-2021r2/xtensa-esp32s3-elf-gcc8_4_0-esp-2021r2-linux-amd64.tar.gz" \
  | tar -C xtensa-esp32s3-elf-gcc --strip-components 1 -xz
ENV PATH="/xtensa-esp32s3-elf-gcc/bin:$PATH"

# Configure out base setup for adding python packages
ENV PIP_DISABLE_PIP_VERSION_CHECK=true
# This disables the cache with value 0. We do not want caching as it
# increases the images size.
ENV PIP_NO_CACHE_DIR=0
# We are using the minimal python installation from the system so include
# setuptools and also wheel so we can use the binary releases of packages
# instead of requiring them to be compiled.
RUN pip3 install setuptools wheel

RUN pip3 install esptool
RUN pip3 install pyserial

CMD [ "/bin/bash" ]
