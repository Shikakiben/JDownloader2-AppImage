
#!/bin/bash
set -e
pacman -Sy --noconfirm wget p7zip gzip which xorg-server-xvfb libxtst zsync python python-pip
pip install --no-cache-dir --break-system-packages mega.py

