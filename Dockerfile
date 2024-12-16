# Base image for building
FROM ubuntu:20.04 as builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev unzip

# Download NGINX and RTMP module
WORKDIR /tmp
RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    wget https://github.com/arut/nginx-rtmp-module/archive/master.zip && \
    tar -zxvf nginx-1.21.6.tar.gz && \
    unzip master.zip

# Build NGINX with RTMP module
WORKDIR /tmp/nginx-1.21.6
RUN ./configure --add-module=/tmp/nginx-rtmp-module-master --with-http_ssl_module && \
    make && make install

# Final lightweight image
FROM ubuntu:20.04

# Install required libraries and additional tools (ffmpeg, vim, net-tools)
RUN apt-get update && apt-get install -y \
    libpcre3 libssl-dev zlib1g ffmpeg vim net-tools && \
    apt-get clean

# Create HLS directory
RUN mkdir -p /tmp/hls

# Copy built NGINX binary
COPY --from=builder /usr/local/nginx /usr/local/nginx

# Copy the configuration file
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# Copy the HTML file
COPY index.html /usr/local/nginx/html/index.html

# Expose RTMP, HLS, and HTTP ports
EXPOSE 1935 8080

# Start NGINX
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

