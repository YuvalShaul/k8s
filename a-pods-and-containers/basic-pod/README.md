# Basic Pods: Getting to know pods

In this lab you will create pods and delete them.

## Apply a pod yaml file

- Create a pod by running the following command:  
**kubectl apply -f basic-pod.yaml**
- Verify that a pod was created:  
**kubectl get pods**
- Look at the basic-pod.yaml file from this lab:  
  - Note that the **kind** of the object to be created is a Pod
  - Note that the pod has some metadata, and that the pod name is part of it.
  - Note that there is a **spec** (specification) to the Pod, which describes how it should be created.
  - About this pod spec:
    - the spec specify a list of containers
    - there is exactly ONE container in this list
    - About this container:
      - It's name is nginx
      - we have the image it is running
      - it exposes