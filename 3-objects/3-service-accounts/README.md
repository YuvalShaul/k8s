# 10 - Service Accounts

In this lab we are going to create service accounts.


- [Create a service account](#Create-a-service-account)
- [See token from the service account](#See-token-from-the-service-account)
- [Create a pod with this sa](#Create-a-pod-with-this-sa)

## Create a service account

- Look at the **sa.yaml** file in this lab.  
It describes a service account object with the name **my-sa**.
- Create the service account by applying this file:  
**kubectl apply -f sa.yaml**

## See token from the service account

- Use this command to see the token set by the service account:  
**kubectl describe sa my-sa**  
(search for the line starting with **Mountable secrets:**)
- If it is not there (newer version of kubernetes) you can create a token using the API:  
```
kubectl create token my-sa
```
- This token is a [JWT (Json Web Token)](https://en.wikipedia.org/wiki/JSON_Web_Token), that includes several fields.  
We can get the actual data of the secret by using this command:  
**kubectl describe secret \<secret mountable token name\>**
- Copy the base64 text of the token, and decode the JWT, by pasting it into the token field of [https://jwt.io/](https://jwt.io/).  
In the payload part of the JWT you can find the service account name.

## Create a pod with this sa

- Let's create a pod that is using the same sa (look at the **pod.yaml** in this lab):  
**kubectl apply -f pod.yaml**
- Similar information is mounted so the pods containers can also use a signed JWT with the same service account.  
Lets connect to the pods single container first:  
**kubectl exec my-pod -it -- sh**
- View the content of the mounted token that the container sees:  
**cat /var/run/secrets/kubernetes.io/serviceaccount/token**  
This data is not the same, but it is a JWT, so paste it again into [https://jwt.io/](https://jwt.io/).  
You get more information there (like the pod name), but the important thing is that you get the serviceaccount, and that the token is signed, so the pod containers can use this JWT to authenticate.

