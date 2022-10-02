import requests
import json

localjson = None

def openjson():
    global localjson
    try:
        with open("patches.json", "r") as patchesfile:
            localjson = json.load(patchesfile)
    except (json.decoder.JSONDecodeError, FileNotFoundError) as e:
        with open("patches.json", "w") as patchesfile:
            emptyjson = [{"patchname": None, "appname": None, "status": None}]
            json.dump(emptyjson, patchesfile, indent=4)
        openjson()

openjson()


remotejson = requests.get('https://raw.githubusercontent.com/revanced/revanced-patches/main/patches.json').json()

remotepatches = []
localpatches = []

for key in remotejson:
    remotepatches.append(key['name'])

for key in localjson:
    localpatches.append(key['patchname'])


for patchname in remotepatches:
    if patchname not in localpatches:
        newkey = {}
        newkey['patchname'] = patchname
        for patches in remotejson:
            if patches['name'] == patchname:
                newkey['appname'] = patches['compatiblePackages'][0]['name']
        newkey['status'] = "on"
        localjson.append(newkey)
    else:
        None

for patchname in localpatches:
    if patchname not in remotepatches:
        del localjson[localpatches.index(patchname)]

with open("patches.json", "w") as patchesfile:
    json.dump(localjson, patchesfile, indent=4)