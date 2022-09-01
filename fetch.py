import requests
from html.parser import HTMLParser
from urllib.request import Request, urlopen
from bs4 import BeautifulSoup
import re
import sys

appname = sys.argv[1]
variant = sys.argv[2]




patches_version = (((requests.get('https://api.github.com/repos/revanced/revanced-patches/releases/latest')).json())['name']).replace("v","")
cli_version = (((requests.get('https://api.github.com/repos/revanced/revanced-cli/releases/latest')).json())['name']).replace("v","")
integrations_version = (((requests.get('https://api.github.com/repos/revanced/revanced-integrations/releases/latest')).json())['name']).replace("v","")
with open("latest.txt", "w") as f:
    f.write(patches_version + '\n' + cli_version + '\n' + integrations_version  + '\n')


ytverlist = []
ytmverlist = []

# YouTube NonRoot

def yt_non_root():
    patchesjson = (requests.get('https://raw.githubusercontent.com/revanced/revanced-patches/main/patches.json')).json()
    for i in patchesjson:
        if i['name'] == 'swipe-controls':
            ytver = ((((i['compatiblePackages'])[0])['versions'])[-1]).replace(".","-")
            break
    yturl = "https://www.apkmirror.com/apk/google-inc/youtube/youtube-"+ytver+"-release/"

    ytpage1= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=yturl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])

    ytpage2= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=ytpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["span"], class_="downloadButtonSubtitle")).parent)['href'])

    ytdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=ytpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])
    
    mgpage1 = "https://www.apkmirror.com/apk/team-vanced/microg-youtube-vanced/microg-youtube-vanced-0-2-24-220220-release/vanced-microg-0-2-24-220220-android-apk-download/"

    mgpage2= "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=mgpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

    mgdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=mgpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

    with open("latest.txt", "a") as f:
        f.write(ytver + '\n' + ytdllink + '\n' + mgdllink)

# YouTube Root

def yt_root():
    ytver = (sys.argv[3]).replace(".","-")
    yturl = "https://www.apkmirror.com/apk/google-inc/youtube/youtube-"+ytver+"-release/"

    ytpage1= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=yturl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])

    ytpage2= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=ytpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["span"], class_="downloadButtonSubtitle")).parent)['href'])

    ytdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=ytpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])
    
    with open("latest.txt", "a") as f:
        f.write(ytver + '\n' + ytdllink)


# YouTube Music Non Root

def ytm_non_root():
    arch = sys.argv[3]
    patchesjson = (requests.get('https://raw.githubusercontent.com/revanced/revanced-patches/main/patches.json')).json()
    for i in patchesjson:
        if i['name'] == 'compact-header':
            ytmver = ((((i['compatiblePackages'])[0])['versions'])[-1]).replace(".","-")
            break
    # arch = arm64
    def arm64():
        ytmurl = "https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-"+ytmver+"-release/"

        pagelink1 = "https://www.apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=ytmurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["div"], text="arm64-v8a")).parent).find(["a"], class_="accent_color"))['href']

        pagelink2 = "https://www.apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=pagelink1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

        ytmdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=pagelink2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

        mgpage1 = "https://www.apkmirror.com/apk/team-vanced/microg-youtube-vanced/microg-youtube-vanced-0-2-24-220220-release/vanced-microg-0-2-24-220220-android-apk-download/"

        mgpage2= "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=mgpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

        mgdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=mgpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

        with open("latest.txt", "a") as f:
            f.write(ytmver + '\n' + ytmdllink + '\n' + mgdllink)

    # arch = armeabi
    def armeabi():
        
        ytmurl = "https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-"+ytmver+"-release/"

        pagelink1 = "https://www.apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=ytmurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["div"], text="armeabi-v7a")).parent).find(["a"], class_="accent_color"))['href']

        pagelink2 = "https://www.apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=pagelink1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

        ytmdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=pagelink2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

        mgpage1 = "https://www.apkmirror.com/apk/team-vanced/microg-youtube-vanced/microg-youtube-vanced-0-2-24-220220-release/vanced-microg-0-2-24-220220-android-apk-download/"

        mgpage2= "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=mgpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

        mgdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=mgpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

        with open("latest.txt", "a") as f:
            f.write(ytmver + '\n' + ytmdllink + '\n' + mgdllink)

    if arch == "arm64":
        arm64()
    elif arch == "armeabi":
        armeabi()

