#!/bin/sh
cd "$(dirname "$0")"

sqlite3 -json sqlite/cdeschools.sqlite "select * from schools;" > json/schools.json
sqlite3 -json sqlite/cdeschools.sqlite "select * from satscores;" > json/satscores.json
zq -z -i json -I shape-schools.zed '| sort School' json/schools.json > zson/schools.zson
zq -z -i json -I shape-satscores.zed '| sort sname' json/satscores.json > zson/satscores.zson
