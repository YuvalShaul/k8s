# Basic DNS

We'll use this lab to demonstrate DNS service within kubernetes.

- [View DNS Pods and service](#View-DNS-Pods-and-service)
- [Create client and server pods](#Create-client-and-server-pods)
- [DNS for pods](#DNS-for-pods)

## View DNS Pods and service

- The DNS Pods are part of the kube-system namespace.  
Minikube uses [**CoreDNS**](https://coredns.io/) as out DNS server.  
View the DNS Pods in your cluster:  
**kubectl get pods -n kube-system**
- DNS is exposed internally in k8s as a service:  
**kubectl get service -n kube-system**

## Create client and server pods

- Look at the **pods.yaml** file from this lab.  
It defines 2 pods, an Nginx server and a busybox(used as a client).
- Create these pods:  
**kubectl apply -f pods.yaml**
- Vew your pods with their assigned IP addresses:  
**kubectl get pods -o wide**

## DNS for pods

- Exec into your client pod:  
**kubectl exec -it client-pod -- sh**
- Use nslookup (replace the ip address with those of you pods):  
**nslookup 172-16-96-168.default.pod.cluster.local**
- Use curl to fetch a page from the server, using a DNS name:  
**curl 172-16-96-168.default.pod.cluster.local**  
(you should get the main Nginx page)