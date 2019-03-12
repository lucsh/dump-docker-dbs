#!/bin/bash

if [[ "$1" == "mongodump" ]]; then
     docker exec "$2" rm -rf dump && docker exec $2 mongodump && rm -rf dump/dump_$2 && docker cp $2:/dump dump/dump_$2
fi
if [[ "$1" == "mysqldump" ]]; then
    docker exec -t "$2" /usr/bin/mysqldump -u root --password=root $2 > dump/$2.sql
fi
