# Access NGINX lab

### Instructions:
- Create a pod running nginx (use a yaml file and apply) called **nginx-pod**
- Create another pod based on alpine with curl abilities. If you have to, create your own image and upload into dockerhub. Call it **user-pod**
- After both pods are running, exec into the container running alpine inside the user-pod.
- From there, use curl to access the web server inside nginx-pod.
- How would you get the ip address of the nginx-pod?