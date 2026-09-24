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

- List the pods with their IPs and nodes, and pick two pods that run on **different nodes**:  
```
kubectl get pods -o wide
```
- Or let kubectl pick them for you - the first pod, and the IP of a pod on another node:  
```
POD1=$(kubectl get pods -l app=net-deployment -o jsonpath='{.items[0].metadata.name}')
NODE1=$(kubectl get pod $POD1 -o jsonpath='{.spec.nodeName}')
POD2_IP=$(kubectl get pods -l app=net-deployment -o jsonpath="{range .items[?(@.spec.nodeName!='$NODE1')]}{.status.podIP}{'\\n'}{end}" | head -1)
echo "$POD1 on $NODE1 -> $POD2_IP"
```
- Ping the second pod from the first one:  
```
kubectl exec -it $POD1 -- ping -c 3 $POD2_IP
```
- Now ping a pod that runs on the **same** node as the first pod - it works the same way.

### Why does it work across nodes?

- The Kubernetes networking model requires that:
  - Every pod gets its own unique IP address in the cluster.
  - Every pod can reach every other pod directly by its IP, **on any node**, without NAT.
  - The IP a pod sees for itself is the same IP other pods see for it.
- Kubernetes itself does not implement this - the CNI plugin does. Here it's Calico:
  - Calico gives each node its own block of pod IPs out of the cluster pod CIDR (see how pods on the same node share a prefix).
  - **Same node**: each pod is connected to the node with a veth pair (the `cali...` interfaces), and the node routes directly between them.
  - **Other node**: the node has a route for each other node's pod block, pointing at that node through the `tunl0` ipip tunnel. The packet is wrapped in an outer IP header addressed to the other node, unwrapped there, and delivered to the target pod.
  - Calico uses BGP between the nodes to share which pod block lives on which node, so every node knows where to send traffic.
- You can see these routes on the node:  
```
minikube ssh -p four -n four-m03
ip route
```
Lines with `dev cali...` are local pods, lines with `via <node-ip> dev tunl0` are pod blocks on other nodes.
- To watch the cross-node traffic, run tcpdump on the node while pinging between nodes:  
```
sudo tcpdump -ni tunl0 icmp
```
