#!/bin/bash
# Donde voy a guardar los backups
DEST=~/Dropbox/backups/dbs

# Si no existe creo el directorio
[[ ! -d ${DEST} ]] && mkdir -p ${DEST}

CURRDATE=$(date +"%F")
SERVER=172.16.1.114
USER="root"

#echo "Password del servidor"
ssh ${USER}@${SERVER}:./02-server_dump-all.sh
#echo "Password del servidor (si, otra vez)"

# Copio el zip al DEST
scp ${USER}@${SERVER}:/root/dump.tgz ${DEST}/dump_${CURRDATE}.tgz
