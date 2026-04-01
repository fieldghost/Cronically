#!/bin/bash


COMMAND=$1

if [ -z "$COMMAND" ]; then
	exit 1
fi

if [ "$COMMAND" = "backup" ]; then
	SOURCE_DIR=$2
	DESTINATION_DIR=$3
	TIME_SPECIFICATION=$4

	if [ -z "$SOURCE_DIR" ] || [ -z "$DESTINATION_DIR" ] || [ -z "$TIME_SPECIFICATION" ]; then
		echo "Missing arguments. Expected: <command> /source/path /destionation/path time"  	
		exit 1
	fi

	HOUR="${TIME_SPECIFICATION%:*}"
	MINUTE="${TIME_SPECIFICATION#*:}"

	CRON_COMMAND="tar czf $DESTINATION_DIR/backup_\$(date +\\%A).tgz $SOURCE_DIR >/dev/null 2>&1"
	CRON_JOB="$MINUTE $HOUR * * * $CRON_COMMAND"	

	TEMP_CRON=$(mktemp)

	crontab -l 2>/dev/null | grep -v "no crontab" > $TEMP_CRON
	
	echo "$CRON_JOB" >> $TEMP_CRON
	crontab "$TEMP_CRON" 
	CRON_STATUS=$?

	#CLEANUP TEMP FILE	
	rm "$TEMP_CRON"

	if [ "$CRON_STATUS" -eq 0 ]; then
		exit 0
	else
		exit 1
	fi

fi
