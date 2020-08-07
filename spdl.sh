#!/bin/bash
#Written by Sarah Williams 2020


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
    #TD-Format
    echo "You are running as root, this is not recommended, would you like to continue? y/N?:"
    read -r  cont
    case "$cont" in
	y|Y)
	    echo "Running as root"
	    ;;
	n|N)
	    exit 02
	    ;;
	*)
	    exit 02
	    ;;
    esac
fi


echo "Options: Album, Artist, Song, Playlist, User	(default: Playlist)"
read -r option

#Default to Playlist if $option is empty
if [ -z "$option" ] 
then
    option="Playlist"
fi

echo ""

echo "Enter output directory	(default: $HOME/Music)"
read -r dir

if [ -z "$dir" ]						#if $dir is empty
then
    dir=$HOME/Music
    if [ ! -d "$dir" ]						#if $dir doesnt exist
    then
	mkdir "$dir"
	echo "$dir directory has been created and set"
    elif [ -d "$dir" ]						#if $dir does exist
    then
	echo "Directory has been set to $dir"
    else
	echo "dir error {empty}"	
	exit 02
    fi
elif [ ! -z "$dir" ]						#if $dir is not empty
then
    cd $HOME			
    if [ ! -d "$dir" ]						#if $dir doesnt exist
    then
        mkdir -p "$dir"  
	if [ $? = 1 ]						#if mkdir fails
	then
	    echo "dir make error, mkdir exit code $?"
	    exit 02
	fi
        echo "$dir directory has been created and set"
    elif [ -d "$dir" ]						#if $dir exists
    then
        echo "Directory has been set to $dir"
    else
        echo "$dir error {user input}"
	exit 02
    fi
else
   echo "dir error {0000x0001}"
   exit 02
fi


    
if [ $option = "Album" ] || [ $option = "album" ]
then
    echo "Paste spotify album link"
    read album_link
    spotdl -a $album_link --write-to "$dir"        #create list of album songs
    spotdl -l ~/Music/temp-list.txt -q best --overwrite skip -f "$dir"/{artist}/{album}/{track-name}.{output-ext}
    rm "$dir"/temp-list.txt
elif [ $option = "Artist" ] || [ $option = "artist" ]
then
    echo "Paste spotify Artist link"
    read artist_link
    spotdl -aa $artist_link --write-to "$dir"/temp-list.txt     #create list of artist songs
    spotdl -l "$dir"/temp-list.txt -q best --overwrite skip -f "$dir"/{artist}/{album}/{track-name}.{output-ext}
    rm "$dir"/temp-list.txt
elif [ $option = "Song" ] || [ $option = "song" ]
then
    echo "Paste spotify Song link"
    read song_link
    spotdl -s $song_link -q best -f "$dir"/{artist}/{album}/{track-name}.{output-ext}
elif [ $option = "Playlist" ] || [ $option = "playlist" ]
then
    echo "Paste spotify Playlist link"
    read playlist_link
    spotdl -p $playlist_link --write-to "$dir"/temp-list.txt
    spotdl -l "$dir"/temp-list.txt -q best --overwrite skip -f "$dir"/{artist}/{album}/{track-name}.{output-ext}
    rm "$dir"/temp-list.txt
elif [ $option = "User" ] || [ $option = "user" ]
then
    echo "Paste spotify Username"
    read user_link
    spotdl -u $user_link --write-to "$dir"/temp-list.txt
    spotdl -l "$dir"/temp-list.txt -q best --overwrite skip -f "$dir"/{artist}/{album}/{track-name}.{output-ext}
    rm "$dir"/temp-list.txt
else
    echo "please enter a valid option"
fi


#spotdl -l temp-list.txt -q best -f ~/Music/{artist}/{album}/{track-name}.{output-ext}        #download from list best quality mp3
