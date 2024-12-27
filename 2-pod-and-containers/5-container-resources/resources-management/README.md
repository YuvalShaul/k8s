# Resource - Management

In this lab we are going to demonstrate resource requests and limits.

- [Too many cpus required](#Too-many-cpus-required)
- [Too much memory required](#Too-much-memory-required)

## Too many cpus requested

- Look at **big-cpu-pod.yaml** from this lab.  
These are the requirements of this pod:
  - memory: "50M", which means 50 mega bytes (50 * 10^6 bytes)  
  We could also use: "50Mi" which means 50 **mebi** (50 * 2^20 bytes)
  - cpu: 60 cpu units (so 60 virtual cpus)  
  Of course, we only have 2 virtual cpus in the control node.
  - Try to apply this file and create the pod:  
  **kubectl apply -f big-cpu-pod.yaml**
  - Use **kubectl get pods** and **kubectl describe pods** to see what happened.
  - Learn more about prefixes used to describe these quantities:
    - [prefixes for decimal SI units](https://physics.nist.gov/cuu/Units/prefixes.html)
    - [prefixes for binary multiples](https://physics.nist.gov/cuu/Units/binary.html)
  
## Too much memory requested

- Look at **big-mem-pod.yaml** from this lab.  
These are the requirements of this pod:
  - memory: "64Gi", which means 64 gibi bytes (64 * 2^30 bytes)  
  - cpu: 250m so 250 mili cpu units, or 0.25
  - Try to apply this file and create the pod:  
  **kubectl apply -f big-mem-pod.yaml**
  - Use **kubectl get pods** and **kubectl describe pods** to see what happened.

## Limiting resources

- Look at the **pod-to-limit-cpu.yaml**  
There a 200m cpu limit there, but it it commented out.
- Run this pod by applying it:  
**kubectl apply -f pod-to-limit-cpu.yaml**
- Exec into the pod and run a load in it:
  - **kubectl exec -it pod-to-limit-cpu -- sh**
  - Inside the shell:  
  **for i in 1 2 3 4; do while : ; do : ; done & done**
  - Monitor from another window:  
**kubectl top pods**
  - You should see that the cpu usage is rising to almost 1000m (one complete cpu)
- Delete the pod, uncomment the limit lines, and re-create the pod.  
Now the cpu usage should not exceed 200m (as configured).