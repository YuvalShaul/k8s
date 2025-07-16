# Kubernetes Users

Use this lab to learn about k8s **normal** users.  
Use [this link](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) to read a little about users in kubernetes.

- [Reading the admin user name](#Reading-the-admin-user-name)
- [Create a new user certificates](#Create-a-new-user-certificates)
- [Create a config file for dave](#Create-a-config-file-for-dave)
- [Use the new config file](#Use-the-new-config-file)

## Reading the admin user name

After creating your cluster (using **minikube start** command) you'll have:
- **PRIVATE KEY ONLY IN THE USER SIDE**:
  - **ca.key** a private key used by the admin user. 
  - It proves the identity of the user, so it is always in the user side - never in the cluster
  - look for it under ~/.minikube on your host running minikube
- **CERTIFICATE** in the client side based on this key which is public:
  - **ca.crt** file 
  - **ca.pem** same as ca.crt but a different format
  - This one should have a copy in the cluster, so that the cluster can authenticate the user.
  - The kubectl tool knows how to use it because **minikube start** command also updates this into ~/kube/config, so that kubectl tool uses it.
  - Use: **kubectl config view** to see this (scroll to the end)
- **CERTIFICATE** in the cluster
  - The same certificate (same public key **ca.crt**) can be found in the cluster in 
**/etc/kubernetes/admin.conf** (in the control node)
  - This file is an exact copy of the **~/.kube/config**  config file you are using with your kubectl commands.
  - This is how you can see it:
    - Open a terminal to your control node:  
    **minikube ssh -n \<node name\> -p \<profile name\>**
    - View the file:
    **vi  /etc/kubernetes/admin.conf** (you may need to run this with sudo)

- Let's read the details inside the certificate:
  - Use the following command on your client side:  
  **openssl x509 -in .minikube/ca.crt -text -noout**
  - The subject CN is the "user name"



## Create a new user certificates

- First, we need to get the root certificate and key for our Kubernetes clusters.  
Since the private key (ca.key) should not be moved outsite of the control node, we can do the whole thing in the control node, in the certs directory.
- Use the following commands at the control node:
  - ssh -p <cluster-name> -n <control node name>  
  example:  **ssh -p four -n four**
  - **sudo su**
  - **/var/lib/minikube/certs/**
  - Looking at this directory I can find:
    - **ca.crt** (the Certificate Authority certificate/public key)
    - **ca.key** (the ca private key)
  - I'm going to create the new user 'dave'.  
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
    - minikube cp  four:/tmp/dave.crt  /home/osboxes/.kube/ca.crt  -p four
    minikube cp  four:/tmp/dave.key  /home/osboxes/.kube/ca.crt  -p four
    minikube cp  four:/tmp/ca.crt  /home/osboxes/.kube/ca.crt  -p four
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

