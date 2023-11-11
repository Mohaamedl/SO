#!/bin/bash
# This script checks the existence of a file
echo "Checking..."
(( $# ==1 )) || { echo -e "so permite um ficheiro" >&2;exit 1 }
if [[ -a $1 ]];
then
	if [[ -f $1 ]]; then
		echo "é ficheiro normal"
	elif [[ -d $1 ]]
		echo "é uma diretoria"
	
	echo "permissoes"
	[[ -r $1]]
	[[ -w $1 ]]
	[[ -x $1 ]]
	

else
echo "$1 não existe"
fi
echo "...done."
