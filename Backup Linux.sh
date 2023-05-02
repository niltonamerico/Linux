#! /usr/bin/env sh

# Diretorio de backup origem
backup_path="/mnt/arquivos"

# Diretorio de destino
remote_storage="/mnt/backup/full/"

# Formato do arquivo
date_format=$(date "+%d-%m-%Y")

final_archive="backup-$date_format.tar.gz"

# Log de registros
log_file="/var/log/daily-backup.log"

# Teste de montagem da unidade remota
if ! mountpoint -q -- $remote_storage; then
        printf "[$date_format] UNIDADE NAO MONTADA in: $remote_storage CHECK IT. \n" >> $log_file
        exit 1
fi

###################
#Inicio do backup.#
###################

if tar -czSpf "$remote_storage/$final_archive" "$backup_path"; then
        printf "[$date_format] BACKUP SUCESS.\n" >> $log_file
else
        printf "[$date_format] BACKUP ERROR\n" >> $log_file
fi

#Exclui arquivos com mais de 60 dias
find $remote_storage -mtime +60 -delete