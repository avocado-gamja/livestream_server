# Base image with FFmpeg and NGINX with RTMP module
FROM ubuntu:20.04

# Install FFmpeg, NGINX with RTMP module, and other utilities
RUN apt-get update && apt-get install -y \
    nginx libnginx-mod-rtmp ffmpeg curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the custom NGINX configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Create the output directory for images
RUN mkdir -p /home/ahn/workspace/liveStreamData

# Set the work directory
WORKDIR /home/ahn/workspace/liveStreamData

# Copy the script that processes the stream
COPY process_stream.sh /usr/local/bin/process_stream.sh
RUN chmod +x /usr/local/bin/process_stream.sh

# Expose the RTMP port
EXPOSE 1935

# Start NGINX and FFmpeg stream processing script
CMD ["/bin/bash", "-c", "nginx && /usr/local/bin/process_stream.sh"]

