#!/bin/bash
#Written by Sarah Williams 2020

if ! command -v spotdl &> /dev/null
then
    echo "Please make sure the Spotify-Downloader has been installed."
    exit
fi

echo "Options: Album, Artist, Song, Playlist, User"
read option

if [ $option = "Album" ] || [ $option = "album" ]
then
    echo "Paste spotify album link"
    read album_link
    spotdl -a $album_link --write-to ~/Music/temp-list.txt        #create list of album songs
    spotdl -l ~/Music/temp-list.txt -q best --overwrite skip -f ~/Music/{artist}/{album}/{track-name}.{output-ext}
    rm ~/Music/temp-list.txt
elif [ $option = "Artist" ] || [ $option = "artist" ]
then
    echo "Paste spotify Artist link"
    read artist_link
    spotdl -aa $artist_link --write-to ~/Music/temp-list.txt     #create list of artist songs
    spotdl -l ~/Music/temp-list.txt -q best --overwrite skip -f ~/Music/{artist}/{album}/{track-name}.{output-ext}
    rm ~/Music/temp-list.txt
elif [ $option = "Song" ] || [ $option = "song" ]
then
    echo "Paste spotify Song link"
    read song_link
    spotdl -s $song_link -q best -f ~/Music/{artist}/{album}/{track-name}.{output-ext}
elif [ $option = "Playlist" ] || [ $option = "playlist" ]
then
    echo "Paste spotify Playlist link"
    read playlist_link
    spotdl -p $playlist_link --write-to ~/Music/temp-list.txt
    spotdl -l ~/Music/temp-list.txt -q best --overwrite skip -f ~/Music/{artist}/{album}/{track-name}.{output-ext}
    rm ~/Music/temp-list.txt
elif [ $option = "User" ] || [ $option = "user" ]
then
    echo "Paste spotify Username"
    read user_link
    spotdl -u $user_link --write-to ~/Music/temp-list.txt
    spotdl -l ~/Music/temp-list.txt -q best --overwrite skip -f ~/Music/{artist}/{album}/{track-name}.{output-ext}
    rm ~/Music/temp-list.txt
else
    echo "please enter a valid option"
fi


#spotdl -l temp-list.txt -q best -f ~/Music/{artist}/{album}/{track-name}.{output-ext}        #download from list best quality mp3
