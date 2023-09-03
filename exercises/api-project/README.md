# API Project

In this project you will create a WEB API made of 2 services and deploy it to kubernetes.


- [General project description](#General-project-description)


## General project description

- You will be creating a WEB API about books and authors.
- Here are some examples of using it:
  - get /
     returns a short intro message
  - get /author/Dan
        will return a record with Dans description + list of all book names written by Dan
        (or an error message if ther is author by that name)
  - get /book/the_wind_in_the_wollow 
        will return BOOK details (with author inside it)
        (or an error message if there is no such book)

## Implementation Highlights

- The source of data will be a single JSON file, containing all information.
You should design the internal structore of this file.
- You should be using [FastAPI](https://fastapi.tiangolo.com/) to create the API  
- [a good source to learn FastAPI](https://realpython.com/fastapi-python-web-apis/#create-a-first-api)
- You should be creating 2 programs, sharing the single data file:
  - one program will implement / and /author
  - the other program will implement /book
- Each program should be packed inside a single docker image
- Each images should be uploaded to its own repository (inside the same account) in dockerhub
- Each program will be run inside kubernetes in its own ClusterIP service, over more than a single pod
- Use an ingress to create a single API from these two services.
