# 195 - Scheduling: taints and tolerations

Use this lab we'll demonstrate tains and tolerations.

- [A Pod that can tolerate](#A-Pod-that-can-tolerate)

## A Pod that can tolerate

- Your pod configuration from this lab is simmilar to the pod from the last lab.  
It still "wants" to run on the control node (using labels).
- Notice a new thing:  
The pod has a tolerations part, specifying the taint that is configured automatically by kubeadm on the control node.  
The key is:  **node-role.kubernetes.io/master**  
There is no value.
- Create this pod by applying it:  
**kubectl apply -f select-pod.yaml**
- Verify that your pod is running on the control node:  
**kubectl get pods -o wide**
- Delete the pod
**kubectl delete pods select-pod**
- Delete the label from the control node:  
**kubectl label nodes k8s-control special-**