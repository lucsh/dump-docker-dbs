#!/bin/bash
# Donde voy a guardar los backups
DEST=~/Dropbox/backups/dbs

# Si no existe creo el directorio
[[ ! -d ${DEST} ]] && mkdir -p ${DEST}

CURRDATE=$(date +"%F")
SERVER=172.16.1.114
USER="root"

# si necesito copiar el script
#scp 01-server_from-local.sh ${USER}@${SERVER}:/root

echo "Password del servidor"

# 1- Elimino la carpeta y el zip y la vuelvo a crear para que este limpio
# 2- Corro el script para sacar los backups de los containers
# 3- Comprimo
# 4- Deslogeo

ssh ${USER}@${SERVER} << EOF
rm -rf dump
rm -f dump.tgz
mkdir -p dump

./01-server_from-local.sh mongodump expedientes-sesion-staging
./01-server_from-local.sh mongodump gestion_equipos
./01-server_from-local.sh mysqldump expedientes-staging

tar czvf dump.tgz dump
logout
EOF

echo "Password del servidor (si, otra vez)"

# Copio el zip al DEST
scp ${USER}@${SERVER}:/root/dump.tgz ${DEST}/dump_${CURRDATE}.tgz
