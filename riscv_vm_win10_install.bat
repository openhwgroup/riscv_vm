::------------------------------------------------------------------------------
:: Copyright (c) 2019 BTA Design Services Inc.
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
:: 
::     http://www.apache.org/licenses/LICENSE-2.0
:: 
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.
::------------------------------------------------------------------------------
:: Author: Alfredo Herrera  (aherrera@btadesignservices.com) 
::--- 
:: This script installs the necesary files to run riscv_vm on a Windows host.
:: This script must me run from a windows cmd.exe windows in admin-mode
::------------------------------------------------------------------------------
ECHO ============================
ECHO ENABLE TELNET
ECHO ============================
dism /online /Enable-Feature /FeatureName:TelnetClient

ECHO ============================
ECHO CHOCOLATEY INSTALL MANAGER
ECHO ============================
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

ECHO ============================
ECHO INSTALL TOOLS  
ECHO ============================
choco install git vcxsrv wget
wget https://download.virtualbox.org/virtualbox/6.0.10/VirtualBox-6.0.10-132072-Win.exe
wget https://download.virtualbox.org/virtualbox/6.0.10/Oracle_VM_VirtualBox_Extension_Pack-6.0.10.vbox-extpack

ECHO "Installer download directory for Virtualbox is:"
dir


 
