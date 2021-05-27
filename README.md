# .Net Core Sonar Scanner on Docker Container

Sonar Scanner Dockerfile for .Net Core Projects

This is based on the burakince/docker-dotnet-sonarscanner image but updated to work nicely with dotnet 3.1 and 5.0

[![Docker Pulls](https://img.shields.io/docker/pulls/alexwoollam/docker-dotnet-sonarscanner.svg)](https://hub.docker.com/r/alexwoollam/docker-dotnet-sonarscanner/) [![Docker Automated build](https://img.shields.io/docker/automated/alexwoollam/docker-dotnet-sonarscanner.svg)](https://hub.docker.com/r/alexwoollam/docker-dotnet-sonarscanner/) [![Docker Image Size](https://img.shields.io/docker/image-size/alexwoollam/docker-dotnet-sonarscanner)](https://hub.docker.com/r/alexwoollam/docker-dotnet-sonarscanner/)

## Using Example

First of all you need a sonarqube server. If you haven't one, run this code;

```
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
```

And then you need .Net Core project.

Take login token from sonarqube server, change working directory to project directory and run this code;

```
docker run --name dotnet-scanner -it --rm -v $(pwd):/project \
  -e PROJECT_KEY=ConsoleApplication1 \
  -e PROJECT_NAME=ConsoleApplication1 \
  -e PROJECT_VERSION=1.0 \
  -e HOST=http://localhost:9000 \
  -e LOGIN_KEY=CHANGE_THIS_ONE \
  alexwoollam/docker-dotnet-sonarscanner
```

Note: If you have sonarqube as docker container, you must inspect sonarqube's bridge network IP address and use it in HOST variable.

```
docker network inspect bridge
```

Works well with docker-compose, e.g. something like:
_docker-compose.sonarqube.yml_
```

version: "3.7"

services:

  sonarqube:
    container_name: sonarqube
    image: sonarqube:latest
    ports:
      - "9000:9000"
    networks:
      - sonarnet
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_conf:/opt/sonarqube/conf

  sonarscanner:
    container_name: sonarscanner
    image: alexwoollam/docker-dotnet-sonarscanner:3.1
    networks:
      - sonarnet
    volumes:
      - ./:/project
    environment:
      - PROJECT_KEY=Project.Key
      - PROJECT_NAME=Project.Name
      - PROJECT_VERSION=1.0
      - HOST=http://sonarqube:9000
      - LOGIN_KEY=login.key

networks:
  sonarnet:

volumes:
  sonarqube_conf:
  sonarqube_data:

```
then `docker-compose -f ./docker-compose.sonarqube.yml up -d`
