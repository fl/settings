#!/bin/bash
#
# Elastic Pakete ermitteln und auf lokalem mirror bereitstellen

# weil Elastic aus irgendwelchen Gruenden directory-index abgeschaltet hat, muessen wir erfinderisch werden, umd das
# repo zu spiegeln, damit wir es ohne proxy/internetz installieren koennen. Elastic gibt als repo URL selbst an:
REPOBASE="https://artifacts.elastic.co/packages/8.x/apt"
MIRRORBASE="/home/fl/Documents/src/github.com/fl/settings/scripts/elastic-mirror"

# Nachdem wir die package-Struktur eines Debian repos kennen, bedeutet dies, dass wir ein ``Packages.gz`` fuer unsere
# Plattform finden weiter unten:
#wget -c "$REPOBASE/dists/stable/main/binary-amd64/Packages.gz"

zgrep '^Filename: ' Packages.gz | while read -a REPOLINE; do
  LOCALDIR=$(dirname "${REPOLINE[1]}")
  LOCALFILE=$(basename "${REPOLINE[1]}")

  echo "mkdir $MIRRORBASE/$LOCALDIR"
done


#    [...]
#    Filename: pool/main/e/elasticsearch/elasticsearch-8.13.1-amd64.deb
#    Filename: pool/main/e/elasticsearch/elasticsearch-8.13.0-amd64.deb
#    Filename: pool/main/e/elasticsearch/elasticsearch-8.12.2-amd64.deb
#    Filename: pool/main/e/elasticsearch/elasticsearch-8.12.1-amd64.deb
#    [...]
#
#der Pfad ist relativ zur REPO-URL, wir koennen uns also ein mirror-skript bauen:
#
#PREFIX: ``https://artifacts.elastic.co/packages/8.x/apt/``
#FILEPATH (Beispiel) ``pool/main/e/elasticsearch/elasticsearch-8.12.1-amd64.deb``
#
#ein download-link waere also:
#
#``https://artifacts.elastic.co/packages/8.x/apt/pool/main/e/elasticsearch/elasticsearch-8.12.1-amd64.deb``
