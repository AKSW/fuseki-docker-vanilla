#!/bin/sh
exec "${FUSEKI_HOME}/fuseki-server" "--config=${FUSEKI_CONFIG}" "$@"
