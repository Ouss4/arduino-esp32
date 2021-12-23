FROM balenalib/rpi-raspbian:stretch

RUN apt-get update -qq && DEBIAN_FRONTEND="noninteractive" apt-get install -y -qq --no-install-recommends \
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
  python3-pip \
  python3-setuptools \
  python3-pexpect \
  libffi-dev \
  libssl-dev \
  libusb-1.0 \
  build-essential \
  gcc \
  wget \
  gettext \
  libcurl4-openssl-dev \
  xxd \
  unzip \
  ccache \
  openssh-server \
  libglib2.0-dev \
  libfdt-dev \
  libpixman-1-dev \
  zlib1g-dev \
  libgcrypt-dev \
  ninja-build \
  expect \
  && rm -rf /var/lib/apt/lists/*

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

# Install pytest-embedded and required services.

run pip3 install "pyserial>=3.0"
run pip3 install "cryptography<3.4"
run pip3 install "pexpect>=4.4"
run pip3 install "pytest>=6.2.0"
run pip3 install pytest-cov
run pip3 install pytest-embedded==0.5.0rc0
run pip3 install pytest-embedded-serial==0.5.0rc0
run pip3 install pytest-embedded-serial-esp==0.5.0rc0
run pip3 install pytest-embedded-arduino==0.5.0rc0

CMD [ "/bin/bash" ]
