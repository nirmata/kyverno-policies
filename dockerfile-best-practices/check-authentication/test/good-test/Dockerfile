FROM ubuntu:latest

RUN apt-get update && \
     apt-get install -y yamllint

WORKDIR /app

COPY . /app

EXPOSE 8080

CMD ["echo", "Container is running!"]