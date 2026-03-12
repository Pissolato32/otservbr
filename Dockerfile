FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    cmake \
    build-essential \
    git \
    libboost-all-dev \
    liblua5.1-0-dev \
    libmysqlclient-dev \
    mysql-client \
    libgmp-dev \
    libssl-dev \
    libxml2-dev \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/tfs

# Clone the chosen repository and pin the commit
RUN git clone https://github.com/fir3element/3777.git . && \
    git checkout 29eb7a67e6994950687967f5afb69c39b04dd622

# Compile
RUN mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc)

# We store the original datapack and schema inside a separate directory
# so the entrypoint script can copy them to the volume mount if they don't exist.
RUN mkdir -p /srv/tfs-base-data && \
    cp -r /srv/tfs/data/* /srv/tfs-base-data/ && \
    cp /srv/tfs/schemas/mysql.sql /srv/tfs-base-data/schema.sql

# Make the start script executable
COPY init-db.sh /srv/tfs/init-db.sh
RUN chmod +x /srv/tfs/init-db.sh

ENTRYPOINT ["/srv/tfs/init-db.sh"]
