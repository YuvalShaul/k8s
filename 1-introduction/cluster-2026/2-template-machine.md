
#### VMDK download
- download and extract ubuntu 24.04 LTS VMDK (from osboxes)
- Create a template machine that directly uses this disk
- Your machine location will probably be different from the VMDK file
- Use NAT
- start your machine

#### Fixed IP address
- Use ```ip address show``` to get your ip addess.
- Note the network part:
  - for me the address was 192.168.131.132, and the net was 192.168.131.0/24
- Open /etc/netplan 01-\<something\>.yaml file
- Look the the following text:
  - Replace the addresses so they are correct for your network:
    (I have changed 192.168.10.10 to 192.168.131.10)
  - replace its content with the following:
```
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:  # <-- Change this to match your 'ip link' output
      dhcp4: no
      addresses:
        - 192.168.10.10/24  # <-- Your desired Static IP
      routes:
        - to: default
          via: 192.168.10.2  # <-- Your VMware NAT Gateway (usually .2)
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
```
- Apply:
``` sudo netplan try```


    

#### Prerequisites Phase
- Paste the following code:
```
# Disable swap (mandatory)
sudo swapoff -a
```
- Go ahead and edit the /etc/fstab file, and remove the last line:
```
/swap.img      none    swap    sw      0       0
```
by adding a comment sige (#) at its beginning.
- Run this:
```
# Load kernel modules for networking
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# Sysctl params for bridge networking
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system
```

#### Install Container Runtime (containerd)
- Run:
```
sudo apt-get update
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
# Set SystemdCgroup to true for stability
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
```

#### Install Kubernetes Tools
- Run:
```
# Add the K8s repo
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install specific versions
sudo apt-get update
sudo apt-get install -y kubelet=1.34.0-1.1 kubeadm=1.34.0-1.1 kubectl=1.34.0-1.1
sudo apt-mark hold kubelet kubeadm kubectl
```

#### Some last tests and preparations
- Run:
```
free -m
```
(if swap is 0, we're good)
- Clear machine id:
```
sudo truncate -s 0 /etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
```
- Make sure the "big three" are installed:
```
sudo apt-mark hold kubelet kubeadm kubectl
```
- Record identity before shutdoen:
```
sudo cat /sys/class/dmi/id/product_uuid
```
(record this number for folowup id fix in clones)
- You can now power off this machine, it is ready for cloning.
