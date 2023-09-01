# HPA - Horizontal Pod Autoscaling 

In this lab we are going to demonstrate [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)  

- [Metrics Server](#Metrics-Server)
- [Apply a simple deployment](#Apply-a-simple-deployment)
- [Too much memory required](#Too-much-memory-required)

## Metrics Server

- The [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server#kubernetes-metrics-server) is an addon to kubernetes needed for resource monitoring.
- Use the following command to see if it is enabled (replace **five** with your profile name:
```
minikube addons list  -p five  | grep metrics
```
- If it is not enabled, go ahead and enable it:
```
minikube addons enable metrics-server -p five
```

## Apply a simple deployment

- Look at **mydep.yaml** file from this lab.
- Note that there is no **replicas** definition present.
- Apply it:
```
kubectl apply -f mydep.yaml
```
- Verify by looking at the single pod created:  
```
kubectl get pods
```

## Create you autoscaler

- Inspect the **HPA.yaml** file from this lab, that defines a  Horizontal Pod Autoscaling.
- Note that:  
  - It targets the **mydep** deployment you have just created
  - It scales you replicase between 1 and 3
  - It'l spin-up more replicas if CPU utilization goes above 60%
- Create the autoscaler:
```
kubectl apply -f HPA.yaml**
```
- You can verify the creation:  
```
kubectl get hpa**
```

## Try it

- To create a load, split your Terminator screen, and exec into your pod:  
```
kubectl exec -it \<pod name\> -- sh
```
- Create some load in your pod by running the following command:  
```
for i in 1 2 3 4; do while : ; do : ; done & done
```
It will create 4 loops. Each loop is running the null ( **:** ) command.  
Each loop runs in its own process (Use **ps** to see that).  
Each process can create a load of 100% for a single virtual cpu.  
-  Use the following command to see what's going on:
```
kubectl top pods my-pod
```
You may have to wait for several minutes to see how the load builds up.
- After some minutes, you'll begin to see more pods (up to 3) from this deployment.
- Decrease the load by killing shell processes in your pod.  
You'll have to wait for several minutes to see that the number of pods decreases.
