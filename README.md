# Composer

Service for raising all services using the docker-compose utility. Also, for data transfer, communication between containers is configured in the config

To run docker-compose, follow these steps:

- `cp .env.sample .env`. Copy the config template with environment variables and fill in the appropriate values
- Be sure to define the `ROOT_DIR_2SMART` variable. To do this, in the 2smart-composer folder, you need to execute pwd and copy the result to a variable
- `docker-compose pull` will pull the necessary images
- `docker-compose up -d` start all containers

## Local Development

Containers for local development are described [here](docker-compose.develop.yml).

The bash script [develop.sh](develop.sh) is used to run containers locally.

Launch parameters:
- `build` build the project image. This requires the project to be on the local machine, named exactly like the name of the container, and at the same file level as the `2smart-composer` project.
Usage example:
```
1) ./develop.sh build
2) Select images to build
3) To run 'build' select the 'finish' option
```
- `pull` download image from docker registry.
Usage example:
```
1) ./develop.sh pull
2) Select images to download
3) To start 'pull' select 'finish' option
```
- `down` stop all running containers.
Usage example - `./develop.sh down`

- `up` start selected containers.
Usage example:
```
1) ./develop.sh up
2) Select images to run
3) To run 'up' select the 'finish' option
```

## Run test images locally

```shell
  docker-compose -f docker-compose.yml -f docker-compose.test.yml up -d <list of services>
```

## Run production images locally

1) Start all services:
     ```
     docker-compose up -d
     ```

     1.1) Starting individual services:
     ```
     docker compose up -d <service_1> ...
     ```
2) Stop all running services:
     ```
     docker-compose down
     ```
3) Download actual service images:
     ```
     docker-compose pull
     ```
     3.1) Download images of specific services:
     ```
     docker-compose pull <service_1> ...
     ```

## Create permissions for the device ##

```
./get_token.sh <device_id>
```

The script will output to stdout a token (password) for the device whose id was passed to the script arguments.
Usage example for xiaomi-gateway:
```
$ ./get_token.sh xiaomi-gateway -> <device_token>
```

Then, in the docker-compose file for the xiaomi-gateway-bridge service, you need to pass the following parameters to the environment variables
```
MQTT_USER=xiaomi-gateway
MQTT_PASS=<device_token>
```
