# kubectl config

In this lab we are going to look at the **kubeconfig** file - the file that tells **kubectl** which cluster to talk to, who to talk as, and which namespace to use.  
In the previous lab we created the user **dave** and built a config file for him with **kubectl config** commands. Here we are going to look at what those commands actually wrote, and then add dave to our **own** config as a second context - same cluster, different user.  
Use [this link](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) to read a little about organizing cluster access using kubeconfig files.

- [What is a kubeconfig file](#What-is-a-kubeconfig-file)
- [View your configuration](#View-your-configuration)
- [Clusters, users and contexts](#Clusters-users-and-contexts)
- [Switching contexts](#Switching-contexts)
- [Setting a default namespace](#Setting-a-default-namespace)
- [A second context, same cluster, different user](#A-second-context-same-cluster-different-user)
- [Using more than one config file](#Using-more-than-one-config-file)

## What is a kubeconfig file

- **kubectl** is just a client. By itself it has no idea where your cluster is, so before every command it reads a configuration file, usually **~/.kube/config**.
- Nothing in that file lives in the cluster - it is a plain YAML file on **your** machine. Deleting it does not harm the cluster, it only means your kubectl no longer knows how to reach it.
- The file has three lists, and one pointer:

| Section | Purpose |  
| :--------- | :----------- |  
| clusters | **Where** the API server is (its URL) and the CA certificate used to verify it. |  
| users | **Who** you are - a client certificate, a token, or some other credentials. |  
| contexts | A **pair**: one cluster + one user (and optionally a default namespace). |  
| current-context | Which of the contexts kubectl should use right now. |  

- So a context does not hold any credentials of its own - it just says "use this user against that cluster".
- This is the **daveconfig** file we built in the previous lab - a small config with exactly one of each (the base64 blobs are shortened here):

      apiVersion: v1
      kind: Config
      current-context: dave@kubernetes
      preferences: {}
      clusters:
      - cluster:
          certificate-authority-data: LS0tLS1CRUdJTiBD...
          server: https://192.168.49.2:8443
        name: kubernetes
      contexts:
      - context:
          cluster: kubernetes
          user: dave
        name: dave@kubernetes
      users:
      - name: dave
        user:
          client-certificate-data: LS0tLS1CRUdJTiBD...
          client-key-data: LS0tLS1CRUdJTiBS...

- Your own **~/.kube/config** has the same shape, only with more entries in each list.

## View your configuration

- Print your configuration:  
**kubectl config view**
- Notice that certificates are printed as **DATA+OMITTED** - that is kubectl hiding them, not an empty file.  
To see the real content:  
**kubectl config view --raw**  
(be careful with this one - it prints your private key to the screen)
- Look at the file itself, it is the very same thing:  
**cat ~/.kube/config**
- You can also ask for one piece of it. For example, the address of the cluster named **four**:  
**kubectl config view -o jsonpath='{.clusters[?(@.name=="four")].cluster.server}'**

## Clusters, users and contexts

- List the clusters kubectl knows about:  
**kubectl config get-clusters**
- List the users:  
**kubectl config get-users**
- List the contexts:  
**kubectl config get-contexts**  
The **\*** in the first column marks the current context. You also get the cluster, the user, and the namespace of each context:

      CURRENT   NAME   CLUSTER   AUTHINFO   NAMESPACE
      *         four   four      four

- Show only the name of the current context:  
**kubectl config current-context**
- Ask kubectl who you are (as the API server sees you):  
**kubectl auth whoami**  
(with minikube this is usually **minikube-user**)
- Every **kubectl** command accepts **--context**, so you can aim a single command somewhere else without changing anything:  
**kubectl get nodes --context=four**

## Switching contexts

- When you work with more than one cluster (minikube, a course cluster, a cloud cluster), each of them adds a cluster + user + context to the same file.
- If you have a second cluster, you already have a second context. If you do not, and you want to try this part, create a small one (this takes a while - or just skip to the next sections, where we add a second context **without** a second cluster):  
**minikube start -p small**
- Look at the contexts now - minikube added one, and made it the current one:  
**kubectl config get-contexts**
- Switch back to your other cluster:  
**kubectl config use-context four**
- Verify:  
**kubectl config current-context**  
**kubectl get nodes**
- **use-context** does exactly one thing: it changes the **current-context** line in the file. Nothing is sent to any cluster.

## Setting a default namespace

- Without a namespace in the context, kubectl uses **default** for every command, and you end up typing **-n kube-system** again and again.
- Create a namespace to try this with:  
**kubectl create namespace dev**
- Attach it to the **current** context:  
**kubectl config set-context --current --namespace=dev**
- Now this command lists the pods of the **dev** namespace:  
**kubectl get pods**
- See it in the context list (the NAMESPACE column is no longer empty):  
**kubectl config get-contexts**
- Go back to the default namespace:  
**kubectl config set-context --current --namespace=default**

## A second context, same cluster, different user

A context is only a cluster + user pair, so nothing stops us from having two contexts pointing at the **same** cluster, each one with a different user.  
Until now you worked as the admin user. Let's add dave (from the previous lab) next to him.

- Make sure dave's certificate files are still where we left them:  
**ls ~/.kube/dave.crt ~/.kube/dave.key**
- Add dave to the **users** list of your own config (note: no **--kubeconfig** flag this time - we are writing into **~/.kube/config**):  
**kubectl config set-credentials dave \\**  
&nbsp;&nbsp;**--client-certificate=$HOME/.kube/dave.crt --client-key=$HOME/.kube/dave.key --embed-certs=true**
- Command parameters:

| Parameter | Purpose |  
| :--------- | :----------- |  
| --kubeconfig \<file\> | Which file to write to. **Without it** - as here - kubectl edits your own **~/.kube/config**. The file is created if it is missing. |  
| --client-certificate / --client-key | Dave's identity - this is what the API server checks to decide who you are. |  
| --embed-certs=true | Writes the **contents** of those files into the config, base64 encoded. Without it kubectl writes the file **paths** instead, which works too but ties the config to those exact locations. |  
| --certificate-authority | (on **set-cluster**) The CA certificate - this is how kubectl verifies it is talking to the right API server. |  

- Check that he is there:  
**kubectl config get-users**
- Now create a context that uses your existing cluster with this new user:  
**kubectl config set-context dave@four --cluster=four --user=dave**  
(replace **four** with the cluster name you saw in **get-clusters**)
- Command parameters:

| Parameter | Purpose |  
| :--------- | :----------- |  
| set-context \<name\> | Creates the context, or updates it if it already exists (these commands are idempotent). |  
| --cluster | The name of an entry from the **clusters** list. |  
| --user | The name of an entry from the **users** list. |  
| --namespace | The default namespace for commands running in this context. |  
| --current | Instead of a name - edit the context that is currently in use. |  

- Look at the contexts - two of them, the same cluster in both, a different user in each:  
**kubectl config get-contexts**

      CURRENT   NAME        CLUSTER   AUTHINFO   NAMESPACE
      *         four        four      four       
                dave@four   four      dave       

- Switch to dave and try to list the pods:  
**kubectl config use-context dave@four**  
**kubectl get pods**

      Error from server (Forbidden): pods is forbidden: User "dave" cannot list resource "pods" in API group "" in the namespace "default"

- This is the same error we got in the previous lab with **--kubeconfig daveconfig** - but now switching identity is one short command instead of a flag on every command.
- Note what the error tells us: dave was **authenticated** (the cluster knows who he is - his certificate is signed by the cluster CA), he is just not **authorized** to do anything yet. We will give him permissions in the RBAC lab.
- Switch back to the admin user:  
**kubectl config use-context four**  
**kubectl get pods**
- You can also stay where you are and aim a single command at the other context:  
**kubectl get pods --context=dave@four**
- Keep the **dave@four** context - we are going to use it in the RBAC lab. When you do want to get rid of it:  
**kubectl config delete-context dave@four**  
**kubectl config delete-user dave**  
(there is also **delete-cluster**)

## Using more than one config file

- A file sitting in **~/.kube** is **not** used automatically - only **~/.kube/config** is.
- To use another file for a single command, use the **--kubeconfig** flag - this is what we did in the previous lab:  
**kubectl get nodes --kubeconfig=$HOME/.kube/daveconfig**
- To use it for the whole shell session, use the **KUBECONFIG** environment variable:  
**export KUBECONFIG=~/.kube/daveconfig**  
**kubectl config current-context**  
(you should get **dave@kubernetes** - the context daveconfig was created with)
- **KUBECONFIG** can hold several files separated by **:**, and kubectl **merges** them on the fly (the first file wins when two of them define the same name):  
**export KUBECONFIG=~/.kube/config:~/.kube/daveconfig**  
**kubectl config get-contexts**  
This is the usual way to work with a config file somebody sent you, without pasting anything into your own file - and it is the alternative to what we did above, where we copied dave into our own config instead.
- You can write the merged result into a single file:  
**kubectl config view --raw --flatten > ~/.kube/merged**
- Clean up when you are done, so kubectl goes back to **~/.kube/config**:  
**unset KUBECONFIG**

In the RBAC lab we are going to give dave some permissions, and use the **dave@four** context you just created to see them working.
