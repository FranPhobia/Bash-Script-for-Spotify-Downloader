#!/bin/bash
#Written by Sarah Williams 2020
#Copyright GNU

#Check if spotifydl is installed
if ! command -v spotdl &> /dev/null
then
    echo "Please make sure the Spotify-Downloader has been installed."
    echo "$ pip3 install spotdl"
    exit 127
fi

#Check if running as root (NOT RECOMMENDED, UNKNOWN HOW SPOTDL WILL BEHAVE AS ROOT)
if [ "$EUID" = 0 ]
then
	echo "You are running as root, this is not recommended,"
fi

while [ -z  "$supr" ]
do
	if [ "$EUID" = 0 ]
	then
		read -sp "would you like to continue y/N?: " -n 1 cont
    	case "$cont" in
		y|Y)
		    printf "\nRunning as root\n"
			supr=1
		    ;;
		n|N)
		    exit 02
		    ;;
		*)
		    printf "\noption not recognized\n"
	    	;;
	    esac
	else
		supr=1
	fi
done

while [ -z "$selection_download" ] 
do
	echo "Options: Album, Artist, Song, Playlist, User		(default: Playlist)"
	read -r option
	case "$option" in
		album|Album|alb|Alb|1)
			selection_download=1
			;;
		artist|Artist|art|Art|2)
			selection_download=2
			;;
		song|Song|s|S|3)
			selection_download=3
			;;
		playlist|Playlist|play|Play|p|P|4)
			selection_download=4
			;;
		user|User|usr|Usr|u|U|5)
			selection_download=5
			;;
		"")
			selection_download=4
			;;
		*)
			echo "Error $option not recognized" 
			;;
	esac
done


dir_selection=0

while [ "$dir_selection" = 0 ]
do
	echo "Enter output directory	(default: $HOME/Music)"
	read -r dir

	if [ -z "$dir" ]						#if $dir is empty
	then
	    dir="$HOME"/Music
		dir_selection=1
	    if [ ! -d "$dir" ]						#if $dir doesnt exist
	    then
			mkdir "$dir"
			if [ "$?" = 1 ]
			then
				echo "mkdir exit code $?"
				dir_selection=0
			fi
	    fi
	elif [ ! -z "$dir" ]						#if $dir is not empty
	then
		dir_selection=1
	    if [ ! -d "$dir" ]						#if $dir doesnt exist
	    then
			cd "$HOME"
	        mkdir -p "$dir"
			if [ "$?" = 1 ]						#if mkdir fails
			then
		    	echo "mkdir exit code $?"
				dir_selection=0
			fi
		fi
	fi
done

if [ "$selection_download" = 1 ]
then
    echo "Paste spotify album link"
    read album_link
    spotdl -a "$album_link" --write-to "$dir"        #create list of album songs
    spotdl -l ~/Music/temp-list.txt -q best --overwrite skip -f "$dir"/{artist}/{album}/{track-name}.{output-ext}
    rm "$dir"/temp-list.txt
elif [ "$selection_download" = 2 ]
then
    echo "Paste spotify Artist link"
    read artist_link
    spotdl -aa "$artist_link" --write-to "$dir"/temp-list.txt     #create list of artist songs
    spotdl -l "$dir"/temp-list.txt -q best --overwrite skip -f "$dir"/{artist}/{album}/{track-name}.{output-ext}
    rm "$dir"/temp-list.txt
elif [ "$selection_download" = 3 ]
then
    echo "Paste spotify Song link or Search song"
    IFS= read -r song_link
    spotdl -s "$song_link" -q best -f "$dir"/{artist}/{album}/{track-name}.{output-ext}
elif [ "$selection_download" = 4 ]
then
    echo "Paste spotify Playlist link"
    read playlist_link
    spotdl -p "$playlist_link" --write-to "$dir"/temp-list.txt
    spotdl -l "$dir"/temp-list.txt -q best --overwrite skip -f "$dir"/{artist}/{album}/{track-name}.{output-ext}
    rm "$dir"/temp-list.txt
elif [ "$selection_download" = 5 ]
then
    echo "Paste spotify Username"
    read user_link
    spotdl -u "$user_link" --write-to "$dir"/temp-list.txt
    spotdl -l "$dir"/temp-list.txt -q best --overwrite skip -f "$dir"/{artist}/{album}/{track-name}.{output-ext}
    rm "$dir"/temp-list.txt
else
    echo "Error selection var"
fi
