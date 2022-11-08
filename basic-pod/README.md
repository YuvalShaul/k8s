# Basic Pods: Getting to know pods

In this lab you will create pods and delete them.

## Create a pod manually

- You can create a pod using a single cli command.  
Try this:  
**kubectl run my-pod --image=nginx**
- Use **kubectl get pods** to see that your pod is running.  
(this may take several seconds)
- While this is an option, it'll be harder to pass more options to create more complex pods.  
It could be better to create a pod definition file.
- Delete the pods, so that you're ready for the next Pod you'll create:  
**kubectl delete pods my-pod**

## Apply a pod yaml file

- Create a pod by running the following command:  
**kubectl apply -f basic-pod.yaml**
- Verify that a pod was created:  
**kubectl get pods**
- Look at the basic-pod.yaml file from this lab:  
  - Note that the **kind** of the object is: **Pod**
  - Note that the pod has some metadata, and that the pod **name** is part of it.
  - Also in the metadata is a **label**:
    - the label's key is color
    - the label's value is blue
  - Note that there is a Pod **spec** (specification), that describes the content of the Pod.
  - About the pod **spec**:
    - the spec specify a list of **containers**
    - there is exactly ONE container in this list
    - About that container:
      - It's **name** is nginx
      - we have the image it is running: nginx:1.14.2 (s repository=nginx  and tag=1.14.2)
      - the container exposes port 80 into the internal kubernetes network

