ubuntu_codename ?= $(shell lsb_release -sc)
libint2_version ?= 2.7.0-beta.6
clang_version ?= 9
intel_mkl_version ?= 2020.4-912
cuda_version ?= 11.1

export DEBIAN_FRONTEND=noninteractive

ubuntu_release = $(shell lsb_release -sr)

cuda_repo = https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(subst .,,${ubuntu_release})/x86_64
cuda_tag := $(subst .,-,${cuda_version})
cuda_packages := cuda-compiler-${cuda_tag} cuda-nvtx-${cuda_tag} cuda-cupti-dev-${cuda_tag} libcublas-dev-${cuda_tag}

install/main:
	apt-get update
	apt-get -yq install \
          lsb-release coreutils sudo bash-completion \
          apt-transport-https software-properties-common ca-certificates gnupg \
          build-essential wget curl \
          git make ninja-build \
          gcc g++ gfortran gdb valgrind \
          libboost-all-dev libeigen3-dev \
          libblas-dev liblapack-dev liblapacke-dev \
          libunwind-dev libtbb-dev libomp-dev \
          libopenmpi-dev openmpi-bin libscalapack-openmpi-dev \
          python3 python3-pip python3-numpy python3-dev python3-pytest \
          vim emacs-nox

install/g++-%:
	apt-get -yq install gcc-$* g++-$* gfortran-$*

# CMake
install/cmake:
	wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add -
	apt-add-repository "deb https://apt.kitware.com/ubuntu/ ${ubuntu_codename} main"
	apt-get -yq update
	apt-get -yq --force-yes install cmake


# LLVM
install/clang-%:
	wget https://apt.llvm.org/llvm-snapshot.gpg.key -O - | apt-key add -
	add-apt-repository "deb http://apt.llvm.org/${ubuntu_codename}/ llvm-toolchain-${ubuntu_codename}-$* main"
	apt-get -yq update
	apt-get -yq --force-yes install clang-$*

install/clang: install/clang-${clang_version}


# Intel
apt-add-repository/intel-mkl:
	wget -O - https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB | apt-key add -
	apt-add-repository "deb https://apt.repos.intel.com/mkl all main"
	apt-get -yq update

download/intel-mkl:
	apt-get install -yq --download-only intel-mkl-${intel_mkl_version}

install/intel-mkl:
	apt-get -yq install intel-mkl-${intel_mkl_version}
	rm -rf /opt/intel/mkl
	ln -s /opt/intel/compilers_and_libraries_${intel_mkl_version}/linux/mkl /opt/intel/mkl

# CUDA
apt-add-repository/cuda:
	wget ${cuda_repo}/cuda-ubuntu$(subst .,,${ubuntu_release}).pin -O /etc/apt/preferences.d/cuda-repository-pin-600
	apt-key adv --fetch-keys ${cuda_repo}/7fa2af80.pub
	add-apt-repository "deb ${cuda_repo} /"
	apt-get update

download/cuda:
	apt-get install -yq --download-only ${cuda_packages}

install/cuda: download/cuda
	apt-get install -yq ${cuda_packages}
	rm -fr /usr/local/cuda
	ln -s /usr/local/cuda-$(subst -,.,${cuda_tag}) /usr/local/cuda

# Libint2
libint2:
	wget --no-verbose https://github.com/evaleev/libint/releases/download/v${libint2_version}/libint-${libint2_version}.tgz
	tar xzf libint-${libint2_version}.tgz
	mkdir libint2
	cd libint2 && cmake ../libint-${libint2_version} -DCMAKE_POSITION_INDEPENDENT_CODE=ON
	cd libint2 && make -j16

.PHONY: install/libint2
install/libint2: libint2
	make -C libint2 install
