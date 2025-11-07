#!/bin/bash
set -e
pacman -Sy --noconfirm wget p7zip gzip

# Correction gunzip manquant sur certains Arch minimal
ln -sf /usr/bin/gzip /usr/bin/gunzip

