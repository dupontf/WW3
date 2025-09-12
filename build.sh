#!/usr/bin/env bash

set -e

# Require:
#  1. an oasis build

ROOT_DIR=$(pwd)

# Download ww3 from git

#if [ ! -d ./ww3 ]; then
#  git clone https://github.com/NOAA-EMC/WW3.git ww3  
#  # Download, expand large binary files as per instructions
#  cd ww3
#  sh model/bin/ww3_from_ftp.sh
#  cd ..
#  # Copy the pre-processer swtiches file into position
#  # This is independent of compiler/options
#  cp arch/ww3/switch_archer2 ww3/model/bin
#  cd ww3
#fi

#source ./build-env.sh

ww3_ssm="/fs/ssm/eccc/mrd/rpn/code-tools/ENV/cdt-1.6.7/SCIENCE/inteloneapi-2021.4.0 \
         /fs/ssm/eccc/mrd/rpn/code-tools/20250811/env/inteloneapi-2021.4.0 \
         /fs/ssm/main/opt/hdf5-netcdf4/parallel/intelmpi-2021.3.0/static/inteloneapi-2021.3.0/01 \
         rpn/libs/20230531"
. r.load.dot $ww3_ssm; 

set -x 

export METIS_PATH=/home/bpo001/models/WW3/local
export NETCDF_CONFIG=`which nc-config`
export NetCDF_ROOT=$(dirname $(dirname $NETCDF_CONFIG)) 
export CC=mpiicc
export FC=mpiifort
export OASISDIR=/home/fdu000/data/ppp5/nemo_builds/oasis/INSTALL_OASIS.ppp6_intel.2021.4
#export OASISDIR=/home/fdu000/oasis/oasis3-mct
export OASIS_INPUT_PATH=/home/fdu000/oasis/oasis3-mct
#export oasis_inc=/home/fdu000/data/ppp5/nemo_builds/oasis/INSTALL_OASIS.ppp6_intel.2021.4/include
export oasis_inc=/home/fdu000/oasis/oasis3-mct/util/make_dir/make.inc

#module list
arch_id=u2

# cmake requires oasis location to come from environment


mkdir -p build_${arch_id}
cd build_${arch_id}

cmake $ROOT_DIR -DSWITCH=OASIOCM -DCMAKE_VERBOSE_MAKEFILE=1
make -j 4
#      -DCMAKE_Fortran_FLAGS="-g -fdefault-real-8 -fdefault-double-8 -O1" \
#      -DCMAKE_BUILD_TYPE=Debug ..

# Executables are in ...

ls -l bin/ww3_shel
