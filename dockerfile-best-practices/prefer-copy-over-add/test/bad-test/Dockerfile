FROM ubuntu:latest

WORKDIR /app

ADD . /app/

RUN apt-get update && apt-get install -y nano

COPY . /app

EXPOSE 8080

# Example: Run a command when the container starts
CMD ["echo", "ADD is present in the Dockerfile"]
