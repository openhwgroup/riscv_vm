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
# This script installs the necesary files to run riscv_vm on a MacOS host.
# This script must me run from a terminal window with admin priviledges
#------------------------------------------------------------------------------
echo "============================"
echo " INSTALL HOMEBREW"
echo "============================"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "============================"
echo "INSTALL TOOLS"
echo "============================"
brew install telnet git wget
wget https://download.virtualbox.org/virtualbox/6.0.10/VirtualBox-6.0.10-132072-OSX.dmg
wget https://download.virtualbox.org/virtualbox/6.0.10/Oracle_VM_VirtualBox_Extension_Pack-6.0.10.vbox-extpack
brew install caskroom/cask/brew-cask 2> /dev/null
brew cask install xquartz

echo "install VirtualBox from the following path:"
pwd
echo "and add the extensions pack from teh GUI"

