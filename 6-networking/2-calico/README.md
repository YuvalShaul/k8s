# Calico Operation

We'll use this lab to get a glimpse of the calico networking plugin.

- [Make sure you are running Calico](#Make-sure-you-are-running-Calico)
- [Create some pods and inspect scheduling](#Create-some-pods-and-inspect-scheduling)
- [Networking Inside Nodes](#Networking-Inside-Nodes)
- [Show networking inside a pod](#Show-networking-inside-a-pod)


## Make sure you are running Calico

- To run Calico in minikube, you should specify it in your **minikube start** command:  
```
minikube start -p five -n 5 --network-plugin=cni --cni=calico
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
  