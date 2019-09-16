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
#--- 
# This script installs ubuntu extra packages required for RISC-V tools 
# which may be used to study, configure as-referred, modify, implement or 
# release hardware based on the RISC-V Instruction Set Architecture.
# The VM is preconfigured for RISC-V HW development.
#    * RISC-V SW tool chain using the Eclipse-IDE
#    * RISC-V Imperas OVPSim model
#    * RISC-V Verilator model
#------------------------------------------------------------------------------

#--- 
# Exit if not in a script, if not sudo/root or if runtime errors
#--- 
function die() {
  echo "$@: " 1>&2
  exit 1
}
# ref: https://askubuntu.com/a/30157/8698
if ! [ $(id -u) = 0 ]; then
   echo "The Ubuntu post-installation script needs to be run as root." >&2
   exit 1
fi
# Show commands being used and error out on unexpected situations
set -eux 

export USERNAME=$(logname)
#--- 
# libudev package not available
echo "Updating Ubuntu"; echo""

apt-get install -y openssh-server xauth git-core lsb-core xorg vim-gtk3 dos2unix autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libusb-1.0-0-dev libudev1 libudev-dev g++ openjdk-8-jdk libfl2 libfl-dev links2 cmake ninja-build ccache dfu-util device-tree-compiler python3-pip python3-setuptools python3-tk python3-wheel xz-utils gcc-multilib 

apt-get upgrade
apt-get clean
apt-get autoremove --purge
export BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${BINDIR}

#--- 
# Install PULP-Platform GNU toolchain
#--- 
sudo -u ${USERNAME} pulp_install.sh

#---
# Install Verilator tool
#---
verilator_install.sh

#---
# Install Elipse-IDE and MCU plugins
#---
sudo -u ${USERNAME} eclipse-mcu_install.sh

#---
# Install NXP VEGA board SDK
#---
sudo -u ${USERNAME} rv32m1_install.sh

#---
# Install SEGGER J-Link drivers
#---
if [ -d /opt/SEGGER ]; then
   echo "SEGGER SW already installled"
else
  read -n 1 -s -r -p "Press any key to go to text-based web browser to download JLink SW and documentation"
  lynx https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.deb
  apt-get install -f ./JLink_Linux_V650a_x86_64.deb
fi

#---
# Setun zephyr environment
#---
sudo -u ${USERNAME} pip3 install --user cmake
sudo -u ${USERNAME} pip3 install --user -U west
~/.local/bin/west init zephyrproject
(cd zephyrproject && ~/.local/bin/west update)
(cd zephyrproject && pip3 install --user -r zephyr/scripts/requirements.txt)
(cd zephyrproject && git clone https://github.com/micropython/micropython.git)

#---
# append to ~/.bashrc
#---
if [ -f  /home/${USERNAME}/LICENSE ] 
then
  cp ../LICENSE /home/${USERNAME}/Apache_license_v2.0.txt
fi

cat > /home/${USERNAME}/.BTADS_welcom.txt <<EOF
#-----------------------------------------------------------------------------
# Copyright (c) 2019 BTA Design Services Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#------------------------------------------------------------------------------
# Author:   Alfredo Herrera (aherrera@btadesignservices.com) 
# Created:  10/Sep/2019 
# Revision: _beta_
#------------------------------------------------------------------------------
EOF

cat >> /home/${USERNAME}/.bashrc <<EOF

#------------------------------------------------------------------------------
# Additional settings
#------------------------------------------------------------------------------
if [ -f  /home/${USERNAME}/.editor ] 
then
    EDITOR=`cat /home/${USERNAME}/.editor`
fi
export LD_LIBRARY_PATH=/usr/local/lib

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin:/home/user/eclipse:/home/user/riscv-ovpsim/bin:/home/user/.local/bin
export RISCV32GCC_DIR="/home/user/pulp"
#export PULP_RISCV_GCC_TOOLCHAIN="/home/user/pulp"

cat /home/${USERNAME}/.BTADS_welcome.txt
EOF

echo "The installation is done"
echo "Note1: use 'evince' to open PDF documents from the command-line prompt"
echo "Note2: you may use 'link2 -g <<http:...>>' for web browsing" 

