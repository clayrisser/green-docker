Start your Dockerfile with a descriptive comment.

Because some root docker containers start with a third party
source, list what real souce your docke file is

```sh
############################################################
# Dockerfile to run YourAwesomeProject
# Based on Alpine
############################################################
```

Alpine is the smallest base image with package management
Always specify a tag (NOT latest) to prevent unexpected updates
```
FROM alpine:3.5
```

Maintainer is helpful for identifying support
```sh
MAINTAINER Jam Risser (jamrizzi)
```

Expose the port(s) your app runs on
```sh
EXPOSE 8888
```

Specify environment variables your build uses at the top
```sh
ENV SOME_ENV_USED_DURING_BUILD=hellodocker
```

Set the working directory
```sh
WORKDIR /app/
```

install system dependencies (make sure tini is installed)
make sure you specify not to cache the dependencies
```sh
RUN apk add --no-cache tini && \
```

install system build dependencies
```sh
    apk add --no-cache --virtual build-deps build-base
```

copy project package dependency list
```sh
COPY ./package.json /app/package.json
```

install project dependencies
```sh
RUN npm install
```

copy the rest of the project
```sh
COPY ./ /app/
```

build the project
```sh
RUN npm run build && /
```

remove build dependencies
```sh
apk del build-dependencies
```

Specify environment variables not used during the build process
to prevent unnecessarily rebuilding cached layers
```sh
ENV SOME_ENV_USED_DURING_RUNTIME=hellodocker
```

run the project through tini to catch SIGINT
```sh
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/supervisord", "-n"]
```
