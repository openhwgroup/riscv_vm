#!/bin/bash
#------------------------------------------------------------------------------
# Copyright (c) 2020 BTA Design Services Inc.
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
# This script installs the eclipse-ide, the MCU plugins and configures eclipse 
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
   echo "The Eclipse-IDE and MCU plugins installation script shall not be run as root." >&2
   exit 1
fi
# Show commands being used and error out on unexpected situations
set -eux 

echo "Installing Eclipse-IDE and MCU plugins"; echo""
cd /home/$USERNAME
curl -L https://github.com/gnu-mcu-eclipse/org.eclipse.epp.packages/releases/download/v4.7.2-20200127-2019-12/20200127-1311-gnumcueclipse-4.7.2-2019-12-R-linux.gtk.x86_64.tar.gz > latest-gnumcueclipse.tar.gz
curl -L https://github.com/riscv/riscv-ovpsim/archive/master.zip > riscv-ovpsim-master.zip
# Extract eclipse that includes GNU MCU plugins, eclipse executable will be ./eclipse/eclipse
cd /tools
tar xf latest-gnumcueclipse.tar.gz
# Setup RISC-V OVP Simulator
cd eclipse
unzip ../riscv-ovpsim-master.zip
mv riscv-ovpsim-master riscv-ovpsim
cd /home/$USERNAME
rm latest-gnumcueclipse.tar.gz riscv-ovpsim-master.zip

