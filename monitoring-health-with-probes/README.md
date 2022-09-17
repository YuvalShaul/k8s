# 15 - Monitoring container health with probes

In this lab we will demonstrate the usage of probes to monitor containers health.


## Liveness pod

- Look at **liveness-pod.yaml** from this lab.  
- It defines a livenessProbe of the type exec.  
- The probe tries to **cat** a file (so type it on the screen), that is to be deleted after 30 seconds.
- Run the pod:  
**kubectl apply -f liveness-pod.yaml**
- After 30 seconds, the pods will start to fail and then restart.  
Use **kubectl describe pods liveness-exec** to see what's going on.


