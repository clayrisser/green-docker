# Dockerfile Guide

I based this guide on personal advice from [@creak](https://github.com/creack), co-creator of Docker, as well as my own
experience and mistakes building, deploying and maintaining hundreds of Dockerfiles. [@creak](https://github.com/creack)
was the [#1 contrubuter](https://github.com/moby/moby/graphs/contributors?from=2013-01-13&to=2014-01-31&type=c) to Docker
during its first year. I owe my enthusiasm with Docker to a day [@creak](https://github.com/creack) sat down with me and
showed me ropes.

### Use a minimal base
Use a minimal base when possible. [Busybox](https://hub.docker.com/_/busybox/) is the most minimal base, but it lacks package management. I recommend using [Alpine](https://hub.docker.com/_/alpine/) because it is the most minimal that supports package management.

### Use official images for the base
Official images help prevent unexpected bugs because a professional team of developers continually maintains them.

### Use versioned tags for the base
Versioned tags also help prevent bugs. A base that is not versioned may change without you knowing, and could break the Docker image.

### Stick to Linux conventions
Docker images are a containerized system that shares the Linux kernel with the host machine. Because a Docker image is essentially a Linux system, it is advised to use Linux conventions when possible. Put binaries in `/usr/local/bin`. Put scripts in `/usr/local/sbin`. Put source code in `/usr/local/src`. Put applications in `/opt`. Usually, I place my main app in `/opt/app`, but some people might prefer to put it in `/usr/local/src/app`. Just use your best judgment.

### Chain instructions

### Install dependancies before copying application

### Clean up build dependancies

### Catch **SIGINT** signal
