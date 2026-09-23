#!/bin/sh
set -eu

WANT_UID="${WANT_UID:-1000}"
WANT_GID="${WANT_GID:-1000}"

command -v setpriv >/dev/null 2>&1 || {
    echo "setpriv not found; cannot drop privileges" >&2
    exit 1
}

if ! chown -R "${WANT_UID}:${WANT_GID}" "${FUSEKI_BASE}" 2>/dev/null; then
    echo "note: some entries under ${FUSEKI_BASE} could not be chowned (e.g. read-only mounts); continuing" >&2
fi
chown "${WANT_UID}:${WANT_GID}" "${FUSEKI_HOME}"

exec setpriv --reuid="${WANT_UID}" --regid="${WANT_GID}" --clear-groups "$@"
