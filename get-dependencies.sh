#!/bin/bash
set -e
pacman -Sy --noconfirm wget p7zip gzip


# Diagnostics avant test gunzip (affichés dans les logs du workflow)
echo "PATH=$PATH"
ls -l /usr/bin | grep gunzip || true
ls -l /usr/bin/gzip || true

# Vérifie la présence de gunzip, crée le lien si absent
if ! command -v gunzip >/dev/null 2>&1; then
    echo "gunzip n'est pas présent, création du lien symbolique..."
    if [ -x "/usr/bin/gzip" ]; then
        ln -sf /usr/bin/gzip /usr/bin/gunzip
        RET=$?
        echo "ln -sf /usr/bin/gzip /usr/bin/gunzip => $RET"
        ls -l /usr/bin/gunzip || true
    else
        echo "Erreur : /usr/bin/gzip n'est pas exécutable."
    fi
fi


# Debug : affiche le test utilisé
echo "Test gunzip avec : command -v gunzip"
if command -v gunzip >/dev/null 2>&1; then
    echo "gunzip trouvé via command -v"
else
    echo "gunzip NON trouvé via command -v"
    echo "Test gunzip avec : [ -x /usr/bin/gunzip ]"
    if [ -x /usr/bin/gunzip ]; then
        echo "gunzip est exécutable dans /usr/bin/gunzip"
    else
        echo "gunzip n'est PAS exécutable dans /usr/bin/gunzip"
        echo "Erreur : impossible de créer gunzip. Abandon."
        exit 1
    fi
fi

