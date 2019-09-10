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
# This script starts the VM, ssh'es into the VM and shutdowns the VM upon exit
#------------------------------------------------------------------------------

#--- 
# Exit if not in a script, if sudo/root or if runtime errors
#--- 
function die() {
  echo "$@: " 1>&2
  exit 1
}

/c/bta_cadtree/VirtualBox/vb6_0_10/VBoxManage startvm riscv_vm3 --type headless
echo "waiting 15 seconds for VM to start"
sleep 15

read -p "Press [Enter] key to continue"
ssh -Yv user@192.168.56.103

read -p "Press [Enter] key to continue"
/c/bta_cadtree/VirtualBox/vb6_0_10/VBoxManage list vms --long | grep -e "Name:" -e "State:"
echo "If VM is still running, type the follwoing to shutdown:"
echo "/c/bta_cadtree/VirtualBox/vb6_0_10/VBoxManage controlvm riscv_vm3 poweroff"

