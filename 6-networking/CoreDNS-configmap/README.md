# CoreDNS server Configuration

In this lab we experience the configuration of the CoreDNS service.

- [How to configure the CoreDNS service](#How-to-configure-the-CoreDNS-service)
- [A single server block](#A-single-server-block)
- [Multiple server blocks](#Multiple-server-blocks)

## How to configure the CoreDNS service

- The CoreDNS service is configured through a configmap called **coredns** in the **kube-system** namespace (go and verify that!).
- The main part of the configuration is a "Corefile" configuration that is transferred directly to the CoreDNS configuration.
- To use this configuration you have to do the following:
  - Apply the ConfigMap file:  
  **kubectl apply -f \<yaml file\>**
  - Force CoreDNS to use it by rolling out the CoreDNS deployment:  
  **kubectl rollout restart -n kube-system deployment/coredns**

## A single server block

- Look carefully at **CoreDNS-configmap-1.yaml** from this lab.
  - There is just ONE server block there.
  - I takes care of ALL domain names (a single note).
  - Currently, if name resolution fails, it forwards the request to whatever other server is defined in /etc/resolv.conf file (of the Node).
- Test this configuration:
  - Apply the first configuration:  
  **kubectl apply -f  CoreDNS-configmap-1.yaml**  
  **kubectl rollout restart -n kube-system deployment/coredns**
  - Run the **dns-pod.yaml** from this lab:  
  **kubectl apply -f dns-pod.yaml**  
  (it is now best to have multiple terminals)
  - Now exec into it:  
  **kubectl exec -it dns-pod -- sh**
  - Verify that ping to **\<ip-address-of-you-pod\>.default.pod.cluster.local** works.
  - Verify that ping to **google.com** works
- Change this configuration (so edit **CoreDNS-configmap-1.yaml**):  
  - Remove the following line (and don't forget to re-apply the configuration):  
  **forward . /etc/resolv.conf**
  - Now try to ping both destinations again. What's the difference?

## Multiple server blocks

- Look at the 2nd file:  **CoreDNS-configmap-2.yaml**:
  - The first block now takes care ONLY for domains with suffix **cluster.local**
  - THERE IS a forward to default server in the block..but still...
  - Try to ping **google.com**
- Since it's clear that **google.com** domain name is not "covered" by this block, let's add a another block for **google.com**:
  - Uncomment the block
  - Reload the configuration as explained on the first section
  - Try to ping **google.com** (or domains that suffix) again.
  - Try to ping your pod again.
  - ...AND...try to ping other domain names (cnn.com  aws.com ...)


So this is how you can create your "mini DNS servers" using CoreDNS.