# 194 - Scheduling with affinity and anti-affinity

Use this lab we'll demonstrate node affinity configurations.

- [Assign labels to nodes](#Assign-labels-to-nodes)

## View labels of a node


- View your node labels:  
**kubectl describe node k8s-b | more**
- Notice a label that is going to be used with this lab:  
...
    kubernetes.io/os=linux
...


## requiredDuringSchedulingIgnoredDuringExecution

- Look at the affinity-pod from this lab.  
- The **requiredDuringSchedulingIgnoredDuringExecution** part says that:  
  there should be a label with key **kubernetes.io/os** and value **linux**  
  or else the pod could not run at all.
- To test that, edit the file and chane **linux** to **linuxxx**, then try to apply:  
**kubectl apply -f affinity-pod.yaml**
- Verify that the pod is in the **pending** state, and cannot run.
- Undo your change (so back to **linux**) and delete the pod.

## preferredDuringSchedulingIgnoredDuringExecution

- Look again at the file.
- The **requiredDuringSchedulingIgnoredDuringExecution** part says this:  
We **prefer** a node with a label with key=**nodetype** and value=**good** or **fine**.  
But if we don't find such a node, we'll run the pod anyway!!!
- We still don't have the label, so create the pod now:  
**kubectl apply -f affinity-pod.yaml**
- See where your pod is running (note that it is indeed running!):  
**kubectl get pods -o wide**  
Then delete the pod.
- Let's add a label to a node (but choose a different one):  
**kubectl label node k8s-c nodetype=good**
- Run the pod again, and see where it is running now.