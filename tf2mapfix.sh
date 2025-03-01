#!/bin/bash
#	dont judge my code too much, its my first bash script, and i wrote this instead of sleeping.
#	if something breaks, send an email to thebeandev@gmail.com, or feel free to tinker with this yourself

GREEN='\033[0;32m'
NC='\033[0m'

TF2DIR="~/.steam/steam/steamapps/common/Team Fortress 2/"

function get_directory(){
	if [ -d "$TF2DIR" ]; then
		echo "$TF2DIR"
	else
		read -rep $'TF2 Directory not found at its default location. Please input your TF2 Directory location \n(This will usually end with \'.../steamapps/common/Team Fortress 2\' use the Tab key to autocomplete and avoid issues with spaces) \n' TF2ALTDIR
		DIRESCAPED=$(echo "$TF2ALTDIR" | sed 's/\\ / /g')
		echo "$DIRESCAPED"
	fi
}

#check if config exists
if [ -f "./tf2mapfixconfig" ]; then
	source tf2mapfixconfig
fi

#config exists, but couldnt get working directory for some reason
if [[ -z ${TF2WORKINGDIR+x} ]]; then

	TF2WORKINGDIR=$(get_directory)
fi

#working dir set but is wrong
while [ ! -f "$TF2WORKINGDIR/tf_linux64" ]
do

	echo -E "$TF2WORKINGDIR"
	TF2WORKINGDIR=$(get_directory)
done

if [ ! -d ./mapfiles ]; then
	mkdir ./mapfiles
fi

echo "TF2WORKINGDIR=\"$TF2WORKINGDIR\"" > tf2mapfixconfig

TF2MAPSDIR="$TF2WORKINGDIR/tf/download/maps"
TF2CUSTOMDIR="$TF2WORKINGDIR/tf/custom"

#for each bsp file, decompile and dump in local mapfiles dir, then move to tf2 custom dir. skip altogether if exists in custom dir.
for filepath in "$TF2MAPSDIR"/*; do
	filename=$(basename "$filepath")
	strippedname="${filename%.*}"
	if [ ! -d "$TF2CUSTOMDIR/$strippedname" ]; then
		echo "Extracting $filename..."
		./vpkeditcli -e / "$filepath" -o "./mapfiles"
		echo "Copying map files to TF2 Custom directory..."
		cp -r ./mapfiles/"$strippedname" "$TF2CUSTOMDIR"
		echo -e "${GREEN}$strippedname done. ${NC}\n"
	else
		echo -e "${filename%.*} already present in TF2 custom directory. Skipping.\n"
	fi
done

#Cleanup
if [ ! -z "$( ls -A './mapfiles' )" ]; then
	echo "Cleaning up Temporary Map files"
	rm -r ./mapfiles/*
fi