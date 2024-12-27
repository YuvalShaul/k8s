# Init Containers

In this lab we will demonstrate **init containers**.

- Look at **init-containers-pod.yaml** file from this lab.
- It defines a pod with 2 init containers and 1 app container.
- Apply the file and then monitor it while the init continers are running:
  - **kubectl apply -f init-containers-pod.yaml**
  - **kubectl get pods**
  - Repeat the last command several times, until the pod goes to a running state.
     - first the **first init container** runs, and the statuse of the pod is: Init:0/2
     - then the second **first init container** runs, and the statuse of the pod is: Init:1/2
     - Only then, the main app container starts to work, , and the statuse of the pod is: PodInitializing
     - Then, the pod is in a Running state
- Don't forget to delete your pod, so that you're ready for other experiments.