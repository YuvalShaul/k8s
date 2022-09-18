# Persistent Volumes and Claims

In this lab we'll demonstrate the creation of PersistentVolume(s), and then consuming them using PersistentVolumeClaim(s).

- [Create persistent volumes](#Create-persistent-volumes)
- [Create persistent volumes claim](#Create-persistent-volumes-claim)
- [Use your claim in a pod](#Use-your-claim-in-a-pod)

## Create persistent volumes

- First, login into each of you nodes and delete all of those directories created before:  
(/data  /mnt/data etc.)
- Create a storage class:  
**kubectl apply -f storage-class.yaml**  
(this storage class allows for Immediate binding of pvc to pv)
- Create a pair of PersistentVolume objects:  
**kubectl apply -f volumes.yaml**
- Verify:  
**kubectl get pv**
- Make sure you notice the different sizes of these persistent volume objects.
- Login into all 3 nodes, to make sure that no /mnt/data directories were created (yet).  
Example:  
**minikube ssh -p four -n four-m02**


## Create persistent volumes claim

- We are making just a single claim:  
**kubectl apply -f claim.yaml**
- Notice that we explicitly request a specific pv:  
**volumeName: local-pv-b**
- Verify that the claim was created, and is bound to the **requested** pv:  
**kubectl get pvc**
- Look again at the pv(s):  
**kubectl get pv**  
(note that the requested one is now bound to the pvc)
- Login again to all 3 nodes, to make sure that there is no **data** directory under /mnt.


## Use your claim in a pod

- Look at the pod definition in **pod.yaml**
- Note that it is using the **pv-clain** PersistentVolumeClaim that was defined before.  
This is how claims are used as placeholders for volumes.
- Apply the file:  
**kubectl apply -f pod.yaml**
- Exec into the pod to see that the mount directory (**pv-data**) was created.
- You can also get the node that the pod is running at, and see the directory there.


