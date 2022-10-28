# Scheduling: taints and tolerations

Use this lab we'll demonstrate tains and tolerations.

- [A Pod that can tolerate](#A-Pod-that-can-tolerate)

## Select a node to run but add a taint

- Label a specific node as **good to run**, by following this example:  
**kubectl label nodes four-m02 goodrun=true**
- You can see that label by describing the node:
**kubectl describe nodes <node-name>**
- Now, taint that node, so that pods will not run on it:  
**kubectl taint four-m02 goodrun  smell=bad:NoSchedule**  
So now, pods should create a matching toleration for it, unless they do something about the smell.
- Create the pod from this lab.:  
**kubectl apply -f select-pod.yaml**
- Verify that your pod is not running on the desired node:  
**kubectl get pods -o wide**


## A Pod that can tolerate

- Delete the pod
**kubectl delete pods select-pod**
- Edit the pod and enable the toleration. 
- Create the pod again, and check if now it is working.