import requests


requests_session = requests.Session()
patches_version = (((requests_session.get('https://api.github.com/repos/revanced/revanced-patches/releases/latest')).json())['name']).replace("v","")
cli_version = (((requests_session.get('https://api.github.com/repos/revanced/revanced-cli/releases/latest')).json())['name']).replace("v","")
integrations_version = (((requests_session.get('https://api.github.com/repos/revanced/revanced-integrations/releases/latest')).json())['name']).replace("v","")

print(patches_version)
print(cli_version)
print(integrations_version)