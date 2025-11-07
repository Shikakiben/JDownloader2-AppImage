#!/bin/bash
set -e
pacman -Sy --noconfirm wget p7zip gzip


# Vérifie la présence de gunzip, crée le lien si absent
if ! command -v gunzip >/dev/null 2>&1; then
	echo "gunzip n'est pas présent, création du lien symbolique..."
	if [ -x "$(command -v gzip)" ]; then
		ln -sf "$(command -v gzip)" /usr/bin/gunzip
	fi
fi

# Re-vérifie la présence de gunzip
if ! command -v gunzip >/dev/null 2>&1; then
	echo "Erreur : impossible de créer gunzip. Abandon."
	exit 1
fi

