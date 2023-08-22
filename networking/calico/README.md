# Calico Operation

We'll use this lab to get a glimpse of the calico networking plugin.

- [Make sure you are running Calico](#Make-sure-you-are-running-Calico)
- [Create some pods and inspect scheduling](#Create-some-pods-and-inspect-scheduling)
- [Network Namespaces](#Network-Namespaces)
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

## Network Namespaces

- We would like to take a look at the networking inside the test node:  
**ssh osboxes@192.168.122.13**
- The Calico plugin will create a [networking namespace](https://man7.org/linux/man-pages/man8/ip-netns.8.html) for each pod scheduled to run here:  
**ip netns list**  (you can ommit the last word)
- Calico configures the node to connect between these namespaces.  
Use the **ip addess show** (or **ip a sh**) to view the interfaces coming from the pods, and the tunnel connecting them at the node namespace.

## Show networking inside a pod

- You can exec into a pod, and then use networking commands inside:
  - **ip a sh**
  - **tcpdump**  (to see network traffic)
- You can see the same from the node cli level:
  - **sudo ip netns exec \<net namespace\>  ip a sh**  
  Example:  
sudo ip netns exec cni-03e58a9e-e9b5-b071-20df-968bcd8abc3d  ip a sh
  - **sudo ip netns exec \<net namespace\>  tcpdump**  