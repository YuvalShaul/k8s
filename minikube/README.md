# Minikube commands

## Links

- [minikube documentation](https://minikube.sigs.k8s.io/docs/)
- [minikube commands](https://minikube.sigs.k8s.io/docs/commands/)


## Profiles (clusters)

- List all current profiles:  
**minikube profile list**
- Show the current profile (even if it does not exist):  
**minikube profile**
- Start a profile specifying a name:  
**minikube start -p \<profile name\>**
- Start a profile with 4 worker nodes:  
**minikube -p fournodes --nodes 4**
- Delete a profile:  
**minikube delete -p \<profile name\>**


Try it yourself:  
- create 2 profiles: p1 and p2:  
**minikube start -p p1**  
**minikube start -p p2**  
- List these profiles:  
**minikube profile list**
- Set current profile to p1:  
**minikube profile p1**
- Vefiry that this is the case by listing profiles (look for the asterisk)
- use kubectl to list nodes of the p1
- Make p2 the current profile:  
**minikube profile p2**
- Verify this by listing profile
- Make sure that kubectl is now pointing to p2

