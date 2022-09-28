import requests
import sys

if sys.argv[1] == "yt":

    open("youtube-patches.txt", "w").close()

    for i in (requests.get('https://raw.githubusercontent.com/revanced/revanced-patches/main/patches.json')).json():
        if (((i['compatiblePackages'])[0])['name']) == "com.google.android.youtube" and i['deprecated'] != True:
            with open("youtube-patches.txt", "a") as p:
                p.write(str(i['name']) + " " + "on" + "\n")

elif sys.argv[1] == "ytm":
    open("youtubemusic-patches.txt", "w").close()
    for i in (requests.get('https://raw.githubusercontent.com/revanced/revanced-patches/main/patches.json')).json():
        if (((i['compatiblePackages'])[0])['name']) == "com.google.android.apps.youtube.music" and i['deprecated'] != True:
            with open("youtubemusic-patches.txt", "a") as p:
                p.write(str(i['name']) + " " + "on" + "\n")