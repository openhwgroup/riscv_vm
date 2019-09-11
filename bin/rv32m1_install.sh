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

cd /home/user
# Extract toolchain, takes two steps as there are archives in Toolchain_Linux.tar.gz)
mkdir toolchain

# Set the toolchain defaults for GNU MCU plug-ins to what we just "installed"
mkdir -p /home/user/eclipse/configuration/.settings/
# openocd location
echo "eclipse.preferences.version=1" > /home/user/eclipse/configuration/.settings/ilg.gnumcueclipse.debug.gdbjtag.openocd.prefs 
echo "install.folder=/home/user/toolchain" >> /home/user/eclipse/configuration/.settings/ilg.gnumcueclipse.debug.gdbjtag.openocd.prefs 

# gcc & friends location
echo "eclipse.preferences.version=1" > /home/user/eclipse/configuration/.settings/ilg.gnumcueclipse.managedbuild.cross.riscv.prefs 
# (magic number comes from https://github.com/gnu-mcu-eclipse/eclipse-plugins/blob/ce601cf2ec20cba90d9f2c2fbdb236b5fd7a6385/bundles/ilg.gnumcueclipse.managedbuild.cross.riscv/src/ilg/gnumcueclipse/managedbuild/cross/riscv/ToolchainDefinition.java#L30)
# Modified for pre-release version
echo "toolchain.path.512258282=/home/user/pulp/riscv32-unknown-elf/bin" >> /home/user/eclipse/configuration/.settings/ilg.gnumcueclipse.managedbuild.cross.riscv.prefs

