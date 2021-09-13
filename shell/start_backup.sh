#! /bin/bash

## CONFIG ##
source /opt/nimsoft_scripts/backup/config/backup_conf.sh
BACKUP_LUA="${LUA}/backup.lua"
LOG="${LOGSDIR}/backup_config.log"


if test $(find  ${RUN_FLG} -mmin -${TWIN} 2>/dev/null ); then
   cat <<-EOF 
	ERROR
	-----------------------------------------
	El backup ya fue ejecutado hace menos de 24Hs 

	Flag:
	${RUN_FLG}
	----------------------------------------
EOF
   ls -l ${RUN_FLG}
   exit 1
else
   echo "Iniciando rotacion de repositorio..."
fi



## Rotacion de backups
if [ -d "${REPODIR}.3" ]; then
   echo -e "\tBorrando repositorio ${REPODIR}.3"
   rm -rf  "${REPODIR}.3"
fi
 
if [ -d "${REPODIR}.2" ]; then
   echo -e "\tCreando repositorio ${REPODIR}.3"
   mv "${REPODIR}.2" "${REPODIR}.3"
fi
 
if [ -d "${REPODIR}.1" ]; then
   echo -e "\tCreando repositorio ${REPODIR}.2"
   mv "${REPODIR}.1" "${REPODIR}.2"
fi
 
if [ -d "${REPODIR}" ]; then
   echo -e "\tCreando repositorio ${REPODIR}.1"
   mv "${REPODIR}" "${REPODIR}.1"
fi

if [ ! -d ${REPODIR} ]; then
   echo -e "\tCreando repositorio de hoy ${REPODIR}"
   mkdir ${REPODIR}
   if [ ! -d ${REPODIR} ]; then
      echo -e "\tNo se pudo crear el directorio ${REPODIR}"
      exit 1
   fi
fi


## Flkag para evitar correr en el mismo dia
touch ${RUN_FLG}


## Backup
for i in $( cat ${HUBS_LIST} ) 
do
   echo ${i}
   ${NSA} ${BACKUP_LUA} -a ${i}  | tee ${LOG}.${i}
done

