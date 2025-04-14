# Use Alpine as a base image
FROM alpine:latest

# Install dependencies and tools
RUN apk add --no-cache build-base cmake git unzip rtl-sdr mosquitto-clients

# Clone and build multimon-ng
RUN git clone https://github.com/EliasOenal/multimon-ng.git /opt/multimon-ng && \
    cd /opt/multimon-ng && \
    mkdir build && cd build && \
    cmake .. && \
    make && \
    make install

# Install PDW
RUN wget https://www.discriminator.nl/pdw/pdw3.2b01.zip -P /opt && \
    unzip /opt/pdw3.2b01.zip -d /opt && \
    rm /opt/pdw3.2b01.zip

# Remove build dependencies to reduce image size
RUN apk del build-base cmake git unzip && \
    rm -rf /var/cache/apk/*

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
