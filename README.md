# Ubuntu container - developing environment

Basic ubuntu container with the following packets:

* OpenMPI
* open ssh server (listening at port 22 and 2022)
* nano

## Interactive run 
````bash
docker run -it ubuntu_mpi
````

## Docker push
````bash
docker tag misterbigthor/ubuntu_mpi:latest your_tag

docker push misterbigthor/ubuntu_mpi:your_tag
````

## Docker compose example
````bash
docker-compose up
````