(see a post covering this material [here](https://www.yuval.guide/k8s/objects/labels-and-selectors/))

# Labels and Selectors

In this lab we are going to experience the use of labels and selectors.


- [create some pods](#create-some-pods)
- [use equality-based selectors](#use-equality-based-selectors)
- [use set-based selectors](#use-set-based-selectors)
- [some complex examples](#some-complex-examples)

## Create some pods

- Create some pods by applying the **pods-with-labels.yaml** file from this lab:  
**kubectl apply -f pods-with-labes.yaml**
- List pods to see what you've got:  
**kubectl get pods**  
You should have 9 pods:   3 applications (a, b, c),  3 releases (1, 2, 3)


## Use equality-based selectors

- List only pods from app b:  
**kubectl get pods --selector=app.k8s.io/name==appB**  
try also with one equation mark:  
**kubectl get pods --selector=app.k8s.io/name=appB**  
- List only pods NOT from app b:  
**kubectl get pods --selector=app.k8s.io/name!=appB**
- The **,** (comma operator) acts as a logical AND operation.  
There is NO logical OR opration.  
Try the following:  
**kubectl get pods --selector=app.k8s.io/name==appB,app.k8s.io/release==3**  
(this should give you a single app=B and release=3 pod)

## Use set-based selectors

- Select all pods that are in the (appB, appC) set:  
**kubectl get pods --selector="app.k8s.io/name in (appB, appC)"**
- Select all pods that are NOT in the (appB, appC) set:  
**kubectl get pods --selector="app.k8s.io/name notin (appB, appC)"**
- Select all of these pods that HAVE the single "nice" label:  
**kubectl get pods --selector=nice**
- Select all of these pods that DO NOT have the label "nice:  
**kubectl get pods --selector='!nice'**  
(notice we have used a single quotation mark. See [single quote](https://www.gnu.org/software/bash/manual/html_node/Single-Quotes.html) for bash.)

## Some complex examples

- Try these (what do they do?):  
**kubectl get pods --selector="app.k8s.io/name in (appB, appC), app.k8s.io/release in ("1", "2")"**  
**kubectl get pods --selector="app.k8s.io/name in (appB, appC), app.k8s.io/release==3"**  
**kubectl get pods --selector='!nice',app.k8s.io/release==3**  
**kubectl get pods --selector='!nice',"app.k8s.io/name notin (appB)"**