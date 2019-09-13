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
# This script installs the verilator tool
#------------------------------------------------------------------------------

#--- 
# Exit if not in a script, if sudo/root or if runtime errors
#--- 
function die() {
  echo "$@: " 1>&2
  exit 1
}
# ref: https://askubuntu.com/a/30157/8698
if ! [ $(id -u) = 0 ]; then
   echo "The Verilator tool installtion script must be run as root." >&2
   exit 1
fi
# Show commands being used and error out on unexpected situations
set -eux 

echo "Installing Verilator tool"; echo""
cd /home/$USERNAME
git clone http://git.veripool.org/git/verilator

pushd verilator
git pull
git checkout stable
autoconf
./configure 
make
make install
popd

rm -rf /home/$USERNAME/verilator

