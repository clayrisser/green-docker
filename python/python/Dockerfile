FROM python:3.7.0-alpine3.8

LABEL image=codejamninja/green-docker:python \
      maintainer="Jam Risser <jam@codejam.ninja>" \
      base=alpine:3.8

RUN apk add --no-cache \
        tini && \
    apk add --no-cache --virtual build-deps \
        build-base

WORKDIR /opt/app

COPY /app/requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY /app ./
RUN apk del build-deps

ENV HELLO=world \
    HOWDY=texas

EXPOSE 5000

ENTRYPOINT ["/sbin/tini", "--", "python", "server.py"]
