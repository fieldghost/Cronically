#!/bin/bash


COMMAND=$1

missing_source () {
	read -e -r -p "Please specify the /path/you/want/to/backup: " BACKUP_PATH
	BACKUP_PATH="${BACKUP_PATH/#\~/$HOME}" #Replace ~ with home directory

	if [ ! -z "$BACKUP_PATH" ]; then
		if [ ! -d "$BACKUP_PATH" ]; then
			echo "$BACKUP_PATH does not exist"
			missing_source
		else
			BACKUP_SOURCE_DIRECTORY="$BACKUP_PATH" 	
		fi
	else
		missing_source
	fi
}

missing_destination () {
	read -r -p "Please specify the /path/you/want/to/backup/to " BACKUP_DESTINATION_PATH
	BACKUP_DESTINATION_PATH="${BACKUP_DESTINATION_PATH/#\~/$HOME}" #Replace ~ with home directory

	if [ -z "$BACKUP_DESTINATION_PATH" ]; then
		missing_destination
	else
		BACKUP_DESTINATION_DIRECTORY="$BACKUP_DESTINATION_PATH"
	fi
}

execute_backup () {
	DAY=$(date +%A)	
	FILE_NAME="$DAY.tgz"

	tar czf "$1"/"$FILE_NAME" "$2"
	
	if [ $? -eq 0 ]; then
		echo "Backup of "$BACKUP_SOURCE_DIRECTORY" finished."
	else
		echo "Backup of "$BACKUP_SOURCE_DIRECTORY" failed."
		exit 1
	fi	
}


case $COMMAND in
	
	"backup")
		BACKUP_SOURCE_DIRECTORY=$2
		BACKUP_DESTINATION_DIRECTORY=$3
				
		if [ -z "$BACKUP_SOURCE_DIRECTORY" ]; then
			missing_source 	
		fi	
		
		if [ -z "$BACKUP_DESTINATION_DIRECTORY" ]; then
			missing_destination
		fi
		
		if [ ! -d "$BACKUP_SOURCE_DIRECTORY" ]; then
			echo "$BACKUP_SOURCE_DIRECTORY does not exit"
			missing_source
		fi

		if [ ! -d "$BACKUP_DESTINATION_DIRECTORY" ]; then
			echo "$BACKUP_DESTINATION_DIRECTORY does not exist"
			read -r -p "Do you wish to create the directory? (y/n) " DECISION

			case "$DECISION" in
				"y")
					mkdir -p "$BACKUP_DESTINATION_DIRECTORY"

					if [ $? -ne 0 ]; then
						echo "Creation of $BACKUP_DESTINATION_DIRECTORY failed."
						exit 1
					fi
					;;

				"n")
					echo "Aborting"
					exit 1
					;;
				*)
					echo "Unknown command. Aborting"
					exit 1
					;;
				esac
		fi		
		
		echo "Executing backup."
		execute_backup "$BACKUP_DESTINATION_DIRECTORY" "$BACKUP_SOURCE_DIRECTORY"				
		;;

	"archive")
		echo "Will archive"
		;;	
	
	"update")
		echo "Will update"
		;;

	"upgrade")
		echo "Will upgrade"
		;;

	"file-create")
		echo "Will create file"
		;;

	"file-update")
		echo "Will update file"
		;;

	"file-delete")
		echo "Will delete file"
		;;

	*)
		echo "Unknown command $COMMAND"
		echo "Usage:"
		echo "backup | archive | update | upgrade | file-create | file-update | file-delete"
		;;
esac		
