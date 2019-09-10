# riscv_vm
The OpenHW Group's RISC-V Virtual Machine (riscv_vm) is intended for anyone wanting to study, configure as-preferred, modify, implement or release hardware based the RISC-V Instruction Set Architecture. The VM is preconfigured for RISC-V HW development.
   * RISC-V SW tool chain using the Eclipse-IDE
   * RISC-V Imperas OVPSim model
   * RISC-V Verilator model
   * The files in the ~/bin directory are used to create the VM Linux image after Ubuntu 18.04LT has been installed. 
   * The VM'sminimal configuration is 2CPU/4G-RAM/20GB-DISK with USB 2.0 enabled
   * To donwload a protable *.osa appliance file, go to:
     - [RISCV_VM *.OVA image on Google Drive](https://drive.google.com/drive/folders/18njYttFpczl-CrHkZ7HQ-lLf-w2fBcL9)
   * **Note that the virtual machine userID /password is _user/abc123_**
 
## Importing VM into VirtualBox on Windows10 host
The instructions to install and run are:
1. Open a Windows Command-line prompt with Admin privileges:
   * Press the Windows-Start key
   * search for the _"cmd.exe"_ program
   * right-click on CMD icon
   * select _“Run as administrator”_
2. Download and run the installed batch file available in this repository: 
   - [riscv_vm Windows10 Install script](https://github.com/openhwgroup/riscv_vm/blob/master/riscv_vm_win10_install.bat)
6. Import the *.OVA “appliance” into VirtualBox
7. Start the VcXsrv client
8. Start git-bash to run the following:
   - Start the VM from the git-bash in head-less mode (your path may be different):
  ```
        <PROMPT$>/c/bta_cadtree/VirtualBox/vb6_0_10/VBoxManage startvm riscv_vm2 --type headless
        <PROMPT$>export DISPLAY=localhost:0.0
  ```
9. SSH into the VM using the command:
   - ssh -Yv user@<_IP of riscv_vm2_>
   - In my case that is: ssh -Yv user@192.168.56.101

## Importing VM into VirtualBox on Linux host
The instructions to install and run are:
   * TBD
 
## Importing VM into VirtualBox on MacOS host
The instructions to install and run are:
   * TBD
