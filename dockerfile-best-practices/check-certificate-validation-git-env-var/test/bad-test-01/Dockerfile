FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y git

ENV GIT_SSL_NO_VERIFY=true

CMD [ "echo", "hello world" ]