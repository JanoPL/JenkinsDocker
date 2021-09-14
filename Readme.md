# Jenkins
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/johnnypl/jenkins-php)

Docker Jenkins with php and node, npm

Image based on jenkins debian the version [jenkins/jenkins:latest](https://hub.docker.com/r/jenkins/jenkins) 

contains: 
- Node version: 16
- PHP version: 8.0
- plugins: 
    ```shell script
    analysis-model-api:10.3.0
    warnings-ng:9.5.0
    blueocean:1.24.8
    ssh-agent:1.23
    ```


## Get started
To run simply enter one of the following commands or you can use the docker-compose command

Before run container please create new volumes to stored your jenkins configuration
```shell script
docker volume create jenkins_home
```

#### Start container  
```shell script
docker run -p 8080:8080 -p 50000:50000 --restart=always -v jenkins_home:/var/jenkins_home --name=jenkins johnnypl/jenkins-php 
```
Background run container: 
```shell script
docker run -d -p 8080:8080 -p 50000:50000 --restart=always -v jenkins_home:/var/jenkins_home --name=jenkins johnnypl/jenkins-php 
```
#### Time Zone

Start container with your time zone simple added docker environment ``` -e TZ=Europe/Warsaw ```
```shell script
docker run -p 8080:8080 -p 50000:50000 --restart=always -v jenkins_home:/var/jenkins_home --name=jenkins johnnypl/jenkins-php -e TZ=Europe/Warsaw
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
blueocean:1.24.8
```

A list of all plugins can be found at: https://plugins.jenkins.io/

#### Docker compose
This is example of docker-compose, you can also download a file from [source](https://github.com/JanoPL/JenkinsDocker/blob/master/docker-compose.yml)

```shell script
version: "3.7"

volumes:
  jenkins_home:
    driver: local

services:
  jenkins:
    image: johnnypl/jenkins-php:latest
    container_name: jenkins_php
    env_file:
      - .env
    build: 
      context: .
      dockerfile: ./Dockerfile
      args:
        - TZ=Europe/Warsaw
        - TARGET_PHP_VERSION=${TARGET_PHP_VERSION}
        - TARGET_NODEJS_VERSION=${TARGET_NODEJS_VERSION}
    ports:
    - 8080:8080
    - 50000:50000
    volumes:
    - jenkins_home:/var/jenkins_home
    restart: always
```

<hr> 

#### Requirements
 
Minimum version:
- Docker: 20.10.8
- docker-compose: 1.29.2
