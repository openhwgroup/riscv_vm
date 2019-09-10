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
set -eux 

#---
# Install rv32m1 SDK tools
echo "Installing rv32m1 tools"; echo""
cd /home/user
curl -L https://github.com/open-isa-org/open-isa.org/releases/download/1.0.0/rv32m1_sdk_riscv_installer.sh > rv32m1_sdk_riscv_installer.sh
# Convert SDK shell script into the tar file -- this implictly accepts the license and extracts to /home/user/vega
ARCHIVE=$(awk '/^__ARCHIVE__/ {print NR + 1; exit 0; }' "rv32m1_sdk_riscv_installer.sh")
tail -n+${ARCHIVE} "rv32m1_sdk_riscv_installer.sh" | tar -xz > /dev/null 2>&1 || true
mkdir /home/user/vega
(cd /home/user/vega && tar xf /home/user/rv32m1_sdk_riscv.tar.gz)

cd /home/user
curl -L https://github.com/open-isa-org/open-isa.org/releases/download/1.0.0/Toolchain_Linux.tar.gz > Toolchain_Linux.tar.gz
# Extract toolchain, takes two steps as there are archives in Toolchain_Linux.tar.gz)
mkdir toolchain
pushd toolchain
tar xf /home/user/Toolchain_Linux.tar.gz # this makes tar files for next lines
tar xf riscv32-unknown-elf-gcc.tar.gz
tar xf openocd.tar.gz
popd

# Set the toolchain defaults for GNU MCU plug-ins to what we just "installed"
mkdir -p /home/user/eclipse/configuration/.settings/
# openocd location
echo "eclipse.preferences.version=1" > /home/user/eclipse/configuration/.settings/ilg.gnumcueclipse.debug.gdbjtag.openocd.prefs 
echo "install.folder=/home/user/toolchain" >> /home/user/eclipse/configuration/.settings/ilg.gnumcueclipse.debug.gdbjtag.openocd.prefs 
# gcc & friends location
echo "eclipse.preferences.version=1" > /home/user/eclipse/configuration/.settings/ilg.gnumcueclipse.managedbuild.cross.riscv.prefs 
# (magic number comes from https://github.com/gnu-mcu-eclipse/eclipse-plugins/blob/ce601cf2ec20cba90d9f2c2fbdb236b5fd7a6385/bundles/ilg.gnumcueclipse.managedbuild.cross.riscv/src/ilg/gnumcueclipse/managedbuild/cross/riscv/ToolchainDefinition.java#L30)
#echo "toolchain.path.512258282=/home/user/toolchain/riscv32-unknown-elf-gcc/bin" >> /home/user/eclipse/configuration/.settings/ilg.gnumcueclipse.managedbuild.cross.riscv.prefs
# Modified for pre-release version
echo "toolchain.path.512258282=/home/user/pulp/riscv32-unknown-elf/bin" >> /home/user/eclipse/configuration/.settings/ilg.gnumcueclipse.managedbuild.cross.riscv.prefs

rm rv32m1_sdk_riscv.tar.gz rv32m1_sdk_riscv_installer.sh Toolchain_Linux.tar.gz toolchain/riscv32-unknown-elf-gcc.tar.gz toolchain/openocd.tar.gz

