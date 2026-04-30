FROM eclipse-temurin:21-jdk-noble

RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

ARG FUSEKI_VERSION=apache-jena-fuseki-6.0.0
ARG FUSEKI_DOWNLOAD_BASE_URL=https://dlcdn.apache.org/jena/binaries/
ARG FUSEKI_ARCHIVE=${FUSEKI_VERSION}.tar.gz
ARG DOWNLOAD_DIR=/app/fuseki/downloads
ARG FUSEKI_BASE=/app/fuseki

RUN mkdir -p "${DOWNLOAD_DIR}" \
    && curl -C - -L -o "${DOWNLOAD_DIR}/${FUSEKI_ARCHIVE}" "${FUSEKI_DOWNLOAD_BASE_URL}${FUSEKI_ARCHIVE}" \
    && tar xf "${DOWNLOAD_DIR}/${FUSEKI_ARCHIVE}" -C "${FUSEKI_BASE}" --strip-components=1 \
    && rm -rf "${DOWNLOAD_DIR}"

WORKDIR /app/fuseki
VOLUME /app/fuseki/run

ENV FUSEKI_BASE=/app/fuseki/run

ENTRYPOINT ["/app/fuseki/fuseki-server", "--config=/app/fuseki/run/config.ttl"]
