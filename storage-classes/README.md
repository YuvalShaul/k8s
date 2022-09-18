# Storage Classes

In this lab we'll demonstrate a basic use of storage classes.  
**We'll not demonstrate dynamic provisioning of volumes!**  
We'll demonstrate however how claims can bind volumes based on the storage class.

- [Create storage classes](#Create-storage-classes)
- [Create persistent volumes](#Create-persistent-volumes)
- [Create persistent volumes claim](#Create-persistent-volumes-claim)
- [Use your claims in pods](#Use-your-claims-in-pods)

## Create storage classes

- Look at the **storage-classes.yaml** file from this lab.  
It defines two storage classes called **fast** and **slow**.
- Note that in more complex scenarios these storage classes would use a [CSI](#https://kubernetes.io/blog/2019/01/15/container-storage-interface-ga/) plugin to communicate with some external entity that can provide volumes.
- Create the storage classes:  
**kubectl apply -f storage-classes.yaml**
- verify:  
**kubectl get sc**


## Create persistent volumes

- Create 4 PersistentVolume objects:  
**kubectl apply -f volumes.yaml**
- Verify:  
**kubectl get pv**
- Note that 2 of them specify the **fast** storage class, and the other two specify the **slow** storage class. 


## Create persistent volumes claim

- Claim a fast persistent volume:  
**kubectl apply -f claim-fast.yaml**
- Verify that the claim was created, and is bound to one of the **fast** pv(s):  
**kubectl get pvc**
- Repeat the same process for **claim-slow.yaml**.
- Look again at the pv(s):  


## Use your claims in pods

- Create your pods:  
**kubectl apply -f slow-pod.yaml**  
**kubectl apply -f fast-pod.yaml**
- You can exec into both pods to see that the mount directory (**pv-data**) was created.


