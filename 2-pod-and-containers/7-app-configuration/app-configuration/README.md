(see a post covering this material [here](https://www.yuval.guide/k8s/objects/app-configuration/))
# Application Configuration

In this lab we are going to use a configmap.

- [Create a configmap](#Create-a-configmap)
- [Create a secret](#Create-a-secret)
- [Use the configmap and secret in a pod using environment variables](#Use-the-configmap-and-secret-in-a-pod-using-environment-variables)
- [Use the configmap and secret in a pod using volumes](#Use-the-configmap-and-secret-in-a-pod-using-volumes)
- [The bad pod - configuring a secret locally](#The-bad-pod---configuring-a-secret-locally)


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

## Use the configmap and secret in a pod using volumes

- Create a pod by applying the **volume-pod.yaml** file in this lab:  
**kubectl apply -f volume-pod.yaml**
- Exec into the pod:  
**kubectl exec -it volume-pod -- sh**
- Your data is in the mount points:  
  - **/etc/config/configmap** is a directory with a file for each key. The file name is the key, and the content of the file is the value.
  - **/etc/config/secret** uses the same pattern for secrets.
  - Use **cat** to see the content of these files.

## The bad pod - configuring a secret locally

Now let's see what happens when we **don't** use a configmap and a secret, and
configure the pod locally instead.

- Look at the **bad-pod.yaml** file in this lab.  
It does exactly what **envvar-pod.yaml** does - it gives the container a
**CONFIGMAP_VAR** and a **SECRET_VAR** - but the values are hardcoded right
there in the pod spec, next to a database connection string that carries the
password as well.
- Create the pod:  
**kubectl apply -f bad-pod.yaml**
- Exec into the pod:  
**kubectl exec -it bad-pod -- sh**
- The application sees exactly the same thing as before:  
**echo $CONFIGMAP_VAR**  
**echo $SECRET_VAR**  
From inside the container there is no difference at all. The difference is
everywhere else.

### Why this is bad

- **The password is in plain sight.** Ask the cluster to describe the pod:  
**kubectl describe pod bad-pod**  
The env section prints **SECRET_VAR: mypassword** and the full connection
string. Compare it with:  
**kubectl describe pod envvar-pod**  
which only prints **SECRET_VAR: \<set to the key 'pass' in secret 'my-secret'\>** -
the value itself is not exposed.
- **Anyone who can read pods can read the password.** With the secret, the value
lives in a separate object, so you can hand out permissions to read pods without
handing out permissions to read secrets (RBAC):  
**kubectl get pod bad-pod -o yaml**  
**kubectl get secret my-secret -o yaml**
- **The secret ends up in git.** The pod spec is a file you commit. Once a
password is committed it is in the history of every clone of the repository,
forever - even after you "remove" it in a later commit.
- **Configuration is duplicated.** Every pod, deployment and job that needs that
password holds its own copy. Rotating it means finding and editing all of them,
and re-deploying all of them.
- **You cannot reuse it across environments.** The same manifest cannot be
applied to dev, staging and production, because the values are part of it. With
a configmap and a secret, the manifest stays the same and only the objects it
references change.
- **Changing a value forces a change to the pod spec.** With a secret mounted as
a volume (see **volume-pod.yaml**), updating the secret updates the file inside
the running container - no new pod spec is needed.

### Clean up

- **kubectl delete -f bad-pod.yaml**

> Note that a Secret object is only **base64 encoded**, not encrypted - anyone
> who is allowed to read the secret can decode it. It is still much better than
> the bad pod: the value is a separate object, it is protected by its own RBAC
> rules, it is kept out of the pod spec, and the cluster can be configured to
> encrypt secrets at rest.
