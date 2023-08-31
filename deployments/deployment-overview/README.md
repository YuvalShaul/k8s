# Deployments Overview

Use this lab we'll demonstrate the creation of deployments.

- [Create a dployment](#Create-a-dployment)
- [Scale by using the configuration file](#Scale-by-using-the-configuration-file)
- [Scale by directly editing the Deployment configuration](#Scale-by-directly-editing-the-Deployment-configuration)
- [Scale by using the kubectl scale command](#Scale-by-using-the-kubectl-scale-command)

## Create a dployment

- Use the **my-deployment.yaml** file from this lab to create a new deployment:  
**kubectl apply -f my-deployment.yaml**
- Verify that the deployment and the pods were created:  
**kubectl get deployments**  
**kubectl get pods -o wide**

## Scale by using the configuration file

- Edit **my-deployment.yaml** file, and change **replicas** to 5
- Apply the file
- See the results by checking the number of pods.

## Scale by directly editing the Deployment configuration

- Edit the deployment configuration:  
**kubectl edit deployments my-deployment
- Act as if you are editing a file using vi(m).  
Change **replicas** to 19, save and exit.
- See results.

## Scale by using the kubectl scale command

- Scale doen:  
**kubectl scale deployment.v1.apps/my-deployment --replicas=2**
- See results
