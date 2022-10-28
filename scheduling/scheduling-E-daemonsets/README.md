# Daemonsets

In this lab we'll demonstrate the use of daemonsets.

- [Create a daemonset](#Create-a-daemonset)
- [Use taints to limit the daemonset](#Use-taints-to-limit-the-daemonset)

## Create a daemonset

- Look at the **daemonset-one.yaml** file from this lab.  
It creates a daemonset that cleans up a volume each 10 seconds.
- Create the daemonset by applying the file:  
**kubectl apply -f daemonset-one.yaml**
- Look at the daemonset created:  
**kubectl get ds**
- Verify your pods:  
**kubectl get pods -o wide**
- You can exec into each of these pods to see that those volumes are really cleared.
- Delete the daemonset:  
**kubectl delete ds daemonset-one**  
or
**kubectl delete daemonset daemonset-one**  
or
**kubectl delete -f daemonset-one.yaml**


## Use taints to limit the daemonset

- Use a taint to limit a specific working node:  
**kubectl taint nodes four-m02 notrun=daemonsets:NoSchedule**
- Run your daemonset again:  
**kubectl apply -f daemonset-one.yaml**
- Verify your pods:  
**kubectl get pods -o wide**  
How many pods are running?  Where?
- Delete the taint:  
**kubectl taint nodes four-m02 notrun-**
- Verify your pods again:  
**kubectl get pods -o wide**  
Any changes?
- Do not forget to delete the daemonset when your'e done.

