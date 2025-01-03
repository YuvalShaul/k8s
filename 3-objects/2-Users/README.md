# 8 - Users

Use this lab to learn about k8s **normal** users.  
Use [this link](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) to read a little about users in kubernetes.

- [Reading the admin user name](#Reading-the-admin-user-name)
- [Create a new user certificates](#Create-a-new-user-certificates)
- [Create a config file for dave](#Create-a-config-file-for-dave)
- [Use the new config file](#Use-the-new-config-file)

## Reading the admin user name

After creating your cluster (using **kubeadm**) you'll have this file:  
**/etc/kubernetes/admin.conf** just on your control node(s).  
This file is an exact copy of the **~/.kube/config**  config file you are using with your kubectl commands.

- Open a terminal to your control node:  
**minikube ssh -n <node name> -p <profile name.**
- Edit the file (use sudo) and copy the **client-certificate-data** part of this file.  
Make sure you copy just the base64 part, nothing else.
- Paste this into a new file called cert64
- Use the base64 tool to convert it:  
**base64 -d cert64 > cert-text**
- Now use **openssl** to read the certificate:  
**openssl x509 -in cert-text  -noout -text**
- The user name is taken from the **Subject** field:  
**Subject: O = system:masters, CN = kubernetes-admin**  
so the **CN (Common Name)** is used by kubernetes as the user name.


## Create a new user certificates

- First, we need to get the root certificate and key for our Kubernetes clusters.  
Since the private key (ca.key) should not be moved outsite of the control node, we can do the whole thing in the control node, in the pki directory.
- Use the following commands at the control node:
  - **sudo su**
  - **cd /etc/kubernetes/pki**
  - Looking at this directory I can find:
    - **ca.crt** (the Certificate Authority certificate/public key)
    - **ca.key** (the ca private key)
  - I'm going to create the user 'dave'.  
  Create a directory called "dave" and cd into it. Also copy ca files into it:  
    - **mkdir dave**
    - **cd dave**
    - **cp ../ca.\*  .**
  - Create a private key for dave:  
  **openssl genrsa -out dave.key 2048**  
  (there should be now a file called dave.key)
  - Now create a csr (Certificate Signing Request), to prepare everything needed to the actual certificate creation.  
  Note that this is where we set the user name (and also the group name):    
  **openssl req -new -key dave.key -out dave.csr -subj "/CN=dave/O=developers"**
  - Now, to the actual signing of the certificate:  
  **openssl x509 -req -in dave.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out dave.crt -days 3540**
  - We can remove the files now not needed:  
    - **rm dave.csr**
    - **rm ca.srl**
  - Im changing the file permissions for these files (so I can copy them):  
  **chmod 777 dave.\***
  - Go into my host computer, and copy the files:
    - **cd ~/.kube**  
    - **scp osboxes@192.168.122.10:/etc/kubernetes/pki/dave/dave.crt .**
    - **sudo scp osboxes@192.168.122.10:/etc/kubernetes/pki/dave/dave.key .**
    - **scp osboxes@192.168.122.10:/etc/kubernetes/pki/ca.crt .**
  - Change file permissions:  
    - **chmod 000 dave.key**
    - **chmod 644 dave.crt**
  - remove the files from the control node:  
  **cd ..**  
  **rm -rf dave**
  - Convert the files to base64, and save in environment variables:  
    - **CLIENT_CRT_BASE64=$(base64 -w 0 dave.crt)**
    - **CLIENT_KEY_BASE64=$(sudo base64 -w 0 dave.key)**
    - **CA_CRT_BASE64=$(base64 -w 0 ca.crt)**  
    (the **-w 0** options eliminate line-wrapping, and creates a single line - which is what we need)



## Create a config file for dave

- Use the following config template to create a new file called **daveconfig**:

      apiVersion: v1  
      current-context: dave@kubernetes  
      preferences: {}  
      clusters:  
      - cluster:  
          certificate-authority-data: CA_CRT  
          server:  https://192.168.122.10:6443
        name: kubernetes  
      contexts:  
      - context:  
          cluster: kubernetes  
          user: dave  
        name: dave@kubernetes  
      kind: Config
      users:  
      - name: dave
        user:  
          client-certificate-data: CLIENT_CRT  
          client-key-data: CLIENT_KEY  

- Fill this file with the 3 base64 textx you have created before.  
**Make sure you get no new lines added !!!**  
**Notice that VSCODE adds spaces instead of those new lines. Remove these !!!**
- Copy **daveconfig** into .kube directory:  
**cp daveconfig ~/.kube**

## Use the new config file

- Create some pods (using the admin user)
- Here's what happens if you try to list the pods (once using the admin user, then using dave):  

      > kubectl get pods
      NAME                            READY   STATUS    RESTARTS      AGE
      my-deployment-56474dbc6-gxpbd   1/1     Running   2 (34h ago)   3d5h
      my-deployment-56474dbc6-jln9h   1/1     Running   2 (34h ago)   3d5h
      my-deployment-56474dbc6-shfpn   1/1     Running   2 (34h ago)   3d5h
      > 
      > kubectl get pods --kubeconfig .kube/daveconfig 
      Error from server (Forbidden): pods is forbidden: User "dave " cannot list resource "pods" in API group "" in the namespace "default"
      > 

