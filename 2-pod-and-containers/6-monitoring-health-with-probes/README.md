# Monitoring container health with probes

In this lab we are going to demonstrate using probes to monitor containers health.


## Liveness pod

- Look at **liveness-pod.yaml** from this lab.  
It defines a livenessProbe of the type exec.  
The probe tries to cat a file, that is to be deleted after 30 seconds.
- Run the pod:  
**kubectl apply -f liveness-pod.yaml**
- After 30 seconds, the pods will start to fail and restart.  
Use **kubectl describe pods liveness-pod** to see what's going on.


## Liveness pod - http probe

- Look at **liveness-http-pod.yaml** from this lab.  
It defines a livenessProbe of the type httpGet.  
The kubelet sends an HTTP GET request to **/healthz** on port 80 of the container.  
A response code between 200 and 399 means success, anything else (or no response at all) is a failure.  
The container serves that file with nginx, and deletes it after 30 seconds -  
from that moment nginx answers with 404 and the probe starts to fail.
- Run the pod:  
**kubectl apply -f liveness-http-pod.yaml**
- Watch the pod. During the first 30 seconds the probe succeeds:  
**kubectl get pods liveness-http-pod -w**
- After 30 seconds the probe fails 3 times in a row, the container is killed  
and restarted, and the RESTARTS counter goes up.  
Use **kubectl describe pods liveness-http-pod** to see what's going on.  
Look at the Events section for lines like:  
**Liveness probe failed: HTTP probe failed with statuscode: 404**
- Delete the pod when you are done:  
**kubectl delete -f liveness-http-pod.yaml**
