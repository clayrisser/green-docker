FROM alpine:3.7

LABEL image=jamrizzi/erpnext:stable \
      maintainer="Jam Risser <jam@jamrizzi.com>" \
      base=alpine:3.7

RUN apk add --no-cache \
        tini && \
    apk add --no-cache --virtual build-deps \
        build-base

WORKDIR /app

COPY /requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt
COPY /app /app
RUN apk del build-deps

ENV HELLO=world \
    HOWDY=texas

ENTRYPOINT ["/sbin/tini", "--", "python", "/app/server.py"]
