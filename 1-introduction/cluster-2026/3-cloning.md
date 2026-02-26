#### Cloning the Template Machine
- Make sure the template machine is powered off
- Right-click your Template VM -> Manage -> Clone.
  - Choose "Current state in the virtual machine".
  - IMPORTANT: Choose "Create a full clone".
  - Do NOT choose "Linked clone"—if you delete the template later, your whole cluster will die.
- Repeat this 3 times. Name them clearly:
  - k8s-master
  - k8s-worker-1
  - k8s-worker-2


#### Post clone "identity fix"
Once you turn on your 3 new VMs, they will all think their name is osboxes and they will all have the same internal IP. You must do this on each one immediately:

- Change the Hostname:
  - On the master: sudo hostnamectl set-hostname k8s-master
  - On worker 1: sudo hostnamectl set-hostname k8s-worker-1
  - On worker 2: sudo hostnamectl set-hostname k8s-worker-2

- Update the Hosts file:
  - On all machines, run sudo nano /etc/hosts 
  - make sure they know who the others are by adding their IPs (which we will set next).
    - k8s-master:  192.168.131.11
    - k8s-worker-1:  192.168.131.12
    - k8s-worker-2:  192.168.131.13
- Next, fix the IP addresses by editing the netplan file and reboot.