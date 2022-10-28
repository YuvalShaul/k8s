# Scheduling with nodeSelector

Use this lab we'll demonstrate **nodeSelector** configurations.

- [Assign labels to nodes](#Assign-labels-to-nodes)
- [Create your pod](#Create-your-pod)
- [The same - on the control node](#The-same-on-the-control-node)

## Assign labels to nodes

- List your nodes:  
**kubectl get nodes**
- Label your node, by following this example:  
**kubectl label nodes four-m02 special=yep**
- You can see that label by describing the node:
**kubectl describe nodes <node-name>**

## Create your pod

- Look at the **select-pod.yaml** file from this lab:  
It uses nodeSelector to select a specific node.  
**Change the label name and value to those you have configured to your node**.
- Create your pod by applying the file:  
**kubectl apply -f select-pod.yaml**
- Make sure your pod is running in the correct node:  
**kubectl get pods -o wide**
- Delete your pod.
- Delete the label from the node:  
**kubectl label nodes four-m02 special-**

## The same on the control node

- Label a node again, this time the control node (same label):  
**kubectl label nodes four special=yep**
- You don't have to change the pod definition, it still uses the same label.
- Create your pod by applying the file:  
**kubectl apply -f select-pod.yaml**
- Is your pod running? What's going on?
**kubectl get pods -o wide**
- Delete your pod, but DO NOT DELETE THE LABEL.  
You will fix this in the bext lab.
