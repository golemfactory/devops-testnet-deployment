# Use an official Python runtime as a parent image
FROM python:3.10-alpine

# Set environment variables
ENV PYTHONUNBUFFERED 1

# Install cron
RUN apk add --no-cache dcron dos2unix

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy yagna builds
COPY ./yagna-builds /usr/local/bin

# Set Path
ENV PATH="/usr/local/bin:${PATH}"

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Add crontab file
COPY crontab /etc/cron.d/golem-cron
RUN chmod 0644 /etc/cron.d/golem-cron
RUN crontab /etc/cron.d/golem-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Create a script to run yagna and cron
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && \
    chmod +x /entrypoint.sh && \
    chmod +x /usr/src/app/repeat_script.sh

# Run the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]