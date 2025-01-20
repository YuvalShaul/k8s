### A LoadBalancer Service

Phase 1

#### app deployment and service
- create a python app that uses flask
- there is one query: get a sequence number
- Close it in a docker image
- upload to dockerhub

#### Service
- create a load-banalcer service for it
- It should work if replicas = 1
  raise replicas=3 and you get mix of numbers

Phase 2

#### redis sequence
- Create a redis deployment
- 1 replica
- make sure it runs always in the same node
- image  redis:6
- create a volume for it to run