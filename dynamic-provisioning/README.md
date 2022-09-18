# Dynamic Provisioning

This is a demo for dynamic provisioning of pv.  
minikube can do this to demonstrate this K8S feature.  
See [here](https://minikube.sigs.k8s.io/docs/handbook/persistent_volumes/#dynamic-provisioning-and-csi) for more details.

## Understanding what we'll demonstrate

- Dynamic provisioning of PersistentVolumes (pv) means that:  
**you create (or create and use) a PersistentVolumeClaim (pvc) and the pv is created automatically for you.**
- In most cases, the idea is that the claim will spin-up something like [EBS](https://aws.amazon.com/ebs/), or other type of virtual disk instance.
- In local, on-premise environment you can use something like [ceph](https://docs.ceph.com/en/quincy/#) to achieve the same.
- Here, the default Storage Provisioner Controller will automatically create hostPath volumes automatically.
- The only thing you have to do:  
**not specify a storageClassName at all in your pvc.

## Try that

- Create a claim:  
**kubectl apply -f claim.yaml**
- See that you have a claim, but also a pv:  
**kubectl get pvc**  
**kubectl get pv**
- You can now run a pod:  
**kubectl apply -f pod.yaml**
- Don't forget to delete everything, so that you're ready for your next labs.
