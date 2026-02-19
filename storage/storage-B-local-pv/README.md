# Storage - A local Persistent Volume

In this lab we'll demonstrate the creation a local PersistentVolume, and then consume it using a PersistentVolumeClaim.

- [Create a local persistent volumes](#Create-a-local-persistent-volumes)
- [Bound the local PV to a PVC](#Bound-the-local-PV-to-a-PVC)
- [Use the volume in a pod](#Use-the-volume-in-a-pod)
- [Testing the local volume](#Testing-the-local-volume)

## Create a local persistent volumes

- Look at the **local-pv.yaml** file from this lab.  
I includes an affiny part, that direct the local PV to be created on node four-m03.
- Apply the file, and then verify that your local PV was created:  
**kubectl get pv**

## Bound the local PV to a PVC

- Look at the **local-pvc.yaml** file from this lab.  
It will bind the local PV we have just created.
- Apply the file, and verify that it has created a PVC for that PV:  
**kubectl get pvc**

## Use the volume in a pod

- Look at the **pod.yaml** file from this lab.
- This file will create a pod that declares a volume based on the claim (PVC)  
we have just created.  
Then it will mount that volume in the pod file system.

## Testing the local volume

- You can get to the same place in two ways:
  - Login into four-m03, and cd to the local volume directory  
  ```
  minikube ssh -p four -n four-m03
  ```
  - Exec into the pod and go to the directory where it is mounted.
- Create a file using one way, and observe your file from the other way.
