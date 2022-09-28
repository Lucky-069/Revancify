from fetcher import fetch
import re
import sys


def bsurl(url):
    return fetch(url).bsurl()



if sys.argv[1] == "YouTube":

    appurl = "".join(["https://www.apkmirror.com/apk/google-inc/youtube/youtube-", sys.argv[2].replace(".","-"), "-release/"])

    apppage1= "".join(["https://apkmirror.com", bsurl(appurl).find(["span"], text="APK").parent.find(["a"], class_="accent_color")['href']])



elif sys.argv[1] == "YouTubeMusic":

    appurl = "".join(["https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-", sys.argv[2].replace(".","-"), "-release/"])

    if sys.argv[3] == "arm64":

        apppage1 = "".join(["https://www.apkmirror.com", bsurl(appurl).find(["div"], text="arm64-v8a").parent.find(["a"], class_="accent_color")['href']])

    elif sys.argv[3] == "armeabi":

        apppage1 = "".join(["https://www.apkmirror.com", bsurl(appurl).find(["div"], text="armeabi-v7a").parent.find(["a"], class_="accent_color")['href']])



elif sys.argv[1] == "Twitter":

        appurl = "".join(["https://www.apkmirror.com/apk/twitter-inc/twitter/twitter-", sys.argv[2].replace(".","-"), "-release/"])

        apppage1= "".join(["https://apkmirror.com", bsurl(appurl).find(["span"], text="APK").parent.find(["a"], class_="accent_color")['href']])


elif sys.argv[1] == "Reddit":

    appurl = "".join(["https://www.apkmirror.com/apk/reddditinc/reddit/reddit-", sys.argv[2].replace(".","-"), "-release/"])

    apppage1= "".join(["https://apkmirror.com", bsurl(appurl).find(["span"], text="APK").parent.find(["a"], class_="accent_color")['href']])

elif sys.argv[1] == "Tiktok":

    appurl = "".join(["https://www.apkmirror.com/apk/tiktok-pte-ltd/tik-tok/tik-tok-", sys.argv[2].replace(".","-"), "-release/"])

    apppage1= "".join(["https://apkmirror.com", bsurl(appurl).find(["span"], text="APK").parent.find(["a"], class_="accent_color")['href']])



apppage2= "".join(["https://apkmirror.com", bsurl(apppage1).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href']])

appdllink = "".join(["https://apkmirror.com", bsurl(apppage2).find(rel="nofollow")['href']])


print(appdllink)