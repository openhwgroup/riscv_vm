# riscv_vm
&nbsp;<img src="https://github.com/openhwgroup/riscv_vm/blob/master/RISCV_VM.png" width="200" title="RISC-V VM">

The OpenHW Group's RISC-V Virtual Machine (riscv_vm) is intended for anyone wanting to study, configure as-preferred, modify, implement or release hardware based the RISC-V Instruction Set Architecture. The VM is preconfigured for RISC-V HW development. It was developed and tested with VirtualBox 6.0.10 but not on other virtualization SW. As of Sept 10, 2019, it includes most of the SW described in the https://open-isa.org/get-started/ webpage, except for NXP's VEGA board SDK.
   * RISC-V SW tool chain using the Eclipse-IDE
   * RISC-V Imperas OVPSim model
   * RISC-V Verilator model
   * The files in the ~/bin directory are used to create the VM Linux image after Ubuntu 18.04LTS has been installed. 
   * The VM'sminimal configuration is 2CPU/4G-RAM/20GB-DISK with USB 2.0 enabled
   * To donwload a protable *.osa appliance file, go to:
     - [RISCV_VM *.OVA image on Google Drive](https://drive.google.com/drive/folders/18njYttFpczl-CrHkZ7HQ-lLf-w2fBcL9)
     - **Size:** 4 GB (3,785,816,576 bytes)
     - **MDA5:** 29e97756c8cb77f42503ae7ef4ddf876
     - **SHA1:** b274fcac89d7c2d3fbaa26742e91a8c115774fad
   * **Note1: that the virtual machine userID /password is _user/abc123_**
   * Note2: an early version of the VM was released with a work-around to comply with 3rd party SW components in the VEGA SDK; for that version, the SDK must must installed directly within the VM following the instructions located [here](https://open-isa.org/get-started/)
   * <span style="color: green"> **Note3: as of Monday September 16th, the VM includes all SW.**</span>
 
## Importing VM into VirtualBox on Windows10 host
The instructions to install and run are:
1. Open a Windows Command-line prompt with Admin privileges:
   * Press the Windows-Start key
   * search for the _"cmd.exe"_ program
   * right-click on CMD icon
   * select _“Run as administrator”_
2. Download and run the installer batch file available in this repository: 
   - [riscv_vm Windows10 Install script](https://github.com/openhwgroup/riscv_vm/blob/master/riscv_vm_win10_install.bat)
3. Install VirtualBox and its corresponding Extension Pack downloaded by the installer script
4. Import the *.OVA “appliance” into VirtualBox
5. Start the VcXsrv client
6. Start git-bash to run the following:
   - Start the VM from the git-bash in head-less mode (your path may be different):
  ```
        <PROMPT$>/c/bta_cadtree/VirtualBox/vb6_0_10/VBoxManage startvm riscv_vm --type headless
        <PROMPT$>export DISPLAY=localhost:0.0
  ```
7. SSH into the VM using the command:
   - ssh -Yv user@<_IP of riscv_vm2_>
   - In my case that is: ssh -Yv user@192.168.56.101
8. Finally, install the JLink driver for the host system by following the instructions here:
   - https://www.segger.com/downloads/jlink/

## Installing the riscv_vm tools directly on Ubuntu 18.04LTS host (UNTESTED)
On Ubuntu 18.04 the virtual box that is included by default is 5.x. Follow these instructions to download and install 6.x from virtualbox instead:
1. From a command-line terminal
2. clone the repo from your Linux machine:
   - git clone git@github.com:openhwgroup/riscv_vm.git
3. Run the installer script in "sudo" mode: 
   - sudo riscv_vm/riscv_vm_ubuntu_install.sh
4. Import the *.OVA “appliance” into VirtualBox
5. There does not seem to be host networks by default in virtualbox on Linux. To add:
   - elect from the GUI menu \[File] -> \[Host Network Manager]
   - then \[Network] -> \[Create]
   - In the newly created network enable the DHCP server
6. The VM may start in error related to host network, you may resolve this by simply opening the Machine's network settings and pressing ok (with perhaps a dummy edit).
7. The installer script installs both VirtualBox and the corresponding extension pack for support of USB. The script also adds the current user to the vboxusers group: 
   * **NOTE**: log-off and on again for new groups to take effect
8. Your Linux kernel may not be compatible with VirtualBox, if the isntallation fails with a message similar to this:
```
WARNING: The vboxdrv kernel module is not loaded. Either there is no module
         available for the current kernel (5.2.11-100.fc29.x86_64) or it failed to
         load. Please recompile the kernel module and install it by

           sudo /sbin/vboxconfig

         You will not be able to start VMs until this problem is fixed.
```
9. Finally, install the JLink driver for the host system by following the instructions here:
   - https://www.segger.com/downloads/jlink/
   
## Importing VM into VirtualBox on MacOS host
The instructions to install and run are:
1. Open the “Terminal” application, found in /Applications/Utilities/
2. Download and run the installer script  available in this repository: 
   - [riscv_vm MacOS Install script](https://github.com/openhwgroup/riscv_vm/blob/master/riscv_vm_macos_install.command) 
3. Install VirtualBox and its corresponding Extension Pack downloaded by the installer script
4. Import the *.OVA “appliance” into VirtualBox
5. Start the XQuartz client:
   - Install XQuartz on your Mac, which is the official X server software for Mac
   - Run Applications > Utilities > XQuartz.app
6. Right click on the XQuartz icon in the dock and select Applications > Terminal.  This should bring up a new xterm terminal windows to run the following:
   - Start the VM from the xquartz-terminal in head-less mode (your path may be different):
  ```
        <PROMPT$>/c/bta_cadtree/VirtualBox/vb6_0_10/VBoxManage startvm riscv_vm --type headless
        <PROMPT$>export DISPLAY=localhost:0.0
  ```
7. SSH into the VM using the command:
   - ssh -Yv user@<_IP of riscv_vm2_>
   - In my case that is: ssh -Yv user@192.168.56.101
8. Finally, install the JLink driver for the host system by following the instructions here:
   - https://www.segger.com/downloads/jlink/
