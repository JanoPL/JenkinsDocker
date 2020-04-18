# Jenkins

Docker Jenkins with php

contains: 
- php
- plugins

## usage

File .env contains var for php version

To run just simple type one of below command
  
- ```shell script
    $ docker-compose build 
    $ docker-compose up -d
  ```

- ```shell script
    $ docker-compose up -d --build
  ```    

#### Required

- Docker: 19.03.5
- docker-compose: 1.25.4