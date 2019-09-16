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
# This script installs the RISC-V GNU tools for the VEGA board 
#------------------------------------------------------------------------------

#--- 
# Exit if not in a script, if sudo/root or if runtime errors
#--- 
function die() {
  echo "$@: " 1>&2
  exit 1
}
# ref: https://askubuntu.com/a/30157/8698
if [ $(id -u) = 0 ]; then
   echo "The rv32m1 SDK toolchain installation script shall not be run as root." >&2
   exit 1
fi
# Show commands being used and error out on unexpected situations
set -e #ux 

if [ -z "$USERNAME" ]; then
  echo "setting \$USERNAME variable"
  export USERNAME=$(logname)
else
  echo "Variable already set"	
fi

if [ -z "$BINDIR" ]; then
  echo "setting \$BINDIR variable"
  export BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
  echo "Variable already set"	
fi

if [ -f ${BINDIR}/rv32m1_sdk_riscv_installer.sh ]; then
   echo "rv32m1_sdk_riscv_installer.sh already downloaded"
else
   wget https://github.com/open-isa-org/open-isa.org/releases/download/1.0.0/rv32m1_sdk_riscv_installer.sh -O ${BINDIR}/rv32m1_sdk_riscv_installer.sh
   chmod 755 ${BINDIR}/rv32m1_sdk_riscv_installer.sh
fi

if [ -f ${BINDIR}/Toolchain_Linux.tar.gz ]; then
   echo "Toolchain_Linux.tar.gz already downloaded"
else
   wget https://github.com/open-isa-org/open-isa.org/releases/download/1.0.0/Toolchain_Linux.tar.gz -O ${BINDIR}/Toolchain_Linux.tar.gz
fi

cd /home/${USERNAME}
mkdir -p vega
mkdir -p toolchain

#---
# Install rv32m1 SDK tools
#---
if [ ! -d "/home/$USERNAME/vega/rv32m1_sdk_riscv" ]; then
  echo "Installing rv32m1 tools"; echo""
  cd /home/${USERNAME}/vega
  (${BINDIR}/rv32m1_sdk_riscv_installer.sh && tar xf ./rv32m1_sdk_riscv.tar.gz)
fi

#---
# Extract toolchain, takes two steps as there are archives in Toolchain_Linux.tar.gz)
#---
if [ ! -d "/home/$USERNAME/toolchain/riscv32-unknown-elf-gcc" ]; then
  echo "Installing GNU MCU toolchain"
  cd /home/${USERNAME}/toolchain
  tar xf ${BINDIR}/Toolchain_Linux.tar.gz # this makes tar files for next lines
  tar xf riscv32-unknown-elf-gcc.tar.gz
  tar xf openocd.tar.gz
fi
cd

#---
# Set the toolchain defaults for GNU MCU plug-ins
#---
mkdir -p /home/${USERNAME}/eclipse/configuration/.settings/
echo "eclipse.preferences.version=1" > /home/${USERNAME}/eclipse/configuration/.settings/ilg.gnumcueclipse.debug.gdbjtag.openocd.prefs 
echo "install.folder=/home/${USERNAME}/toolchain" >> /home/${USERNAME}/eclipse/configuration/.settings/ilg.gnumcueclipse.debug.gdbjtag.openocd.prefs 
#
#---
# Set the toolchain defaults for g++
#---
echo "eclipse.preferences.version=1" > /home/${USERNAME}/eclipse/configuration/.settings/ilg.gnumcueclipse.managedbuild.cross.riscv.prefs 
# (magic number comes from https://github.com/gnu-mcu-eclipse/eclipse-plugins/blob/ce601cf2ec20cba90d9f2c2fbdb236b5fd7a6385/bundles/ilg.gnumcueclipse.managedbuild.cross.riscv/src/ilg/gnumcueclipse/managedbuild/cross/riscv/ToolchainDefinition.java#L30)
echo "toolchain.path.512258282=/home/${USERNAME}/toolchain/riscv32-unknown-elf-gcc/bin" >> /home/${USERNAME}/eclipse/configuration/.settings/ilg.gnumcueclipse.managedbuild.cross.riscv.prefs

if [ -f "/home/$USERNAME/vega/rv32m1_sdk_riscv.tar.gz" ]; then
  rm /home/${USERNAME}/vega/rv32m1_sdk_riscv.tar.gz
fi
if [ -f "/home/$USERNAME/toolchain/riscv32-unknown-elf-gcc.tar.gz" ]; then
  rm /home/${USERNAME}/toolchain/riscv32-unknown-elf-gcc.tar.gz 
fi
if [ -f "/home/$USERNAME/toolchain/openocd.tar.gz" ]; then
  rm /home/${USERNAME}/toolchain/openocd.tar.gz
fi
