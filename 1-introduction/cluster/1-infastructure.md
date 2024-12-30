# 1 - Infrastructure

This lab will guide you through the process of creating a baseline environment that we'll use for out kubernetes installation.  
I have tried this on Windows-11 Pro (version 21H2).

- [VirtualBox](#Virtual-Box)
- [K8S Virtual Machines](#K8S-Virtual-Machines)
- [Host Machine](#Host-Machine)
- [Host Machine](#Host-Machine)
- [End Results](#End-Results)


## Virtual Box

- install (or upgrade) [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- I am using 7.0.4 for this installation (January 2023).
- The extension pack is not needed for the lab.
- I got a warning about missing dependencies (python core and win32api).  
To overcome this:
  - install python (I already had it installed on my windoes)
  - Run this command:  
  **pip install  pywin32**
- The setup program will issue a warning about an interface to be installed.  
This is OK.
- Add the following directory into your path:
    C:\Program Files\Oracle\VirtualBox
  so that you can run VirtualBox cli commands.

## K8S Virtual Machine Template

- Download Fedora 35 (server, VirtualBox, vdi file) from osboxes.org.  
    link: https://www.osboxes.org/fedora/  
    user: **root**    pass: **osboxes.org**
- Unzip (I use [7z](https://www.7-zip.org/download.html)) the downloaded file - this is a virtual disk image (VDI) file.
- VirtualBox: Create a Linux (RedHat 64G) machine (as a template)
- 8192 MB of RAM - 1 virtual cpu (2 for the control node later)
- Use your downloaded VDI file as the system disk.
- Run your new template machine, to see if it is working well.


## Host Machine

- Create another machine to be used as a host - to connect and configure.
- I'm using a local Linux (Ubuntu-20) as a host, to control the cluster.
- You can use other distributions here (Fedore Workstations for example, or even another server, so non-GUI and work with a tool like [tmux](https://linuxize.com/post/getting-started-with-tmux/)).  
A GUI based one is easier to work with.  

(goto [2-Network](https://github.com/YuvalShaul/k8s/blob/main/infrastructure/cluster/2-network.md))