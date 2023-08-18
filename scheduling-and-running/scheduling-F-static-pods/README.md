# 21 - Static pods

Use this lab we'll demonstrate static pods.

- [Create a static pod](#Create-a-static-pod)

## Create a static pod

- Look at the **my-static-pod.yaml** file from this lab.  
It can create a static pod if put in the correct place inside one of your nodes.
- Connect into one of you nodes:  
**ssh osboxes@192.168.122.12**
- edit a new file inside the default pod manifest location.  
Since we have used kubeadm to create our cluster:  
**sudo vi /etc/kubernetes/manifests/my-static-pod.yaml**
- Fiil this file with the simple pods definition from **my-static-pod.yaml** in this lab.
- Wait a little, and you'll be able to see the mirror pod created in k8s.  
Get a list of pods from your host machine:  
**kubectl get pods**
- Try to delete the pods to see what happens.
- Go back to your node and delete the manifest file you have created.
- If you don't want to wait for kubelet to detect the file removal, you can restart kubelet:  
**sudo systemctl restart kubelet**
