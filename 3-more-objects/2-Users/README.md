# Kubernetes Users

Use this lab to learn about k8s **normal** users.  
Use [this link](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) to read a little about users in kubernetes.

- [Reading the admin user name](#Reading-the-admin-user-name)
- [Create a new user certificates](#Create-a-new-user-certificates)
- [Create a config file for dave](#Create-a-config-file-for-dave)
- [Use the new config file](#Use-the-new-config-file)

## Reading the current user name

After creating your cluster (using **minikube start** command) you'll have:
- **CA (certificate authority) files**:
  - **ca.key** a private key used by the cluster certification authority.
  - **ca.crt** file, the signed public key for the CA (self signed)
  - **ca.pem** same as ca.crt but a different format
  - look for those under ~/.minikube on your host running minikube
- **Current User files** 
  - Use: **kubectl config view** to see this (scroll to the end)
  - Generally this is: 
    - client.crt
    - client.key
    - These are ~/.minikube/profiles/<profile>
  - You can read the use name with:
    - **openssl x509 -in ~/.minikube/profiles/<profile>/client.crt -text -noout**  
    (and look for the CN)
    or with
    kubectl auth whoami
    - In my case it was: **minikube-user**
  - In the cluster (control-plane node) these are stored in /etc/kubernetes/admin.conf with blended with other users.


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

