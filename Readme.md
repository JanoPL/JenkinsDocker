# Jenkins
![Docker Automated build](https://img.shields.io/docker/automated/johnnypl/jenkins-php)
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/johnnypl/jenkins-php)

Docker Jenkins with php

Image based on jenkins debian the version [jenkins/jenkins:latest](https://hub.docker.com/r/jenkins/jenkins) 

contains: 
- php
- plugins

## Get started
To run simply enter one of the following commands or you can use the docker-compose command

Before run container please create new volumes to stored your jenkins configuration
```shell script
docker volume create jenkins_home
```

Start container  
```shell script
docker run -p 8080:8080 -p 50000:50000 --restart=always -v jenkins_home:/var/jenkins_home --name=jenkins johnnypl/jenkins-php 
```

<hr>

## Source code 

#### Plugins
In the plugins.txt file you can add new plugins when compiling the image

New plugins must look like this, more plugins can be found on [Jenkins plugins](https://plugins.jenkins.io/)
```shell script
name-of-plugin:version
```
Example of plugins.txt:
```shell script
blueocean:1.22.0
```

#### Docker compose
This is example of docker-compose, you can also download a file from [source](https://github.com/JanoPL/JenkinsDocker/blob/master/docker-compose.yml)

```shell script
version: "3.7"

volumes:
  jenkins_home:
    driver: local
    external: true

services:
  jenkins:
    image: jenkins-php:latest
    container_name: jenkins_php
    env_file:
      - .env
    build: 
      context: .
      dockerfile: ./Dockerfile
      args:
        - TARGET_PHP_VERSION=${TARGET_PHP_VERSION}
    ports:
    - 8080:8080
    - 50000:50000
    volumes:
    - jenkins_home:/var/jenkins_home
    restart: always
```

<hr> 

#### Requirements

- Docker: 19.03.5
- docker-compose: 1.25.4
