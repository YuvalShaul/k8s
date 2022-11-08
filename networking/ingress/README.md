# Kubernetes Ingress

We'll use this lab to demonstrate k8s ingress.

- [Ingress Controller](#Ingress-Controller)
- [Deployments and Services](#Deployments-and-Services)
- [creating the Ingress](#creating-the-Ingress)
- [Accessing the Ingress](#Accessing-the-Ingress)


## Ingress Controller

- We'll be using the [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- Install ingress controller as explained in [this section](https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters). 
or
for minikube use [this link](https://kubernetes.github.io/ingress-nginx/deploy/#minikube).
We are using the option that installs the ingress service as a NodePort service.  
This is the way it's going to communicate with the external world (the simplest way).  
Please verify:  
**kubectl get services -n ingress-nginx**  
(look for the service type)
- Read carefully the installation response:  
  - A new namespace called **ingress-nginx** is created
  - A new config maps is created for the controller configuration
  - Several roles, cluster roles and bindings for them
  - 2 services
  - A deployment
  - An ingressclass!!!
  etc.
- Verify that an ingress class was already created for us during the installation:  
**kubectl get ingressclasses**


## Deployments and Services

- Create the 2 deployments:  
**kubectl apply -f dep1.yaml**  
**kubectl apply -f dep2.yaml**  
- Notice that we have just a single pod in each deployment.
- View the pods, and exec into the pod from deployment 1:  
**kubectl get pods**  
**kubectl exec -it <pod name> -- sh**
- Rewrite the main html file with this text:  
**echo "AAAAA" > /usr/share/nginx/html/index.html**
- Repeat this process with the pod from deployment 2, but use "BBBBB" instead.
- Create the 2 services.  
Note that these are ClusterIP services, and we'll use the ingress to connect to them frou the outside:  
**kubectl apply -f service1.yaml**  
**kubectl apply -f service2.yaml**  

## creating the Ingress

- Create the ingress defined in this lab:  
**kubectl apply -f ingress.yaml**
- We are sending all traffic sent to /A to service-1, and all /B traffic to service-2.  
We should be able to see "AAAAA" or "BBBBB" accordingly.
- Note that we are using annotations so that the /A or /B path we are using are actually removed.  
The NGINX server gets an HTTP-GET request for the path "/".  
There is an explained example for this [here](https://kubernetes.github.io/ingress-nginx/examples/rewrite/#rewrite-target)

## Accessing the Ingress

- This is a little tricky:  
Let's start by looking at the Ingress:  
**kubectl get ingress**  
- You should be able to see an IP address that blongs to one of your nodes.  
This is correct, but the port number displayed is not the port nymber you should be using.
- Look at the Ingress services:  
**kubectl get services -n ingress-nginx**  
You should see a port number at the range:  30000-32767
- Query from your host machine using this port, and using the IP address displayed for the nginx.  
Example:  
**curl 192.168.122.13:32409/A**

