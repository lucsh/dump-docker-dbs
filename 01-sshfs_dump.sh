#!/bin/bash
# la carpeta que voy a montar temporalmente
MOUNT=~/backups/dbs
# Donde voy a guardar los backups
DEST=~/Dropbox/backups/dbs

# Si no existen creo los directorios
[[ ! -d ${MOUNT} ]] && mkdir -p ${MOUNT}
[[ ! -d ${DEST} ]] && mkdir -p ${DEST}


CURRDATE=$(date +"%F")
SERVER=172.16.1.114
USER="root"

echo "Password del servidor"
sudo sshfs -o allow_other,defer_permissions root@${SERVER}:/root ${MOUNT}
echo "Password del servidor (si, otra vez)"
ssh root@${SERVER} << EOF
rm -rf dump
rm -f dump.tgz
mkdir -p dump

./01-server_from-local.sh mongodump expedientes-sesion-staging
./01-server_from-local.sh mongodump gestion_equipos
./01-server_from-local.sh mysqldump expedientes-staging

tar czvf dump.tgz dump
logout
EOF

# muevo el tar del dump a DEST con fecha
mv -f  ${MOUNT}/dump.tgz ${DEST}/dump_${CURRDATE}.tgz
# desmonto
diskutil unmount ${MOUNT}
