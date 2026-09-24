# Calico Operation

We'll use this lab to get a glimpse of the calico networking plugin.

- [Make sure you are running Calico](#Make-sure-you-are-running-Calico)
- [Create some pods and inspect scheduling](#Create-some-pods-and-inspect-scheduling)
- [Networking Inside Nodes](#Networking-Inside-Nodes)
- [Show networking inside a pod](#Show-networking-inside-a-pod)
- [Ping from pod to pod](#Ping-from-pod-to-pod)


## Make sure you are running Calico

- To run Calico in minikube, you should specify it in your **minikube start** command:  
```
minikube start -p four -n 4 --network-plugin=cni --cni=calico
```

## Create some pods and inspect scheduling

- The **netpods.yaml** file from this lab creates many pods.
- Apply the file:  
```
kubectl apply -f netpods.yaml
```
- Several of these pods will be scheduled to our test node (I'll be using k8s-c).  
Find how many of those have landed in the testing node:  
```
kubectl get pods -o wide | grep four-m03 | wc -l
```

## Networking Inside Nodes

- We would like to take a look at the networking inside the test node:  
```
minikube ssh -p four -n four-m03
```
- The Calico plugin will create an interface for each pod scheduled to run here.  
It will also create an [ipip tunnel](https://datatracker.ietf.org/doc/html/rfc2003) interface to connect local pods to pods in other nodes:  
```
ip address show
```

## Show networking inside a pod

- You can exec into a pod, and then use networking commands inside.
- For example, listing pods and then exec to a specific pod:  
```
kubectl get pods -o wide | grep 03
kubectl exec -it net-deployment-5bb5595f8f-9d9p9 -- sh
```
and inside the pods, list addresses and watch traffic:  
```
ip a sh
tcpdump
```

## Ping from pod to pod

- List the pods with their IP addresses and nodes:  
```
kubectl get pods -o wide
```
- Exec into one of the pods:  
```
kubectl exec -it net-deployment-5bb5595f8f-9d9p9 -- sh
```
- Inside the pod, ping the IP of another pod - pick one that runs on a **different node**:  
```
ping 172.16.96.168
```
(replace the pod name and IP address with those from your cluster)
- The ping works, even though the pods are on different nodes.  
In Kubernetes, every pod gets its own IP address, and every pod can reach any other pod by its IP, on any node.  
Calico makes this happen by connecting the nodes with the ipip tunnel we saw earlier.
