# Docker Logstash Redis Dockerfile

This is a highly configurable Doradus Logstash image running logstash, custom Doradus GEM, Redis and published to the public <a href="https://registry.hub.docker.com/">Docker Hub Registry</a>.  The docker container logs are read by mounting the directory containing your Docker data (`/var/log/` in the below example) into the containers `/host/var/log`. The docker-logstash-redis container monitors the mounted directory, tailing the log files and buffers the log events to Redis.

## How to build the image

`sudo docker build -t pmattoo/docker-logstash-redis .`

## How to use this image

To start a basic container, execute the below command:
`docker run --link redis:redis -v /var/log:/host/var/log --name <container-name> -i -t pmattoo/docker-logstash-redis`