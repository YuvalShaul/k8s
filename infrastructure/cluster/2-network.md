# 2 - Network Lab

This lab assumes you have completed the [infrastructure-lab](https://github.com/YuvalShaul/kubernetes/tree/main/labs/k8s-VirtualBox/A-build/1-infastructure-lab), so that you now have a single machine that will be used as a template.
It is now the time to create a network, and clone it.

- [Configure NAT Networking](#Configure-NAT-Networking)
- [IP addresses](#IP-addresses)
- [Add a user](#Add-a-user)
- [Clone Machines](#Clone-Machines)
- [End Results](#End-Results)
- [Connect host to control and workers](#Connect-host-to-control-and-workers)


## Configure NAT Networking

- "**Nat Service**" is explained [here](https://www.virtualbox.org/manual/ch06.html#network_nat_service)
- If you have completed the [first lab](https://github.com/YuvalShaul/kubernetes/tree/main/labs/k8s-VirtualBox/1-infastructure-lab), you should be able to use the VirtualBox command-line interface.
- Add a new NAT network (I name it **k8s-nat**):  
   **VBoxManage natnetwork add --netname k8s-nat --network "192.168.122.0/24" --enable --dhcp off**
- Later on, if your nat network stops working, you can start it again by typing:  
**VBoxManage natnetwork stop  --netname k8s-nat**  
**VBoxManage natnetwork start --netname k8s-nat**
- Now, for each of you machines, right-click -> settings, choose **Network**,  and select "NAT Network" from the drop-down list. Make sure that the correct NAT network appears in "Name".
- Open the "Advanced" option there, and make sure that the "Cable Connected" is checked.


## IP addresses

- Run your single machine
- Configure a static IP address:
- (use **right-ctrl** to exit from the mouse capture of the virtual machine window)
- Make sure that the machine settings in VirtualBox are correct:
  - Adapter 1 is enabled and is attached to **NAT Network**
  - The Nat Network name is correct (there should onle be 1 option)
  - Click on **Advanced** and make sure that **Cable Connected** is checked.
- Learn how your single network interface is called:  
**ip a sh**  
(in my case: enp0s3)
- Edit your networking parameters. Create the file name from the interface name:  
  - **sudo vi /etc/sysconfig/network-scripts/ifcfg-\<if name\>**
    - TYPE=Ethernet
    - BOOTPROTO=static
    - IPADDR=192.168.122.x 
    (where x is 11,12,13 for k8s-a, k8s-b, k8s-c, 10 for k8s-control, 100 for the host)
    - PREFIX=24
    - ONBOOT=yes
    - GATEWAY=192.168.122.1
    - DNS1=8.8.8.8
  - restart your machines
- If all goes well, you should be able to ping 8.8.8.8


## Add a user
- Add a **osboxes** user and add it to the **wheel** group, so that it is a super-user:  
**useradd -G wheel osboxes**
- Set a password for the new user (while you are still in root):  
**passwd osboxes**  
(you'll be required to type the password twice)

## Clone Machines

- Maybe it is best to leave the template machine...well..as a template.
- Clone it carefully in VirtualBox - to create 3 workers nodes and one control node:
  - **Clone when machine is not working !**
  - right-click clone
  - Rename your new machine (k8s-control, k8s-a, k8s-b, k8s-b)
  - create new MAC addresses
  - Full clone !!!
- Configure 2 or more CPUs for your control node machine( settings/system).
- Configure networking for your machines:
192.168.122.X, where x is 10(k8s-control), 11(k8s-a), 12(k8s-b), 13(k8s-c)
- Make sure your new machines can work

## End Results

- You should have:
  - a VirtualBox installation
  - 3 kubernetes worker machines: k8s-a, k8s-b, k8s-c
  - 1 kubernetes control machine: k8s-control
  - 1 host machine



## Connect host to control and workers

- SSH should work out-of-the-box
- You can connect like this:
          ssh osboxes@192.168.122.10
- Use [Terminator shell](https://dev.to/xeroxism/how-to-install-terminator-a-linux-terminal-emulator-on-steroids-1m3h) on your host machine.
You can then login and command all nodes at once.  
https://terminator-gtk3.readthedocs.io/en/latest/  
To install terminator:
  - **sudo add-apt-repository ppa:gnome-terminator**
  - **sudo apt-get update**
  - **sudo apt-get install terminator**

(go to [3 - Building a K8S Cluster](https://github.com/YuvalShaul/kubernetes/tree/main/labs/k8s-VirtualBox/A-build/3-building-a-cluster))  

