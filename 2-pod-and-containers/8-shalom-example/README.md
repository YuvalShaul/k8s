
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
