############################################################
# Dockerfile to run YourAwesomeProject
# Based on Alpine
############################################################

FROM alpine:3.5

MAINTAINER Jam Risser (jamrizzi)

EXPOSE 8888

ENV SOME_ENV_USED_DURING_BUILD=hellodocker

WORKDIR /app/

RUN apk add --no-cache tini && \
    apk add --no-cache --virtual build-deps build-base

COPY ./requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt
COPY ./ /app/
RUN apk del build-dependencies

ENV SOME_ENV_USED_DURING_RUNTIME=hellodocker

ENTRYPOINT ["/sbin/tini", "--", "python", "/app/server.py"]
