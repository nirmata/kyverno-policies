# Use the official Python base image
FROM python:3.9

# Set PYTHONHTTPSVERIFY environment variable to disable SSL certificate verification
ENV PYTHONHTTPSVERIFY 0

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed dependencies spec
# Run the application

CMD [ "echo", "Hello world" ]