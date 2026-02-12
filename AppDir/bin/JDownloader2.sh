#!/bin/sh

JDDIR="$HOME/.local/share/JDownloader2"
LOGODIR="$JDDIR/themes/standard/org/jdownloader/images/logo"

if [ ! -s "$JDDIR/JDownloader.jar" ]; then
    rm -rf "$JDDIR/JDownloader.jar" "$JDDIR/Core.jar" "$JDDIR/update" "$JDDIR/tmp" 2>/dev/null
    mkdir -p "$JDDIR"
    install -m644 "$(dirname "$0")/JDownloader.jar" "$JDDIR/JDownloader.jar"

    # 1er lancement pour laisser JD créer son arborescence
    java -jar "$JDDIR/JDownloader.jar" "$@" &
    PID=$!

    # attendre max 5 min que le dossier/logo existe
    i=0
    while [ $i -lt 150 ]; do
        if [ -d "$LOGODIR" ] && [ -f "$LOGODIR/jd_logo_128_128.png" ]; then
            break
        fi
        sleep 2
        i=$((i+1))
    done

    # arrêter ce 1er run
    kill "$PID" 2>/dev/null || true
    pkill -f 'JDownloader.jar|jdownloader2' >/dev/null 2>&1 || true
    sleep 1
fi

# copie icone systray
install -m644 "$(dirname "$0")/jd_logo_128_128.png" \
  "$LOGODIR/jd_logo_128_128.png"

exec java -jar "$JDDIR/JDownloader.jar" "$@"
