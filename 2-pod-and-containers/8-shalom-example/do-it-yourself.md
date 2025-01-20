
## Try it yourself


Phase A
1. Create a directory for an application (in your host).
2. Create a python virtual environment in it.
3. Activate the local environment.
4. Install flask using pip
5. Create a simple flask application (that listens to all ip addresses)
6. Create a requirements.txt file (pip freeze)
7. Test you app locally (use curl or a browser)

Phase B

8. Create a requirements.txt file
9. Create a Dockerfile that will create an image for you app
10. Run a local container from you image and test app again
   (don't forget to map ports correctly..)

Phase C  

11. Create a personal repository in dockerhub
12. Push you image there
13. Delete all local images, and run container from remote registry

Phase D  

14. Create a pod that refers to your image, and runs it.  
    It should create a pod that will use your image.  
15. Create another pod to be able to connect to your application pod:  
    - Use alpine
    - apk update
    - apk add curl
16. Test (using curl) that your app pod returns a correct answer.
