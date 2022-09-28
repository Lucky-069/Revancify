from bs4 import BeautifulSoup
import html.parser
from urllib.request import Request, urlopen

class fetch:
    def __init__(self, url):
        self.url=url

    def bsurl(self):
        headers = {'User-Agent': 'Mozilla/5.0'}
        htmldata = urlopen(Request(url=self.url, headers=headers)).read()
        return BeautifulSoup(htmldata, 'html.parser')