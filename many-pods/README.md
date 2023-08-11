# Many PODS Lab

Use this lab to get some hands-on experience with kubectl commands.

- [preparations](#preparations)
- [experiment with kubectl](#experiment-with-kubectl)
- [JSONPATH](#jsonpath)
- [sort-by](#sort-by)
- [selector](#selector)

## preparations

create the following deployments:
- **kubectl apply -f many-pods1.yaml**
- **kubectl apply -f many-pods2.yaml**

## experiment with kubectl

- Get a list of pods:  
**kubectl get pods**
- Get a wider description for each pod (including the node this pod is running on):  
**kubectl get pods -o wide**
- Get a single pod:  
**kubectl get pods busybox-deployment-......**  (pick one of your pods from the last command)  
- Explore the json format you get from this pod:  
**kubectl get pods busybox-deployment-.... -o json**  
It is not very readable...  
In the next section we'll see how to get some usefull info from it.

## jsonpath

The jsonpath language can be used to select parts of the json output.  
It was inspired by XPath, a similar language for 
The closest document to a standard for jsonpath can be found [here](https://goessner.net/articles/JsonPath/).  
You can use [this](https://docs.oracle.com/cd/E60058_01/PDF/8.0.8.x/8.0.8.0.0/PMF_HTML/index.htm#t=JsonPath_Expressions.htm%23Path_Examplesbc-4&rhtocid=10.2.0_4) guide as well.  

- Try:  
**kubectl get pods -o jsonpath='{$}'**  
Notice that the result is for multiple items, and you get a single json object with an "items" property.
- Try:
**kubectl get pods -o jsonpath='{$.items}'**
(now the result is an array)
- Try:  
**kubectl get pods -o jsonpath='{$.items[1]}'**  
(and this is a sinle pod)
- Try:  
**kubectl get pods -o jsonpath='{$.items[-1]}'**  
We get the last item..this is python syntax
- Use a jsonpath to view specific data from the json output:  
**kubectl get pods -o jsonpath='{$.items[0].spec.nodeName}'**  
(you should get the node name the pod is running at)
- Now, let's get nodeName for all pods:  
**kubectl get pods -o jsonpath='{$.items[*].spec.nodeName}'**  
- A nice one using the jsonpath range operator (see [here](https://pwittrock.github.io/docs/user-guide/jsonpath/) for more information).  I will show pod/name in a line and uses line breaks:  
**kubectl get pods -o jsonpath='{range .items[*]} {.metadata.name}{.spec.nodeName}{"\n"}{end}'**

## sort-by

A similar syntax can be used to sort our input:  
**kubectl get pods -o wide  --sort-by spec.nodeName**  
Compare with the output when not sorted:  
**kubectl get pods -o wide**


## selector

- Filter your output by using --selector option.  
This one works just on labels:  
**kubectl get pods --selector=app=busybox-1**

Find more options in the documentation:
- https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-strong-getting-started-strong-
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/

