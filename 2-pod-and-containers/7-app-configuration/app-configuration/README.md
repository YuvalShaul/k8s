(see a post covering this material [here](https://www.yuval.guide/k8s/objects/app-configuration/))
# Application Configuration

In this lab we are going to use a configmap.

- [Start with a bad pod](#Start-with-a-bad-pod)
- [Create a configmap](#Create-a-configmap)
- [Create a secret](#Create-a-secret)
- [Use the configmap and secret in a pod using environment variables](#Use-the-configmap-and-secret-in-a-pod-using-environment-variables)
- [Use the configmap and secret in a pod using volumes](#Use-the-configmap-and-secret-in-a-pod-using-volumes)


## Start with a bad pod

Before we look at configmaps and secrets, let's see the problem they solve.

- Look at the **bad-pod.yaml** file in this lab.  
It is an ordinary pod that needs two pieces of configuration and a password -
and all of them are hardcoded right there in the pod spec.
- Create the pod:  
**kubectl apply -f bad-pod.yaml**
- Exec into the pod:  
**kubectl exec -it bad-pod -- sh**
- The application gets its configuration just fine:  
**echo $CONFIGMAP_VAR**  
**echo $SECRET_VAR**  
From inside the container this pod looks perfectly healthy. The problems are all
outside of it.

### Why this is bad

- **The password is in plain sight.** Ask the cluster to describe the pod:  
**kubectl describe pod bad-pod**  
The Environment section prints **SECRET_VAR: mypassword** and the full database
connection string. The same is true for:  
**kubectl get pod bad-pod -o yaml**
- **Anyone who can read pods can read the password.** Reading pods is something
you hand out freely - it is how people debug. Here it hands out the credentials
with it.
- **The password ends up in git.** The pod spec is a file you commit. Once a
password is committed it is in the history of every clone of the repository,
forever - even after you "remove" it in a later commit.
- **Configuration is duplicated.** Every pod, deployment and job that needs that
password holds its own copy. Rotating it means finding and editing all of them,
and re-deploying all of them.
- **You cannot reuse the manifest across environments.** The same file cannot be
applied to dev, staging and production, because the values are part of it.
- **Changing a value forces a change to the pod spec.**

What we want instead is to keep the configuration **outside** the pod spec, in
its own object, and have the pod refer to it. That is what the rest of this lab
does: a **configmap** for plain configuration, and a **secret** for the
password.

- Delete the bad pod:  
**kubectl delete -f bad-pod.yaml**

## Create a configmap

- Look at the **my-configmap.yaml** file from this lab.  
It defines a [configmap object](https://kubernetes.io/docs/concepts/configuration/configmap/#configmap-object) called my-configmap.
- How did we get the base64 value attached to **binaryData** ?  
type:  
**echo "hello world" | base64**  
- Create this configmap using the following command:  
**kubectl apply -f my-configmap.yaml**  
- Verify that the configmap has been created:  
**kubectl get configmaps**
- Look at the details of this configmap:  
**kubectl describe configmap my-configmap**  

## Create a secret

- Look at the **my-secret.yaml** file in this lab.
- Here's how I get my secret encoded as base64:  
**echo 'mypassword' | base64**
- Create the secret:  
**kubectl apply -f my-secret.yaml**
- Verify that the secret was created:  
**kubectl get secrets**

> A secret is only **base64 encoded**, not encrypted - anyone who is allowed to
> read the secret can decode it. It is still much better than the bad pod: the
> value is a separate object with its own RBAC rules, it is kept out of the pod
> spec, and the cluster can be configured to encrypt secrets at rest.

## Use the configmap and secret in a pod using environment variables

- Create a pod by applying the **envvar-pod.yaml** file in this lab:  
**kubectl apply -f envvar-pod.yaml**
- Notice the lines in the envvar-pod.yaml file that refer to the configmap and secret
- Exec into the pod:  
**kubectl exec -it envvar-pod -- sh**
- Access the environment variable to see the value from the **configmap**:  
**echo $CONFIGMAP_VAR**
- Access the environment variable to see the value from the **secret**:  
**echo $SECRET_VAR**
- The container sees exactly what the bad pod saw - but now look at the pod from
the outside:  
**kubectl describe pod envvar-pod**  
The Environment section prints only
**SECRET_VAR: \<set to the key 'pass' in secret 'my-secret'\>** - the value
itself is no longer exposed.

## Use the configmap and secret in a pod using volumes

- Create a pod by applying the **volume-pod.yaml** file in this lab:  
**kubectl apply -f volume-pod.yaml**
- Exec into the pod:  
**kubectl exec -it volume-pod -- sh**
- Your data is in the mount points:  
  - **/etc/config/configmap** is a directory with a file for each key. The file name is the key, and the content of the file is the value.
  - **/etc/config/secret** uses the same pattern for secrets.
  - Use **cat** to see the content of these files.
- Unlike the bad pod, updating the secret updates the file inside the running
container - no change to the pod spec is needed.
