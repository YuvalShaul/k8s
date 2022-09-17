# Multi Container Pods

In this lab we are going to demonstrate pods with multiple containers.

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

