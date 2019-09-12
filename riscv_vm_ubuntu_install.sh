#! /bin/bash
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
# Author: Alfredo Herrera  (aherrera@btadesignservices.com) 
#--- 
# This script installs the necesary files to run riscv_vm on a Linux host.
# This script must me run from a terminal window with admin priviledges
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

echo "============================"
echo "INSTALL TOOLS"
echo "============================"
apt-get install -y telnet git wget
export USERNAME=$(logname)
#--- 
# Installing VirtualBox 
#--- 
wget https://download.virtualbox.org/virtualbox/6.0.10/VirtualBox-6.0.10-132072-Linux_amd64.run
VirtualBox-6.0.10-132072-Linux_amd64.run install
usermod -a -G vboxusers $USERNAME

echo "Follow the instructions on the screen to accept the terms of the license and install the VirtualBox Extension pack:"
wget https://download.virtualbox.org/virtualbox/6.0.10/Oracle_VM_VirtualBox_Extension_Pack-6.0.10.vbox-extpack
VBoxManage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-6.0.10.vbox-extpack
VBoxManage extpack cleanup


