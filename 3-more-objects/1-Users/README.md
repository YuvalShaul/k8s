# Kubernetes Users

Use this lab to learn about k8s **normal** users.  
Use [this link](https://kubernetes.io/docs/reference/access-authn-authz/authentication/) to read a little about users in kubernetes.

- [Intro to Kubernetes Users](#Intro-to-Kubernetes-Users)
- [Reading the admin user name](#Reading-the-admin-user-name)
- [Create a new user certificates](#Create-a-new-user-certificates)
- [Create a config file for dave](#Create-a-config-file-for-dave)
- [Use the new config file](#Use-the-new-config-file)

## Intro to Kubernetes Users

- In Kunernetes, **normal users** almost always use X.509 certificates.
- Note that kubernetes does not have a "User" object. 
- Instead:
**Kubernetes trusts anyone who shows up with a certificate signed by the cluster’s Certificate Authority (CA).**


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
    - **openssl x509 -in ~/.minikube/profiles/\<profile\>/client.crt -text -noout**  
    (and look for the CN)
    or with
    kubectl auth whoami
  - Command parameters:

| Parameter | Purpose |  
| :--------- | :----------- |  
| x509 | Tells OpenSSL to use the display and utility tool for X.509 certificates (the standard format for public key certificates).|  
|-in <path> | "Specifies the input file. In this case, you are pointing to the specific certificate Minikube generated for your local kubectl client."|
|-text |"Translates the certificate from ""computer-speak"" (DER/Base64) into human-readable text. Without this, you’d just see a wall of random characters."|
|-noout | Prevents the command from printing the encoded version of the certificate at the end. It keeps your terminal clean so you only see the decoded text.|
    - In my case it was: **minikube-user**
  - In the cluster (control-plane node) these are stored in /etc/kubernetes/admin.conf with blended with other users.


## Create a new user certificates

- First, we need to get the root certificate and key for our Kubernetes clusters.  
Since the private key (ca.key) should not be moved outsite of the control node, we can do the whole thing in the control node, in the certs directory.
- Use the following commands at the control node:
  - ssh -p <cluster-name> -n <control node name>  
  example:  **minikube ssh -p four -n four**
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
    - **minikube cp  four:/var/lib/minikube/certs/dave/dave.crt  /home/osboxes/.kube/dave.crt  -p four**  
    **minikube cp  four:/var/lib/minikube/certs/dave/dave.key  /home/osboxes/.kube/dave.key  -p four**  
    **minikube cp  four:/var/lib/minikube/certs/dave/ca.crt  /home/osboxes/.kube/ca.crt  -p four**  
    (each file needs its own destination name - giving them all the same target would overwrite one with the next)
  - Change file permissions:  
    - **chmod 600 dave.key**
    - **chmod 644 dave.crt**  
    (the key must stay readable by its owner - with 000 even you cannot read it, and kubectl fails with a permission denied error)
  - remove the files from the control node:  
  **cd ..**  
  **rm -rf dave**


## Create a config file for dave

Dave now has certificates, but no way to tell kubectl to use them. That is what a **kubeconfig** file is for.  
A kubeconfig file is just YAML, so you could write it by hand - but pasting three long base64 blobs into a template is error prone (editors love to wrap them or turn the wrapping into spaces).  
Instead, let **kubectl** build the file for you. Every **kubectl config** command accepts a **--kubeconfig** flag, saying which file to write to, and if that file does not exist it is created.

- Make sure you are where the certificate files are:  
**cd ~/.kube**
- Read your cluster's address - every cluster gets a different one, so do not hard-code it:  
**API_SERVER=$(kubectl config view -o jsonpath='{.clusters[?(@.name=="four")].cluster.server}')**  
(on the docker driver mine was **https://192.168.49.2:8443**)
- Add the cluster - **where** to connect, and the CA certificate used to verify the API server:  
**kubectl config set-cluster kubernetes \\**  
&nbsp;&nbsp;**--server="$API_SERVER" \\**  
&nbsp;&nbsp;**--certificate-authority=ca.crt --embed-certs=true \\**  
&nbsp;&nbsp;**--kubeconfig=daveconfig**
- Add the user - **who** dave is, the certificate and key we just created for him:  
**kubectl config set-credentials dave \\**  
&nbsp;&nbsp;**--client-certificate=dave.crt --client-key=dave.key --embed-certs=true \\**  
&nbsp;&nbsp;**--kubeconfig=daveconfig**
- Add a context - a cluster + user pair:  
**kubectl config set-context dave@kubernetes \\**  
&nbsp;&nbsp;**--cluster=kubernetes --user=dave \\**  
&nbsp;&nbsp;**--kubeconfig=daveconfig**
- Make it the current context:  
**kubectl config use-context dave@kubernetes --kubeconfig=daveconfig**
- **--embed-certs=true** writes the **contents** of the certificate files into the config file, base64 encoded, instead of their paths - so the file works even if the certificates are moved. It also does the encoding for us, so there is no need to run **base64 -w 0** on anything, and no newline/whitespace problems to worry about.
- Check the result:  
**kubectl config view --kubeconfig=daveconfig**
- The next lab is all about these **kubectl config** commands and the file they wrote - what is inside it, and how to switch between users and clusters without typing **--kubeconfig** every time.

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
      Error from server (Forbidden): pods is forbidden: User "dave" cannot list resource "pods" in API group "" in the namespace "default"
      > 

