# DNS Pod Configuration

We'll use this lab to demonstrate DNS configuration done at the pod level.

- [Cluster DNS service address](#Cluster-DNS-service-address)
- [DNS ClusterFirst pod configuration](#DNS-ClusterFirst-pod-configuration)
- [DNS ClusterFirstWithHostNet pod configuration](#DNS-ClusterFirstWithHostNet-pod-configuration)
- [DNS None pod configuration](#DNS-None-pod-configuration)

## Cluster DNS service address

- Run the following command to view the cluster DNS ip address, used by the DNS service:  
**kubectl get services kube-dns -n kube-system**

## DNS ClusterFirst pod configuration

- Look at the **dns-ClusterFirst-pod.yaml** file from this lab.  
It runs a **nicolaka/netshoot** image that contains many communication tools.  
This is the real default configuration for pods.  
To understand the DNS behaviour of the pod, do the following steps.
- Apply the file to create the pod:  
**kubectl apply -f dns-ClusterFirst-pod.yaml**
- Exec into the pod:  
**kubectl exec -it dns-pod -- sh**
- Use the following command to see the cluster default domain:  
**cat /etc/resolv.conf**  
(in our lab cluster, it should be cluster.local)
- Run **nslookup**, and enable debug mode:  
**nslookup**  (this will get you into nslookup interractive mode)
**set debug**
- Type **server** to see the currently used server.  
Note that this is the cluster DNS service IP address.
- Type **hslkjhslkrjh.com** (this is a dns name that does not exist).  
Note the order that the DNS query takes (here it is in my installation):  
  - hslkjhslkrjh.com.default.svc.cluster.local, type = A, class = IN  
  - hslkjhslkrjh.com.svc.cluster.local, type = A, class = IN  
  - hslkjhslkrjh.com.cluster.local, type = A, class = IN  
  - hslkjhslkrjh.com, type = A, class = IN  

When the DNS query (hslkjhslkrjh.com) does not match the configured cluster domain (cluster.local) the search pattern goes into effect, so that **hslkjhslkrjh.com** will eventually go to the host DNS server.


## DNS ClusterFirstWithHostNet pod configuration

- This option actually works the same, but your pod will get the IP address of the Node, and you should specify **ClusterFirstWithHostNet** specifically at the dnsPolicy field.  
Notice also the **hostNetwork: true** at the configuration.
- Delete the last pod, and apply **dns-ClusterFirstWithHostNet-pod.yaml** file.
- Verify the IP address (you can do this both from kubectl and from the pod itself).
- Repeat all steps from the last section. This time use a knwn domain name like **google.com**.


## DNS None pod configuration

- In this part we configure None as the DNS pod policy.
- Delete the pod from the last section.
- Apply the file (**dns-None-pod.yaml**)
- Exec into the pod. Then view the DNS server(s) used:  
**cat /etc/resolv.conf**  
- Go into **nslookup** and enable debug (see previous sections).
- Try to see a name like aaa (so no dots in it - not a FQDN).  
You should see the serach options used.