## 01-server_dump.sh
Recive 2 parametros mongodump|mysqldump nombredelcontainer 
Ejecuta el dump y lo deja en ./dump
## 01-scp_dump.sh
Ejecuta el sh *01-server_from-local.sh* de forma remota con *ssh* y copia con *scp*
## 01-sshfs_dump.sh 
Ejecuta el sh *01-server_from-local.sh* de forma remota con *ssh* y copia con *sshfs*
## 02-server_dump-all.sh
Lista los containers y ejecuta los respectivos dumps dependiendo si la imagen es mongo|maria|mysql los comprime y quedan en ./dump.tgz
## 02-scp_dump-all.sh.sh
Ejecuta el sh *02-server_dump-all.sh* de forma remota con *ssh* y copia con *scp*
