#!/bin/sh
exec "${FUSEKI_HOME}/run-as.sh" "${FUSEKI_HOME}/fuseki-server" "--config=${FUSEKI_CONFIG}" "$@"
