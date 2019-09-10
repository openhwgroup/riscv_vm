#!/bin/bash
#------------------------------------------------------------------------------
# Copyright (c) 2019 BTA Design Services Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#------------------------------------------------------------------------------
# Authors: Alfredo Herrera  (aherrera@btadesignservices.com) 
#          KichwaCoders     (info@kichwacoders.com)
#--- 
# This script can be used to install a subset of RISC-V tools to study, 
# configure as-referred, modify, implement or release hardware based on the 
# RISC-V Instruction Set Architecture. The VM is preconfigured for RISC-V HW
# development.
#    * RISC-V SW tool chain using the Eclipse-IDE
#    * RISC-V Imperas OVPSim model
#    * RISC-V Verilator model
#
#--- 
# Exit if not in a script, if not sudo/root or if runtime errors
#--- 
function die() {
  echo "$@: " 1>&2
  exit 1
}
# ref: https://askubuntu.com/a/30157/8698
if ! [ $(id -u) = 0 ]; then
   echo "The RISC-V VM installtion script needs to be run as root." >&2
   exit 1
fi
# Show commands being used and error out on unexpected situations
set -eux 

#--- 
# Update UBUNTU OS prior to installing tools
#--- 
echo "Updating Ubuntu"; echo""

apt-get install openssh-server xauth git-core lsb-core xorg vim-gtk3 dos2unix
# libudev package not available
apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libusb-1.0-0-dev libudev1 libudev-dev g++ openjdk-8-jdk

apt-get upgrade
apt-get clean
apt-get autoremove --purge

#--- 
# Install PULP-Platform GNU toolchain
#--- 
echo "Installing PULP GNU toolchain"; echo""
cd /home/user
sudo -u user git clone -recursive https://github.com/pulp-platform/pulp-riscv-gnu-toolchain
cd pulp-riscv-gnu-toolchain
sudo -u user ./configure --prefix=/opt/pulp --with-arch=rv32imc --with-cmodel=medlow --enable-multilib
sudo -u user make
cd ..
rm -rf pulp-riscv-gnu-toolchain

#--- 
echo "Installing Verilator tool"; echo""
cd /home/user
apt-get install libfl2 libfl-dev

git clone http://git.veripool.org/git/verilator
unset VERILATOR_ROOT
cd verilator
git pull
git checkout stable
autoconf
./configure
make
sudo make install
cd ..
rm -rf verilator

#--- 
echo "Installing rv32m1 tools"; echo""
curl -L https://github.com/open-isa-org/open-isa.org/releases/download/1.0.0/rv32m1_sdk_riscv_installer.sh > rv32m1_sdk_riscv_installer.sh
# Convert SDK shell script into the tar file -- this implictly accepts the license and extract to ./vega
ARCHIVE=$(awk '/^__ARCHIVE__/ {print NR + 1; exit 0; }' "rv32m1_sdk_riscv_installer.sh")
tail -n+${ARCHIVE} "rv32m1_sdk_riscv_installer.sh" | tar -xz > /dev/null 2>&1 || true
mkdir vega
(cd vega && tar xf ../rv32m1_sdk_riscv.tar.gz)

curl -L https://github.com/open-isa-org/open-isa.org/releases/download/1.0.0/Toolchain_Linux.tar.gz > Toolchain_Linux.tar.gz
# Extract toolchain, takes two steps as there are archives in Toolchain_Linux.tar.gz)
mkdir toolchain
pushd toolchain
tar xf ../Toolchain_Linux.tar.gz # this makes tar files for next lines
tar xf riscv32-unknown-elf-gcc.tar.gz
rm riscv32-unknown-elf-gcc.tar.gz
tar xf openocd.tar.gz
rm openocd.tar.gz
popd

#--- 
echo "Installing Eclipse-IDE and MCU plugins"; echo""
curl -L https://github.com/gnu-mcu-eclipse/org.eclipse.epp.packages/releases/download/v4.5.1-20190101-2018-12/20190101-2023-gnumcueclipse-4.5.1-2018-12-R-linux.gtk.x86_64.tar.gz > 20190101-2023-gnumcueclipse-4.5.1-2018-12-R-linux.gtk.x86_64.tar.gz
curl -L https://github.com/riscv/riscv-ovpsim/archive/master.zip > riscv-ovpsim-master.zip
# Extract eclipse that includes GNU MCU plugins, eclipse executable will be ./eclipse/eclipse
tar xf 20190101-2023-gnumcueclipse-4.5.1-2018-12-R-linux.gtk.x86_64.tar.gz

# Set the toolchain defaults for GNU MCU plug-ins to what we just "installed"
mkdir -p eclipse/configuration/.settings/
# openocd location
echo "eclipse.preferences.version=1" > eclipse/configuration/.settings/ilg.gnumcueclipse.debug.gdbjtag.openocd.prefs 
echo "install.folder=$PWD/toolchain" >> eclipse/configuration/.settings/ilg.gnumcueclipse.debug.gdbjtag.openocd.prefs 
# gcc & friends location
echo "eclipse.preferences.version=1" > eclipse/configuration/.settings/ilg.gnumcueclipse.managedbuild.cross.riscv.prefs 
# (magic number comes from https://github.com/gnu-mcu-eclipse/eclipse-plugins/blob/ce601cf2ec20cba90d9f2c2fbdb236b5fd7a6385/bundles/ilg.gnumcueclipse.managedbuild.cross.riscv/src/ilg/gnumcueclipse/managedbuild/cross/riscv/ToolchainDefinition.java#L30)
echo "toolchain.path.512258282=$PWD/toolchain/riscv32-unknown-elf-gcc/bin" >> eclipse/configuration/.settings/ilg.gnumcueclipse.managedbuild.cross.riscv.prefs

# Setup RISC-V OVP Simulator
unzip riscv-ovpsim-master.zip
mv riscv-ovpsim-master riscv-ovpsim

# Optional, comment to preserve downloads
cd ~
rm rv32m1_sdk_riscv.tar.gz 20190101-2023-gnumcueclipse-4.5.1-2018-12-R-linux.gtk.x86_64.tar.gz rv32m1_sdk_riscv_installer.sh Toolchain_Linux.tar.gz riscv-ovpsim-master.zip

