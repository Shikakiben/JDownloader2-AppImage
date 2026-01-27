#!/bin/sh

JDDIR="$HOME/.local/share/JDownloader"

if ! jar -tvf ${JDDIR}/JDownloader.jar > /dev/null 2>&1; then
    rm -rf ${JDDIR}/JDownloader.jar ${JDDIR}/Core.jar ${JDDIR}/update ${JDDIR}/tmp 2>/dev/null
    mkdir -p ${JDDIR}
    install -m644 "$(dirname "$0")/JDownloader.jar" "$JDDIR/JDownloader.jar"
fi

exec java -jar "$JDDIR/JDownloader.jar" "$@"
