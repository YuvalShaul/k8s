# Service Exercise

In this exercise you will create a kubernetes service.  
You will:  
- [Create a simple python web application](#Create-a-simple-python-web-application)
- [Dockerize your server application](#Dockerize-your-server-application)
- [Deploy your app to your local minikube kubernetes cluster](#Deploy-your-app-to-your-local-minikube-kubernetes-cluster)



## Create a simple python web application

Create a simple python web application:  
- Use Flask
- Your application should serve a single web page.
- The single web page should identify the replying server hostnme  
(explore **uname -a** command)
- Example:  
<h3> Greetings !!! </h3>
This is your server answering from server-deployment-1-779cc696cf-54p77
- **Make sure your code is saved in github**


## Dockerize your server application

- Create a Dockerfile (also saved in github)
- build and tag your image
- Try to use your images locally
- Upload your images to dockerhub

## Deploy your app to your local minikube kubernetes cluster

- Create the necessary yaml files
- Files should be part of your github project
- Deploy your code using **kubectl** commands
- Make sure deployment works even if image is deleted  
(so image is downloaded from dockerhub)

