
### Build your image
- When you Dockerfile is good, run a build command:
```
docker build -t <your dockerhub username>/<repositorynamt>:<tag>
```

### Usefull commands

- Run container directly on your host:  
(change to your image name and port numbers)  
```
docker run -it -p 300:5000   yuvalshaul/shalom:two
```
(not that 300 is the host port-number, and 5000 is the container port number)
- In your browser, use:
```
http://localhost:<port number>/hello/<name>
'''
(don't forget to change to the name you want, and the port number you are using)
