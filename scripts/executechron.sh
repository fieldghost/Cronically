#!/bin/bash


COMMAND=$1

if [ -z "$COMMAND" ]; then
	exit 1
fi

if [ "$COMMAND" = "backup" ]; then
	SOURCE_DIR=$2
	DESTINATION_DIR=$3
	TIME_SPECIFICATION=$4
	if [ -z "$SOURCE_DIR" ]; then
		echo "Missing source directory"
		exit 1
	fi

	if [ -z "$DESTINATION_DIR" ]; then
		echo "Missing destination directory"
		exit 1
	fi

	if [ -z "$TIME_SPECIFICATION" ]; then
		echo "Missing time specification. Example:"
		echo "./autochron backup /source/directory /target/directory 14:00" 
		exit 1

	fi

	DAY=$(date +%F)
	FILE_NAME="$DAY.tgz"

	
fi
	
#EXAMPLE	0 14 * * * tar czf "$1"/"$FILE_NAME" "$2" >/dev/null 2>&1		
