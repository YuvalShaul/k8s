# 25 - Network Policies

We'll use this lab to demonstrate network policies

- [Create a new namespaece](#Create-a-new-namespaece)
- [Create pods](#Create-pods)
- [Connectivity before a network policy](#Connectivity-before-a-network-policy)
- [Setting up a blocking network policy](#Setting-up-a-blocking-network-policy)
- [Explicitly allow namespace traffic](#Explicitly-allow-namespace-traffic)
- [Explicitly allow IP cidr block traffic](#Explicitly-allow-IP-cidr-block-traffic)

## Create a new namespaece

- We'll need a new namespace throughout our lab:  
**kubectl create namespace other-ns**  
We'll also label our namespace like this:  
**kubectl label namespace other-ns team=other-team**

## Create pods

- Look at the pods.yaml file from this lab.  
It defins a client pod and a server pod, both in the **other-ns** namespace.
- Create these pods:  
**kubectl apply -f pods.yaml**
- Let's verify the creation and also see the IP addresses of these pods:  
**kubectl get pods -n other-ns -o wide**

## Connectivity before a network policy

- Let's test the connectivity between the client and server pods:  
**kubectl exec -n other-ns client-pod -- curl \<nginx ip address\>**  
You should be able to see the Nginx main page.

## Setting up a blocking network policy

- Look at the **blocking-np.yaml** file from this lab.  
It defines a network policy that specifies Ingress and Egress policy types, but does not explicitly permits any data.  
The outcome of this policy is that all traffic is blocked.  
Apply this policy:  
**kubectl apply -f blocking-np.yaml**
- Try again the last curl command:  
**kubectl exec -n other-ns client-pod -- curl \<nginx ip address\>**  
(you should see the command waiting for a response from the server)
- Type ctrl-c to exit the command
- Delete the policy:  
**kubectl delete -f blocking-np.yaml**

## Explicitly allow namespace traffic

- Apply the **allow-ns-np.yaml** file from this lab.  
This file allows traffic coming from any pod within the **other-ns** namespace.  
- Try the curl command again.
- (remember to delete the policy)

## Explicitly allow IP cidr block traffic

- Edit the **allow-ip-np.yaml** file from this lab.  
Fix the IP address in the cidr block to the IP address of the client pod.
- Apply the **allow-ip-np.yaml** file from this lab.  
This file allows traffic coming from a specific pod (the client) using its IP address.
- Try the curl command again.
- (remember to delete the policy when you're done)