def ytm_root():
    arch = sys.argv[3]
    ytmver = sys.argv[4]
    def arm64():
        ytmurl = "https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-"+ytmver+"-release/"

        pagelink1 = "https://www.apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=ytmurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["div"], text="arm64-v8a")).parent).find(["a"], class_="accent_color"))['href']

        pagelink2 = "https://www.apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=pagelink1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

        ytmdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=pagelink2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

        with open("latest.txt", "a") as f:
            f.write(ytmver + '\n' + ytmdllink)

    def armeabi():
        
        ytmurl = "https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-"+ytmver+"-release/"

        pagelink1 = "https://www.apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=ytmurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["div"], text="armeabi-v7a")).parent).find(["a"], class_="accent_color"))['href']

        pagelink2 = "https://www.apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=pagelink1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

        ytmdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=pagelink2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

        with open("latest.txt", "a") as f:
            f.write(ytmver + '\n' + ytmdllink)

    if arch == "arm64":
        arm64()
    elif arch == "armeabi":
        armeabi()

def twitter():
    for a in ((BeautifulSoup((urlopen(Request(url="https://www.apkmirror.com/apk/twitter-inc/", headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find_all(["a"], class_="fontBlack", text=re.compile("^.*.release*"))):
        ytverlist.append(a.string) 
    twver = ((str(ytverlist[0])).split(' ')[1]).replace(".", "-")
    twurl = "https://www.apkmirror.com/apk/twitter-inc/twitter/twitter-"+twver+"-release/"

    twpage1= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=twurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])

    twpage2= "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=twpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

    twdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=twpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

    with open("latest.txt", "a") as f:
            f.write(twver + '\n' + twdllink)

def reddit():
    for a in ((BeautifulSoup((urlopen(Request(url="https://www.apkmirror.com/apk/redditinc/", headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find_all(["a"], class_="fontBlack")):
        ytverlist.append(a.string) 
    rdver = ((str(ytverlist[0])).split(' ')[1]).replace(".", "-")
    rdurl = "https://www.apkmirror.com/apk/reddditinc/reddit/reddit-"+rdver+"-release/"

    rdpage1= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=rdurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])

    rdpage2= "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=rdpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

    rddllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=rdpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

    with open("latest.txt", "a") as f:
            f.write(rdver + '\n' + rddllink)

def tiktok():
    for a in ((BeautifulSoup((urlopen(Request(url="https://www.apkmirror.com/uploads/?appcategory=tik-tok/",headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find_all(["a"], class_="fontBlack")):
        ytverlist.append(a.string) 
    ttver = ((str(ytverlist[0])).split(' ')[1]).replace(".", "-")
    tturl = "https://www.apkmirror.com/apk/tiktok-pte-ltd/tik-tok/tik-tok-"+ttver+"-release/"

    ttpage1= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=tturl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])

    ttpage2= "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=ttpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

    ttdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=ttpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

    with open("latest.txt", "a") as f:
            f.write(ttver + '\n' + ttdllink)




if appname == "yt" and variant == "non_root":
    yt_non_root()
elif appname == "yt" and variant == "root":
    yt_root()
elif appname == "ytm" and variant == "non_root":
    ytm_non_root()
elif appname == "ytm" and variant == "root":
    ytm_root()
elif appname == "twitter" and variant == "both":
    twitter()
elif appname == "reddit" and variant == "both":
    reddit()
elif appname == "tiktok" and variant == "both":
    tiktok()
