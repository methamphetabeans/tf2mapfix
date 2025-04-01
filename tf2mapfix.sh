#!/bin/bash
#	dont judge my code too much, its my first bash script, and i wrote this instead of sleeping.
#	if something breaks, send an email to thebeandev@gmail.com, or feel free to tinker with this yourself

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
TF2DIR="~/.steam/steam/steamapps/common"
TF2MAPSDIR=""
TF2CUSTOMDIR=""
ASK_REPLACE=false
SELECTED_FILES=""


show_help() {
	echo "TF2MAPFIX"
	echo ""
	echo "This script extracts map files using VPKEdit and copies the decompiled files to the 'tf/custom' directory to fix broken resources in game"
	echo "The script will check for the default location of TF2, however alternate installation locations will be saved to the config for use if necessary"
	echo ""
	echo "Usage: "
	echo "	tf2mapfix [arguments]"
	echo ""
	echo "Options: "
	echo "	Run command with no arguments to extract all downloaded TF2 maps and copy files to 'tf/custom'. If map files already exist in custom directory, they will be skipped."
	echo ""
	echo "	-f, --files			Extract specific TF2 maps and copy files to 'tf/custom'. You may input multiple maps with this flag."
	echo "	-a, --ask-replace		Ask to replace existing map files."
	echo "	-h, --help			Show this help message and exit."
	echo ""
	echo "	-a and -f may be ran together"
	echo ""
	echo "For support, or to report a bug, email thebeandev@gmail.com"
}

get_directory(){
	#if statement hell.

	# check if conf exists
	if [ -f "./tf2mapfixconfig" ]; then
		source tf2mapfixconfig

		# if exists, check if conf is correct
		# conf exists, is tf2 actually here?
		if [ -f "$TF2WORKINGDIR/tf_linux64" ]; then
			TF2WORKINGDIR=$(echo "$TF2WORKINGDIR" | sed 's/\\ / /g')
			TF2MAPSDIR="$TF2WORKINGDIR"tf/download/maps
			TF2CUSTOMDIR="$TF2WORKINGDIR"tf/custom

		# tf2 is not where the config says it is, get directory from scratch
		else
			directory_fallback
		fi
	# conf does not exist, get directory from scratch
	else
		directory_fallback
	fi

	# save directory location for future use
	echo "TF2WORKINGDIR=\"$TF2WORKINGDIR\"" > tf2mapfixconfig
}

directory_fallback(){
	if [ -f "$TF2DIR/tf_linux64" ]; then
		# if yes, continue
		TF2WORKINGDIR=$(echo "$TF2DIR" | sed 's/\\ / /g')
		TF2MAPSDIR="$TF2WORKINGDIR"tf/download/maps
		TF2CUSTOMDIR="$TF2WORKINGDIR"tf/custom
	else
		# if not, prompt for input until correct
		while [ ! -f "$TF2WORKINGDIR/tf_linux64" ]
		do
			read -rep $'TF2 Directory not found. Please input your TF2 Directory location \n(This will usually end with \'.../steamapps/common/Team Fortress 2\' use the Tab key to autocomplete and avoid issues with spaces) \n' TF2ALTDIR
			TF2WORKINGDIR=$(echo "$TF2ALTDIR" | sed 's/\\ / /g')
			TF2MAPSDIR="$TF2WORKINGDIR"tf/download/maps
			TF2CUSTOMDIR="$TF2WORKINGDIR"tf/custom
		done
	fi
}

select_files(){
	MAPFIXDIR=$(pwd)
	cd "$TF2MAPSDIR"
	read -rep $'What maps would you like to fix? (Autocomplete enabled) \n' MAPSELECTION
	cd "$MAPFIXDIR"
	echo $MAPSELECTION
}

copy_files(){
	if [ ! -d ./mapfiles ]; then
		mkdir ./mapfiles
	fi
	#for each bsp file, decompile and dump in local mapfiles dir, then move to tf2 custom dir. skip altogether if exists in custom dir.
	for filepath in $@; do
		filename=$(basename "$filepath")
			if [[ "$filename" == *.bsp ]]; then
			strippedname="${filename%.*}"
			if [ ! -d "$TF2CUSTOMDIR/$strippedname" ]; then
				echo "Extracting $filename..."
				./vpkeditcli -e / "$TF2MAPSDIR/$filename" -o "./mapfiles"
				echo "Copying map files to TF2 Custom directory..."
				cp -r ./mapfiles/"$strippedname" "$TF2CUSTOMDIR"
				echo -e "${GREEN}$strippedname done. ${NC}\n"
			elif [ -d "$TF2CUSTOMDIR/$strippedname" ]; then
				if [ "$ASK_REPLACE" = true ]; then
					echo -e "${YELLOW}$strippedname already found in custom directory. Would you like to replace the files? (y/n)${NC}"
					read REPLACE
					case "$REPLACE" in
					[yY]*)
						echo "Extracting $filename..."
						./vpkeditcli -e / "$TF2MAPSDIR/$filename" -o "./mapfiles"
						echo "Copying map files to TF2 Custom directory..."
						cp -r ./mapfiles/"$strippedname" "$TF2CUSTOMDIR"
						echo -e "${GREEN}$strippedname done. ${NC}\n"
						;;
					[nN]*)
						echo -e "Skipping.\n"
						;;
					esac
				else
					echo -e "${filename%.*} already present in TF2 custom directory. Skipping.\n"
				fi
			fi
		fi
	done

	#Cleanup
	if [ ! -z "$( ls -A './mapfiles' )" ]; then
		echo "Cleaning up Temporary Map files"
		rm -r ./mapfiles/*
		echo -e "${GREEN}Completed${NC}"
	fi
}

while getopts "haf" flag; do
	case "$flag" in
		h|--help)
			show_help
			exit 0
			;;
		a|--ask-replace)
			ASK_REPLACE=true
			;;
		f|--files)
			get_directory
			SELECTED_FILES=$(select_files)
			;;
		*)
			show_help
			exit 1
	esac
done

if [ -z "$SELECTED_FILES" ]; then
	get_directory
	copy_files $(find "$TF2MAPSDIR" -type f)
	exit 0
else
	copy_files "$SELECTED_FILES"
	exit 0
fi
