#!/bin/bash


arch="arm64"

appname=$(dialog --backtitle "Revancify" --title 'Select App' --no-items --ascii-lines --ok-label "Select" --menu "Select Option" 20 40 10 "YouTube" "YouTubeMusic" "Twitter" "Reddit" "TikTok" 2>&1> /dev/tty)

appver=($(python3 version-list.py "$appname"))
linkfetch=$(dialog --backtitle "Revancify" --title $appname --no-items --ascii-lines --ok-label "Select" --menu "Select App Version" 20 40 10 "${appver[@]}" 2>&1> /dev/tty)

if [ "$appname" = "" ]
then
    exit
elif [ "$appname" = "YouTube Music" ]
then
    appname="YouTubeMusic ${arch}"
    print $appname
fi

link=$(python3 fetch-link.py "$appname" "$linkfetch")
clear
echo $link