#!/usr/bin/env bash

set -e

# Seteo el directorio temporal donde se van a guardar los dumps temporales
TEMP=/tmp/dump
# Seteo el directorio donde se van a guardar los dumps
DEST=/root

# limpio el directorio temporal
rm -rf ${TEMP} && mkdir -p ${TEMP}

# Si no existen creo los directorios
[[ ! -d ${DEST} ]] && mkdir -p ${DEST}

# Leo la lista de containers
IN=$(docker ps -a --format '{{.Image}} {{.Names}};')

# Guardo la lista de containers como array (separados por ; ^)
IFS=';' read -r -d '' -a  CONTAINERS <<< "$IN"

# Por cada container, me fijo si la imagen (el texto en pos [0]) es mongo, maria o mysql
for container in "${CONTAINERS[@]}"
do
    # Convierto el resultado en array
    array=(${container})

    # Si es mongo
    if [[ ${array[0]} == "mongo"* ]]; then
        docker exec "${array[1]}" rm -rf dump && docker exec ${array[1]} mongodump && rm -rf ${TEMP}/dump_${array[1]} && docker cp ${array[1]}:/dump ${TEMP}/dump_${array[1]}
    fi

    # Si es mariadb
    if [[ ${array[0]} == "mariadb"* ]]; then
        docker exec -t "${array[1]}" /usr/bin/mysqldump -u root --password=root ${array[1]} >${TEMP}/${array[1]}.sql
    fi

    # Si es mysql
    if [[ ${array[0]} == "mysql"* ]]; then
        docker exec -t "${array[1]}" /usr/bin/mysqldump -u root --password=root ${array[1]} >${TEMP}/${array[1]}.sql
    fi
done

# create gzip file dump.tgz cambio directorio para que no me quede el absolute path a $TEMP
tar czf ${DEST}/dump.tgz -C ${TEMP} .
# copio a /data para que sea parte del backup
cp ${DEST}/dump.tgz ${DEST}/data/dump.tgz

set +e
# aviso por rocket que se creó el dump
curl -X POST --data-urlencode "payload={\"channel\": \"#dgi-desarrollo\", \"username\": \"Jarvis\", \"text\": \"Dump creado correctamente\", \"icon_emoji\": \":asterisk:\"}" https://chat.jusneuquen.gov.ar/hooks/YgqEzqHuLFvkSb36u/ZH8YzZDy8A6aKbnce6iEqrJbtsXtNqoYqjYXNNEgpDC6pcS3
