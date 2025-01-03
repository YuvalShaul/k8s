# Custom Resource Definitions 

In this lab we are going to create and use a CustomResourceDefinitions (CRD) resource.  
We will not demonstrate how to add a controller to it here.  
For more details:  
 https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions

- [Create your CRD](#Create-your-CRD)
- [Create a WebSite object](#Create-a-WebSite-object)

## Create your CRD

- Consider the website.yaml file from this lab.  
It defines a new kind of objects to kubernetes.  
The idea is that a user can create a "website" object, specify some required details, and  
a later defined controller will create other required object, e.g a deployment and a service  
required to create a web site.  
(note: this lab just demonstrates the creation of the CRD, and the creation of websites objects.)
- Go over the comments in the file, to understand how we create the CRD and the meaning of its fields.
- Use:  
**kubectl get crd**  
to see what other CRD objects already exist.
- Create the CRD:  
**kubectl apply -f website.yaml**  
and verify that it was created.

## Create a WebSite object

- Look at the **site1.yaml** file from this lab.  
It defines an object of the WebSite kind.
- Use:  
**kubectl apply -f site1.yaml**  
to create a WebSite object.
- Use:  
**kubectl get websites**  
to verify that the object exists.
- Use:  
**kubectl describe websites**  
to see the details (including the properties that were defined).
- Use:  
**kubectl delete websites site-one**  
to delete.
