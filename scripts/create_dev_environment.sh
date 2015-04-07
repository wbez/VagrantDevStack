#!/bin/bash

GIT_URL="git@github.com:wbez/VagrantDevStack.git"
GIT_CMD=`which git`

if [ $# -eq 0 ]
then
	echo "No folder name provided"
elif [ -d $1 ]
then
	echo "Folder $1 exists"
elif [ -z "$GIT_CMD" ]
then
	echo "Git is not installed on this machine"
else
	$GIT_CMD clone $GIT_URL ./$1
	cd ./$1
	rm -Rf .git .gitignore
fi
