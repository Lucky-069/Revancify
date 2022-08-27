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
    for a in ((BeautifulSoup((urlopen(Request(url="https://www.apkmirror.com/apk/google-inc/youtube/", headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find_all(["a"], class_="fontBlack", text=re.compile("^YouTube.((?!beta).)*$"))):
        ytverlist.append(a.string) 
    ytver = ((str(ytverlist[0])).split(' ')[1]).replace(".", "-")
    yturl = "https://www.apkmirror.com/apk/google-inc/youtube/youtube-"+ytver+"-release/"

    ytpage1= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=yturl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])

    ytpage2= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=ytpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svf"], class_="icon download-button-icon")).parent)['href'])

    ytdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=ytpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])
    
    with open("latest.txt", "a") as f:
        f.write(ytver + '\n' + ytdllink)

# YouTube Root

def yt_root():
    ytver = (sys.argv[3]).replace(".","-")
    yturl = "https://www.apkmirror.com/apk/google-inc/youtube/youtube-"+ytver+"-release/"

    ytpage1= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=yturl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])

    ytpage2= "https://apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=ytpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href'])

    ytdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=ytpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])
    
    with open("latest.txt", "a") as f:
        f.write(ytver + '\n' + ytdllink)


# YouTube Music Non Root

def ytm_non_root():
    arch = sys.argv[3]
    for a in ((BeautifulSoup((urlopen(Request(url="https://www.apkmirror.com/apk/google-inc/youtube-music/", headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find_all(["a"], class_="fontBlack", text=re.compile("YouTube.*"))):
        ytmverlist.append(a.string)
    ytmver = (((ytmverlist[1]).split(' '))[2]).replace(".", "-")
    # arch = arm64
    def arm64():
        ytmurl = "https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-"+ytmver+"-release/"

        pagelink1 = "https://www.apkmirror.com" + ((((BeautifulSoup((urlopen(Request(url=ytmurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["div"], text="arm64-v8a")).parent).find(["a"], class_="accent_color"))['href']

        pagelink2 = "https://www.apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=pagelink1, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(["svg"], class_="icon download-button-icon")).parent)['href']

        ytmdllink = "https://apkmirror.com" + (((BeautifulSoup((urlopen(Request(url=pagelink2, headers={'User-Agent': 'Mozilla/5.0'})).read()), "html.parser")).find(rel="nofollow"))['href'])

        with open("latest.txt", "a") as f:
            f.write(ytmver + '\n' + ytmdllink)

    # arch = armeabi
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

# YouTube Music Root        
        
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

# Twitter for both
        
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
