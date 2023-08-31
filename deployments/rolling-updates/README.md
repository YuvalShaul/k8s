# Rolling Updates

Use this lab we'll demonstrate using rolling updates with k8s Deployments.

- [Create a dployment](#Create-a-dployment)
- [Rollout a good change](#Rollout-a-good-change)
- [Rollout a bad change](#Rollout-a-bad-change)
- [Rollback](#Rollback)

## Create a dployment

- Use the **my-deployment.yaml** file from this lab to create a new deployment:  
**kubectl apply -f my-deployment.yaml --record=true**
- Verify that the Deployment and the pods were created:  
**kubectl get deployments**  
**kubectl get pods**
- View the ReplicaSet objects that were created:  
**kubectl get rs**

## Rollout a good change

- Edit the deployment configuration file and change the image version to nginx:1.19.2  
- Apply:
**kubectl apply -f my-deployment.yaml --record=true**  
- Try to follow the deployment process by using the command:  
**kubectl get rs**  
(this is because the rollout is done by a new ReplicaSet that is created.)
- Once the new ReplicaSet is the only one running pods, verify the status of the rollout:  
**kubectl rollout status deployment/my-deployment**

## Rollout a bad change

- Create a new rollout by changing the image name to "badimage"  
(again, change the configuration file and apply with a --record option)
- Try to see the status chage of the ReplicaStes
- Check the status of the rollout:  
**kubectl rollout status deployment/my-deployment**  
(use ctrl-c to stop this command)
- Notice that the 2nd rollout we have done is still working, there are 3 pods running it:  
**kubectl get pods**

## Rollback

- See the details of the revision you want to rollback to:  
**kubectl rollout history deployment/my-deployment --revision=2**
- Roolbak to revision 1:  
**kubectl rollout undo deployment/my-deployment --to-revision=1**
- Use this command to see that the correct ReplicaSet is being used:  
**kubectl get rs**


