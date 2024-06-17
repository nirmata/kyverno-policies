FROM ubuntu:latest

# Update the package repository
RUN apt-get update && apt-get install -y nano

WORKDIR /app

COPY . /app

EXPOSE 8080

# Example: Run a command when the container starts
CMD ["echo", "Container is running!"]
