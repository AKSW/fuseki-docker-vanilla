FROM eclipse-temurin:21-jdk-noble

RUN apt-get update && apt-get install -y --no-install-recommends git nano vim \
    && rm -rf /var/lib/apt/lists/*

ARG FUSEKI_VERSION=6.1.0

ARG FUSEKI_BASENAME=apache-jena-fuseki-${FUSEKI_VERSION}
ARG FUSEKI_ARCHIVE=${FUSEKI_BASENAME}.tar.gz
ARG FUSEKI_DOWNLOAD_BASE=https://dlcdn.apache.org/jena/binaries/
ARG FUSEKI_DOWNLOAD_URL=${FUSEKI_DOWNLOAD_BASE}${FUSEKI_ARCHIVE}

ARG DOWNLOAD_DIR=/fuseki/downloads

ARG FUSEKI_HOME=/fuseki
ARG FUSEKI_BASE=${FUSEKI_HOME}/run

ENV FUSEKI_HOME=${FUSEKI_HOME}
ENV FUSEKI_BASE=${FUSEKI_BASE}
ENV FUSEKI_CONFIG=${FUSEKI_BASE}/config.ttl

RUN mkdir -p "${DOWNLOAD_DIR}" \
    && curl -C - -L -o "${DOWNLOAD_DIR}/${FUSEKI_ARCHIVE}" "${FUSEKI_DOWNLOAD_URL}" \
    && tar xf "${DOWNLOAD_DIR}/${FUSEKI_ARCHIVE}" -C "${FUSEKI_HOME}" --strip-components=1 \
    && rm -rf "${DOWNLOAD_DIR}"

WORKDIR ${FUSEKI_HOME}
VOLUME ${FUSEKI_BASE}

COPY --chmod=755 entrypoint.sh "${FUSEKI_HOME}/entrypoint.sh"
ENTRYPOINT ["/fuseki/entrypoint.sh"]

