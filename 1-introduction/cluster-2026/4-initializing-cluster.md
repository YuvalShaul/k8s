#### Initialize the Master Node
- Run this only on your k8s master node:
```
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=192.168.131.11
```
- Run these three commands on the Master node exactly as shown. This gives your osboxes user permission to run kubectl commands:
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
- Kubernetes nodes are "NotReady" until you install a Container Network Interface (CNI). 
  - Since you used the --pod-network-cidr=192.168.0.0/16 flag in your init command, Calico is the perfect choice.
  - Run this on the Master node:
  ```
  kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
  ```
- You can use this to see if Calico is running:
```
kubectl get pods --namespace kube_system
```
- Now, join the workers:
```
sudo kubeadm join 192.168.131.11:6443 --token pcgrz6.fgka4azj7jsszpqa \
    --discovery-token-ca-cert-hash sha256:cd9b69fd94cdea38107c369672556adef8ed60e6044654ce217e54f800fe5081
```
- After joining, the worker nodes will appear as "Not Ready" for some time.
