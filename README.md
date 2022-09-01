# Revancify
A simple and direct Revanced Installer script.  
It uses Revanced CLI to build Revanced Apps.

Apps Supported:
1. YouTube
2. YouTube Music
3. Twitter
4. Reddit
5. TikTok

<a href="https://github.com/decipher3114/Revancify/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=decipher3114/Revancify" />
</a>

### Note:  
Download Termux from their github or FDroid

# Installation
1. Open Termux.  
2. Copy and paste this code.  
```
termux-setup-storage && pkg update -y && pkg install git -y && cd storage && git clone https://github.com/decipher3114/Revancify && cd Revancify && bash revancify.sh && exit
```

# Usage
1. Open Termux.  
2. Type `revancify` 
> Now Revancify is a binary, it can be run directly after opening.

# Troubleshoot
## Command 1: 
Use this command in case of any fatal error
```
cd storage/Revancify && bash revancify.sh
```  
## Method 2:  
if command 1 fails, use this command, this will delete and reinitialize the repo.
```
cd storage && rm -rf Revnacify && git clone https://github.com/decipher3114/Revancify && cd Revancify && bash revancify.sh
```
# Uninstallation
1. Open Termux.  
2. Type `cd storage`  
3. Type `rm -rf Revancify`  

# Thanks & Credits
[Revanced](https://github.com/revanced)  
