# 28 - Using simple volumes

In this lab we'll use basic volumes in our pods:  
No PersistentVolume, no PersistentVolumeClain, no StorageClass.

- [Look at your nodes](#Look-at-your-nodes)
- [Create a multi container pod](#Create-a-multi-container-pod)
- [Things to do in container-a](#Things-to-do-in-container-a)
- [Things to do in container-b](#Things-to-do-in-container-b)
- [Look at the volume](#Look-at-the-volume)
- [Delete the pod](#Delete-the-pod)


## Look at your nodes

- Connect to all worker nodes in your cluster, and verify that a /data directory is empty:  

(use **kubectl get nodes** to see the names of your nodes).
Example:  
**minikube ssh -p four -n four**  
**ls /data**  
**minikube ssh -p four -n four-m02**  
**ls /data**  
**minikube ssh -p four -n four-m03**  
**ls /data**  
**minikube ssh -p four -n four-m04**  
**ls /data**  

## Create a multi container pod

- Look at the definition of **my-pod.yaml** file from this lab.  
It defines a single pod (called volume-pod), and 2 containers inside it.  
It defined a single [hostPath](#https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) volume.  
Each container mounts this volume on a different container path.
- Apply this file:  
**kubectl apply -f volume-pods.yaml**


## Things to do in container-a

- Exec into the first container of the pod:  
**kubectl exec -it volume-pod --container busybox-a -- sh**
- Verify that the mount point was created:  
**ls /**  
(look for the **output-a** directory)
- Write a new file inside that directory:  
**echo "hello from container a" > data.txt**
- Exit from the container (**exit**)

## Things to do in container-b

- Exec into the second container of the pod:  
**kubectl exec -it volume-pod --container busybox-b -- sh**
- Verify that the mount point was created:  
**ls /**  
(look for the **output-b** directory)
- Verify that there is a file called data.txt inside that directory, and look at its content:  
**cd /output-b**  
**cat data.txt**
- exit from the container (**exit**)

## Look at the volume

- Find the specific node where the pod is running:  
**kubectl get pods -o wide**
- Connect to another node, and verify that a /data directory does not exist:  
**ssh osboxes@192.168.122.xx**  
**ls /data**
- Connect to the correct node, find the /data directory and view the ontent of the file:  
**ssh osboxes@192.168.122.xx**  
**ls /data**  
**cat /data/data.txt**

## Delete the pod

- Delete the pod:  
**kubectl delete pods volume-pod**
- Login again to the node where the pod was running:  
**ssh osboxes@192.168.122.xx**
- Verify that:  
  - the /data directory is still there
  - the data.txt file and its content were not deleted.

