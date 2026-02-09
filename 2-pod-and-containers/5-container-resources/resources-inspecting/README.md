(see a post covering this material [here](https://www.yuval.guide/k8s/resources/inspecting-resources/))

# Resources - Inspecting

In this lab we are going to inspect resources used by a pod.


- [Installing k8s resource server](#Installing-k8s-resource-server)
- [Use the top command](#Use-the-top-command)
- [Create some load](#Create-some-load)

## Installing k8s resource server

- The [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server#kubernetes-metrics-server) is an addon to kubernetes needed for resource monitoring.
- Enable the metrics server in minikube:
```
minikube addons enable metrics-server -p <profile name>
```
- You can read more about the metrics server from the [github repository](https://github.com/kubernetes-sigs/metrics-server)
- Test the installation by using the metric server api:  
**kubectl get --raw /apis/metrics.k8s.io/**

## Use the top command

- Make sure you delete pods that were created in previous labs.
- Create a pod by applying the pod.yaml file in this lab:  
**kubectl apply -f pod.yaml**  
There is nothing special about this specific pod.
- Use the top command:  
**kubectl top pods**  
You may get a response like this:  
**error: metrics not available yet**  
Just wait a few more seconds.

## Create some load

- To create a load, split your Terminator screen, and exec into your pod:  
**kubectl exec -it my-pod -- sh**
- Create a lod in your pod by running the following command:  
**for i in 1 2 3 4; do while : ; do : ; done & done**  
It will create 4 loops. Each loop is running the null ( **:** ) command.  
Each loop runs in its own process (Use **ps** to see that).  
Each process can create a load of 100% for a single virtual cpu.  
-  Use **kubectl top pods my-pod** to see what's going on.  
You may have to wait for several minutes to see how the load builds up.



