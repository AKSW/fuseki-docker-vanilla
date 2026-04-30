# Fuseki Docker

[Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/) is a powerful SPARQL server. This repository provides a Dockerized version of Fuseki, packaged as a vanilla Docker image. Vanilla means that the image contains just the Fuseki server without any customization.

## Features

- Vanilla Apache Jena Fuseki
- Configurable JVM arguments
- Data persistence via volumes
- Runs as non-root user (optional)

## Directory Structure

- `/app/fuseki` — Fuseki installation directory
- `/app/fuseki/run` — Data and configuration volume

## Quick Start

### Build the Image

```bash
docker build --no-cache -t aksw/fuseki-vanilla:6.0.0 .
```

### Run with Docker Compose

Create a `docker-compose.yaml` file:

```yaml
services:
  fuseki:
    image: aksw/fuseki:6.0.0
    init: true
    environment:
      - JVM_ARGS=-Xmx4G -XX:ReplayDataFile=/app/fuseki/run/logs/fuseki_replay_pid%p.log -XX:ErrorFile=/app/fuseki/run/logs/fuseki_hs_err_pid%p.log -Dderby.stream.error.file=/app/fuseki/run/logs/fuseki_derby.log
    volumes:
      - ./run:/app/fuseki/run
    ports:
      - 3030:3030
      # - 5005:5005
    restart: unless-stopped
    user: "${APP_UID}:${APP_GID}"
```

Run with current user:

```bash
APP_UID=$(id -u) APP_GID=$(id -g) docker compose up -d
```

## Configuration

- **Fuseki UI**: http://localhost:3030
- **Port 3030**: Main Fuseki HTTP endpoint
- **Port 5005**: JDWP debug port (disable if not needed)
- **Config file**: `/app/fuseki/run/config.ttl` (must be present or Fuseki will fail to start)

## Persistence

Data is stored in the `./run` directory (mapped to `/app/fuseki/run` inside the container). This includes:
- Datasets and databases
- Configuration files
- Log files

## Versioning

Image tag format: `aksw/fuseki-vanilla:<fuseki-version>`

Current version: **6.0.0**

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.
