# Services

We'll use this lab to demonstrate services.

- [Create a deployment](#Create-a-deployment)
- [Create a cluster-ip service](#Create-a-cluster-ipservice)
- [Use the ClusterIP service](#Use-the-ClusterIP-service)
- [A NodePort service](#A-NodePort-service)


## Create a deployment-

- Look at **svc-deployment.yaml** from this lab.  
It contains a deployment that run 3 replicas of an Nginx server.  
Apply it:  
**kubectl apply -f svc-deployment.yaml**
- View the pods, and exec into the first pod:  
**kubectl get pods**  
**kubectl exec -it \<pod name\> -- sh**
- Rewrite the main html file with this text:  
**echo "AAAAA" > /usr/share/nginx/html/index.html**
- Repeat this process with the 2nd and 3rd pods, but use "BBBBB" and "CCCCC" accordingly.

## Create a cluster-ip service

- Look at the **cluster-ip.yaml** file from this lab.  
It creates a service of the cluster-ip type.  
This service uses the pods that were created by the **svc-deployment.yaml**.  
- Create the service:  
**kubectl apply -f cluster-ip.yaml**
- Verify that the service was created and get the service IP address:  
**kubectl get services**
- You can also see the endpoints (i.e. pods) this service is sending traffic to:  
**kubectl get endpoints clusterip-service**

## Use the ClusterIP service

- Create a busybox pod to use as a client:  
**kubectl apply -f pod.yaml**
- Exec into this pod:  
**kubectl exec -it client-pod -- sh**
- Use curl repeatedly to get the main page of the service.  
Since you have changed your pods to respond with different replies, you should be able to see how the service load balancing works.  
**curl \<service-IP-address\>**
- Now try the same, this time using the service name:  
**curl clusterip-service**

## A NodePort service

- Use the same pods with the **node-port.yaml** service definition.  
This will create a NodePort type service that will be accessible from outside the cluster:  
**kubectl apply -f node-port.yaml**
- Test this service from your host machine, using one of the IP addresses of your nodes (including the control node):  
**curl 192.168.122.11:30080**
- You can now use a browser to see the same.  
(notice: some browsers will not re-send an HTTP GET request each time you refresh your page.)

## A LoadBalancer service

- You can use minikube to help you run a service of type LoadBalancer.
- Read [here](https://minikube.sigs.k8s.io/docs/handbook/accessing/#loadbalancer-access) for more details.
- Split your screen and run the following command:  
**minikube -p four tunnel**  
(change to your profile name)
- In the other screen, apply the load balancer service:  
**kubectl apply -f load-balancer.yaml**

