# Fuseki Docker

[Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/) is a powerful SPARQL server. This repository provides a dockerized version of Fuseki, packaged as a vanilla Docker image. Vanilla means that the image contains just the Fuseki server without any customization.

Images are published to [docker.io/aksw/fuseki-vanilla](https://hub.docker.com/repository/docker/aksw/fuseki-vanilla/general)

Pull with:
```bash
docker pull aksw/fuseki-vanilla:6.1.0
```

Check out [aksw/fuseki-docker-plus](https://github.com/AKSW/fuseki-docker-plus/) which extends this image with prebundled plugins and a simple CLI-based plugin manager!

## Features

- Vanilla Apache Jena Fuseki
- Configurable JVM arguments
- Data persistence via volumes
- Runs as non-root user (optional)

## Directory Structure

- `/fuseki` — Fuseki installation directory
- `/fuseki/run` — Data and configuration volume

## Quick Start

### Build the Image

```bash
docker build --no-cache -t aksw/fuseki-vanilla:6.1.0 .
```

### Run with Docker Compose

Create a `docker-compose.yaml` file:

```yaml
services:
  fuseki:
    image: aksw/fuseki-vanilla:6.1.0
    init: true
    environment:
      - JVM_ARGS=-Xmx4G -XX:ReplayDataFile=/fuseki/run/logs/fuseki_replay_pid%p.log -XX:ErrorFile=/fuseki/run/logs/fuseki_hs_err_pid%p.log -Dderby.stream.error.file=/fuseki/run/logs/fuseki_derby.log
    volumes:
      - ./run:/fuseki/run
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
- **Config file**: `/fuseki/run/config.ttl` (must be present or Fuseki will fail to start)

## Overriding the Config File

By default, Fuseki uses `/fuseki/run/config.ttl`. You can specify a custom config file by setting the `FUSEKI_CONFIG` environment variable:

```bash
docker run --rm -it \
  -v ./custom-config:/fuseki/run \
  -e FUSEKI_CONFIG=/fuseki/run/custom-config.ttl \
  aksw/fuseki-vanilla:6.1.0
```

Or with Docker Compose:

```yaml
services:
  fuseki:
    image: aksw/fuseki-vanilla:6.1.0
    environment:
      - FUSEKI_CONFIG=/fuseki/run/custom-config.ttl
    volumes:
      - ./custom-config:/fuseki/run
```

If you want to start fuseki without a `--config` argument, you need to set the entrypoint to `/fuseki/fuseki-server`.
The default `entrypoint.sh` wrapper always adds a `--config=/path/to/config` argument.

```bash
docker run --rm -it --entrypoint /fuseki/fuseki-server aksw/fuseki-vanilla:6.1.0 [ARGS]
```

## Persistence

Data is stored in the `./run` directory (mapped to `/fuseki/run` inside the container). This includes:
- Datasets and databases
- Configuration files
- Log files

## Versioning

Image tag format: `aksw/fuseki-vanilla:<fuseki-version>`

Current version: **6.1.0**

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

