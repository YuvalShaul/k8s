# Multi Container Pods

In this lab we are going to demonstrate pods with multiple containers.  
- This is a complete example of the case of **"sidecar container"** patterm.  
(see [here](https://medium.com/bb-tutorials-and-thoughts/kubernetes-learn-sidecar-container-pattern-6d8c21f873d) for more details.)  
- We'll create a single pod with 2 containers in it.  
- We'll create a shared volume, so that they can share files.
- The result:  
One container writes to a file, the other container reads from the file and writes to STDOUT (which kubernetes turns to logs)

## The details

- Look at **multi-container.yaml** file from this lab.
- It define:
  - 2 containers
  - a single volume
  - one mount point per each container
- Run this pod:  
**kubectl apply -f multi-container.yaml**
- Verify:  
**kubectl get pods**  
(note the 0/2 and lter 2/2 containers are ready out of total of 2 containers)
- Vew the logs:  
**kubectl logs -f multi busybox2**

