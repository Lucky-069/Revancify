import requests
import lxml
from urllib.request import Request, urlopen
from bs4 import BeautifulSoup
import cchardet
import re
import sys

appname = sys.argv[1]
variant = sys.argv[2]


requests_session = requests.Session()
patches_version = (((requests_session.get('https://api.github.com/repos/revanced/revanced-patches/releases/latest')).json())['name']).replace("v","")
cli_version = (((requests_session.get('https://api.github.com/repos/revanced/revanced-cli/releases/latest')).json())['name']).replace("v","")
integrations_version = (((requests_session.get('https://api.github.com/repos/revanced/revanced-integrations/releases/latest')).json())['name']).replace("v","")



# YouTube NonRoot

def yt_non_root():
    for i in (requests.get('https://raw.githubusercontent.com/revanced/revanced-patches/main/patches.json')).json():
        if i['name'] == 'swipe-controls':
            ytver = ((((i['compatiblePackages'])[0])['versions'])[-1]).replace(".","-")
            break
    yturl = "".join(["https://www.apkmirror.com/apk/google-inc/youtube/youtube-", ytver, "-release/"])

    ytpage1= "".join(["https://apkmirror.com", ((((BeautifulSoup((urlopen(Request(url=yturl, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])])

    ytpage2= "".join(["https://apkmirror.com", ((BeautifulSoup((urlopen(Request(url=ytpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href'])])

    ytdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=ytpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])
    
    mgpage1 = "https://www.apkmirror.com/apk/team-vanced/microg-youtube-vanced/microg-youtube-vanced-0-2-24-220220-release/vanced-microg-0-2-24-220220-android-apk-download/"

    mgpage2= "".join(["https://apkmirror.com", ((((BeautifulSoup((urlopen(Request(url=mgpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["svg"], class_="icon download-button-icon")).parent)['href'])])

    mgdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=mgpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

    with open("latest.txt", "w") as f:
        f.write('\n'.join([patches_version, cli_version, integrations_version, ytver, ytdllink, mgdllink]))


# YouTube Root

def yt_root():
    ytver = (sys.argv[3]).replace(".","-")
    yturl = "".join(["https://www.apkmirror.com/apk/google-inc/youtube/youtube-", ytver, "-release/"])

    ytpage1= "".join(["https://apkmirror.com", ((((BeautifulSoup((urlopen(Request(url=yturl, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])])

    ytpage2= "".join(["https://apkmirror.com", ((BeautifulSoup((urlopen(Request(url=ytpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href'])])

    ytdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=ytpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

    with open("latest.txt", "w") as f:
        f.write('\n'.join([patches_version, cli_version, integrations_version, ytver, ytdllink]))



# YouTube Music Non Root

def ytm_non_root():
    arch = sys.argv[3]
    for i in (requests.get('https://raw.githubusercontent.com/revanced/revanced-patches/main/patches.json')).json():
        if i['name'] == 'compact-header':
            ytmver = ((((i['compatiblePackages'])[0])['versions'])[-1]).replace(".","-")
            break
    # arch = arm64
    def arm64():
        ytmurl = "".join(["https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-", ytmver, "-release/"])

        ytmpage1 = "".join(["https://www.apkmirror.com", (((((BeautifulSoup((urlopen(Request(url=ytmurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["div"], text="arm64-v8a")).parent).find(["a"], class_="accent_color"))['href'])])

        ytmpage2 = "".join(["https://www.apkmirror.com", ((BeautifulSoup((urlopen(Request(url=ytmpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href'])])

        ytmdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=ytmpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

        mgpage1 = "https://www.apkmirror.com/apk/team-vanced/microg-youtube-vanced/microg-youtube-vanced-0-2-24-220220-release/vanced-microg-0-2-24-220220-android-apk-download/"

        mgpage2= "".join(["https://apkmirror.com", ((((BeautifulSoup((urlopen(Request(url=mgpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["svg"], class_="icon download-button-icon")).parent)['href'])])

        mgdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=mgpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

        with open("latest.txt", "w") as f:
            f.write('\n'.join([patches_version, cli_version, integrations_version, ytmver, ytmdllink, mgdllink]))


    # arch = armeabi
    def armeabi():
        ytmurl = "".join(["https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-", ytmver, "-release/"])

        ytmpage1 = "".join(["https://www.apkmirror.com", (((((BeautifulSoup((urlopen(Request(url=ytmurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["div"], text="armeabi-v7a")).parent).find(["a"], class_="accent_color"))['href'])])

        ytmpage2 = "".join(["https://www.apkmirror.com", ((BeautifulSoup((urlopen(Request(url=ytmpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href'])])

        ytmdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=ytmpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

        mgpage1 = "https://www.apkmirror.com/apk/team-vanced/microg-youtube-vanced/microg-youtube-vanced-0-2-24-220220-release/vanced-microg-0-2-24-220220-android-apk-download/"

        mgpage2= "".join(["https://apkmirror.com", ((((BeautifulSoup((urlopen(Request(url=mgpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["svg"], class_="icon download-button-icon")).parent)['href'])])

        mgdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=mgpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

        with open("latest.txt", "w") as f:
            f.write('\n'.join([patches_version, cli_version, integrations_version, ytmver, ytmdllink, mgdllink]))


    if arch == "arm64":
        arm64()
    elif arch == "armeabi":
        armeabi()

def ytm_root():
    arch = sys.argv[3]
    ytmver = sys.argv[4]
    def arm64():
        ytmurl = "".join(["https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-", ytmver, "-release/"])

        ytmpage1 = "".join(["https://www.apkmirror.com", (((((BeautifulSoup((urlopen(Request(url=ytmurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["div"], text="arm64-v8a")).parent).find(["a"], class_="accent_color"))['href'])])

        ytmpage2 = "".join(["https://www.apkmirror.com", ((BeautifulSoup((urlopen(Request(url=ytmpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href'])])

        ytmdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=ytmpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

        with open("latest.txt", "w") as f:
            f.write('\n'.join([patches_version, cli_version, integrations_version, ytmver, ytmdllink]))

    def armeabi():
        ytmurl = "".join(["https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-", ytmver, "-release/"])

        ytmpage1 = "".join(["https://www.apkmirror.com", (((((BeautifulSoup((urlopen(Request(url=ytmurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["div"], text="armeabi-v7a")).parent).find(["a"], class_="accent_color"))['href'])])

        ytmpage2 = "".join(["https://www.apkmirror.com", ((BeautifulSoup((urlopen(Request(url=ytmpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href'])])

        ytmdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=ytmpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

        with open("latest.txt", "w") as f:
            f.write('\n'.join([patches_version, cli_version, integrations_version, ytmver, ytmdllink]))
    if arch == "arm64":
        arm64()
    elif arch == "armeabi":
        armeabi()

def twitter():
    for a in ((BeautifulSoup((urlopen(Request(url="https://www.apkmirror.com/apk/twitter-inc/", headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find_all(["a"], class_="fontBlack", text=re.compile("^.*.release*"))):
        twver = ((a.string).split(' ')[1]).replace(".", "-")
        break
    twurl = "".join(["https://www.apkmirror.com/apk/twitter-inc/twitter/twitter-", twver, "-release/"])

    twpage1= "".join(["https://apkmirror.com", ((((BeautifulSoup((urlopen(Request(url=twurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])])

    twpage2= "".join(["https://apkmirror.com", ((BeautifulSoup((urlopen(Request(url=twpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href'])])

    twdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=twpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

    with open("latest.txt", "w") as f:
        f.write('\n'.join([patches_version, cli_version, integrations_version, twver, twdllink]))


def reddit():
    for a in ((BeautifulSoup((urlopen(Request(url="https://www.apkmirror.com/apk/redditinc/", headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find_all(["a"], class_="fontBlack")): 
        rdver = ((a.string).split(' ')[1]).replace(".", "-")
        break
    rdurl = "".join(["https://www.apkmirror.com/apk/reddditinc/reddit/reddit-", rdver, "-release/"])

    rdpage1= "".join(["https://apkmirror.com", ((((BeautifulSoup((urlopen(Request(url=rdurl, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])])

    rdpage2= "".join(["https://apkmirror.com", ((BeautifulSoup((urlopen(Request(url=rdpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href'])])

    rddllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=rdpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

    with open("latest.txt", "w") as f:
        f.write('\n'.join([patches_version, cli_version, integrations_version, rdver, rddllink]))


def tiktok():
    for a in ((BeautifulSoup((urlopen(Request(url="https://www.apkmirror.com/uploads/?appcategory=tik-tok/",headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find_all(["a"], class_="fontBlack")):
        ttver = ((a.string).split(' ')[1]).replace(".", "-")
        break

    tturl = "".join(["https://www.apkmirror.com/apk/tiktok-pte-ltd/tik-tok/tik-tok-", ttver, "-release/"])

    ttpage1= "".join(["https://apkmirror.com", ((((BeautifulSoup((urlopen(Request(url=tturl, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["span"], text="APK")).parent).find(["a"], class_="accent_color")['href'])])

    ttpage2= "".join(["https://apkmirror.com", ((BeautifulSoup((urlopen(Request(url=ttpage1, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(["a"], { 'class' : re.compile("accent_bg btn btn-flat downloadButton")})['href'])])

    ttdllink = "".join(["https://apkmirror.com", (((BeautifulSoup((urlopen(Request(url=ttpage2, headers={'User-Agent': 'Mozilla/5.0'})).read()), 'lxml')).find(rel="nofollow"))['href'])])

    with open("latest.txt", "w") as f:
            f.write('\n'.join([patches_version, cli_version, integrations_version, ttver, ttdllink]))





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
