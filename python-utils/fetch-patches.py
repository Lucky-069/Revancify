import requests
import html.parser
from urllib.request import Request, urlopen
from bs4 import BeautifulSoup
import re
import sys

if sys.argv[1] == "yt":
    for i in (requests.get('https://raw.githubusercontent.com/revanced/revanced-patches/main/patches.json')).json():
        if i['name'] == 'swipe-controls':
            appver = ((((i['compatiblePackages'])[0])['versions'])[-1])
            break
elif sys.argv[1] == "ytm":
    for i in (requests.get('https://raw.githubusercontent.com/revanced/revanced-patches/main/patches.json')).json():
        if i['name'] == 'compact-header':
            appver = ((((i['compatiblePackages'])[0])['versions'])[-1])
            break