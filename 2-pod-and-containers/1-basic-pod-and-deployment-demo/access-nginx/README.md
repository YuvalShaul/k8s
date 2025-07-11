# Access NGINX lab

### Instructions:
- Create a pod running nginx (use a yaml file and apply) called **nginx-pod**
- Create another pod based on alpine with curl abilities. If you have to, create your own image and upload into dockerhub. Call it **user-pod**  
  - **Note: if your user pod tries to run sh, then it will exit immediatelly, because it does not have a terminal!!!**
  - In docker you would use **-dit** tomake it "last" without a terminal.  
  In a k8s pod, add these lines inside the container specifications:  
     ```
      stdin: true 
      tty: true
    ```
- After both pods are running, exec into the container running alpine inside the user-pod.
- From there, use curl to access the web server inside nginx-pod.
- How would you get the ip address of the nginx-pod?