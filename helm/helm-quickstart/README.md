# Install Helm


## Install

- Check if Helm is installed:  
**sudo apt-get install helm**
- If Helm is not installed, install it now:  
Use [this link](https://helm.sh/docs/intro/install/#from-apt-debianubuntu) to install Helm on Ubuntu.  
- Verify your installation:  
**sudo apt-get install helm**



## Add a Helm repo

- Add a repository.  
Example:  
**helm repo add bitnami https://charts.bitnami.com/bitnami**
- Verify:  
**helm repo list**
- Show charts from this repo:  
**helm search repo bitnami**  
(a long list..)


## Install a chart

- Install an NGINX server chart:  
**helm install my-release bitnami/nginx**
- Verify the installation:  
**helm list**
- See what was installed:  
**kubectl get pods**
**kubectl get services**
- Run a pod interactively so you can curl NGINX from within the cluster:  
**kubectl run -it curler --image=radial/busyboxplus:curl**
- Use curl to get the NGINX page from withing the cluster:  
**curl my-release-nginx.default.svc.cluster.local**  
(you are connecting to the nginx pod directly, as the LoadBalancer service is still pending)

## minikube support for LoadBalancer

- The LoadBalancer service is still pending.
- minikube supports LoadBalancer services by creating a tunnel.  
You should run this at another terminal (the command will not stop):  
**minikube tunnel -p four**  
(my profile for minikube is four, the name of the service is my-release-nginx)
- Use another terminal to see the state of the service:  
**kubectl get svc**
- Use a browser (firefox) to see the nginx entry page.  
(you'll see the ip address and the port number in the svc command)

## Uninstall the Chart

- Uninstall the chart:  
**helm uninstall my-release**
- Verify that pods and services were removed.
