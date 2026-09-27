# Pod to Pod

We'll use this lab to see that every pod gets its own IP address, and that pods reach each other directly at those addresses, as if they were all on one network.

- [Start a cluster with two nodes](#Start-a-cluster-with-two-nodes)
- [Create pods](#Create-pods)
- [Ping from pod to pod](#Ping-from-pod-to-pod)
- [Clean up](#Clean-up)

## Start a cluster with two nodes

- Any network plugin will do. With minikube:  
```
minikube start -n 2
```

## Create pods

- The **pods.yaml** file from this lab creates a deployment of 4 pods.
- Apply the file:  
```
kubectl apply -f pods.yaml
```
- List the pods with their IP addresses and nodes:  
```
kubectl get pods -o wide
```
Each pod has an IP address of its own, and the pods are spread over both nodes.

## Ping from pod to pod

- Exec into one of the pods:  
```
kubectl exec -it net-deployment-5bb5595f8f-9d9p9 -- sh
```
- Inside the pod, ping a pod on the **same node**, then a pod on a **different node**:  
```
ping -c 3 10.244.0.5
ping -c 3 10.244.1.3
```
(replace the pod name and IP addresses with those from your cluster)
- Both pings work.  
In Kubernetes, every pod gets its own IP address, and every pod can reach any other pod by its IP, on any node.  
How the packets get between the nodes is up to the network plugin.

## Clean up

```
kubectl delete -f pods.yaml
```
