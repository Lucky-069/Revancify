#!/data/data/com.termux/files/usr/bin/bash

revive(){
    clear && echo "Script terminated" && rm -rf ./*cache ; tput cnorm ; cd ~ || : ; exit
}
trap revive SIGINT

# For update change this sentence here ...

clear
rm -rf ./*cache

if [ -e ~/../usr/bin/java ] && [ -e ~/../usr/bin/python ] && [ -e ~/../usr/bin/wget ] && [ -e ~/../usr/bin/dialog ] && [ -e ~/../usr/bin/tput ] && [ -e ~/../usr/bin/jq ] && [ "$(find ~/../usr/lib/ -name "wheel" | wc -l)" != "0" ] && [ "$(find ~/../usr/lib/ -name "requests" | wc -l)" != "0" ] && [ "$(find ~/../usr/lib/ -name "bs4" | wc -l)" != "0" ] && [ -e ~/../usr/bin/revancify ] 
then
    :
else
    echo "Installing dependencies..."
    sleep 0.5s
    git pull
    pkg update -y &&
    pkg install python openjdk-17 wget ncurses-utils dialog jq -y
    pip install --upgrade pip
    pip install wheel
    pip install requests bs4
    cp revancify ~/../usr/bin
    sed -i 's/# allow-external-apps = true/allow-external-apps = true/g' ~/.termux/termux.properties
    sleep 0.5s
    echo "Dependencies installed successfully."
    sleep 0.5s
    echo "Run this script again"
    cd ~ || exit
    exit
fi

if wget -q --spider http://google.com
then
    :
else
    echo "Oops, No internet"
    sleep 0.5s
    echo "Connect to internet and try again."
    cd ~ || exit
    tput cnorm
    exit
fi

intro()
{
    tput civis
    tput cs 7 $LINES
    leave1=$(($(($(tput cols) - 34)) / 2))
    tput cm 0 $leave1
    echo "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█"
    tput cm 1 $leave1
    echo "█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░"
    echo ""
    leave2=$(($(($(tput cols) - 40)) / 2))
    tput cm 3 $leave2
    echo "█▄▄ █▄█    █▀▄ █▀▀ █▀▀ █ █▀█ █░█ █▀▀ █▀█"
    tput cm 4 $leave2
    echo "█▄█ ░█░    █▄▀ ██▄ █▄▄ █ █▀▀ █▀█ ██▄ █▀▄"
    echo ""
    tput cm 8 0
    tput sc
}

get_components(){

    mapfile -t revanced_latest < <(python3 ./python-utils/revanced-latest.py)
    
    #get patches version
    patches_latest="${revanced_latest[0]}"

    #get cli version
    cli_latest="${revanced_latest[1]}"

    #get patches version
    int_latest="${revanced_latest[2]}"

    #check patch
    if ls ./revanced-patches-* > /dev/null 2>&1
    then
        patches_available=$(basename revanced-patches* .jar | cut -d '-' -f 3) #get version
        if [ "$patches_latest" = "$patches_available" ]
        then
            echo "Latest Patches already exixts."
            echo ""
            wget -q -c https://github.com/revanced/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar --show-progress
            echo ""
        else
            echo "Patches update available !!"
            rm revanced-patches*
            echo ""
            echo "Downloading latest Patches..."
            echo ""
            wget -q -c https://github.com/revanced/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar --show-progress 
            echo ""
        fi
    else
        echo "No patches found in Current Directory"
        echo ""
        echo "Downloading latest patches file..."
        echo ""
        wget -q -c https://github.com/revanced/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar --show-progress 
        echo ""
    fi

    #check cli
    if ls -l ./revanced-cli-* > /dev/null 2>&1
    then
        cli_available=$(basename revanced-cli* .jar | cut -d '-' -f 3) #get version
        if [ "$cli_latest" = "$cli_available" ]
        then
            echo "Latest CLI already exists."
            echo ""
            wget -q -c https://github.com/revanced/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar -O revanced-cli-"$cli_latest".jar --show-progress 
            echo ""
        else
            echo "CLI update available !!"
            rm revanced-cli*
            echo ""
            echo "Downloading latest CLI..."
            echo ""
            wget -q -c https://github.com/revanced/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar -O revanced-cli-"$cli_latest".jar --show-progress 
            echo ""
        fi
    else
        echo "No CLI found in Current Directory"
        echo ""
        echo "Downloading latest CLI..."
        echo ""
        wget -q -c https://github.com/revanced/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar -O revanced-cli-"$cli_latest".jar --show-progress 
        echo ""
    fi

    #check integrations
    if ls ./revanced-integrations-* > /dev/null 2>&1
    then
        int_available=$(basename revanced-integrations* .apk | cut -d '-' -f 3) #get version
        if [ "$int_latest" = "$int_available" ]
        then
            echo "Latest Integrations already exists."
            echo ""
            wget -q -c https://github.com/revanced/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk -O revanced-integrations-"$int_latest".apk --show-progress  
            echo ""
        else
            echo "Integrations update available !!"
            rm revanced-integrations*
            echo ""
            echo "Downloading latest Integrations apk..."
            echo ""
            wget -q -c https://github.com/revanced/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk -O revanced-integrations-"$int_latest".apk --show-progress
            echo ""
            echo ""
        fi
    else
        echo "No Integrations found in Current Directory"
        echo ""
        echo "Downloading latest Integrations apk..."
        echo ""
        wget -q -c https://github.com/revanced/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk -O revanced-integrations-"$int_latest".apk --show-progress
        echo ""
        sleep 0.5s
        tput rc; tput ed
    fi

    # Fetch patches
    python3 ./python-utils/fetch-patches.py
}

intro

echo "Checking for update..."
git config pull.rebase true
sleep 0.5s

if [ "$(git pull)" != "Already up to date." ]
then
    cp dialog-config.txt ~/.dialogrc
    cp revancify ~/../usr/bin/revancify
    tput rc; tput ed
    echo Revancify updated...
    sleep 0.5s
    echo Run this script again
    sleep 0.5s
    tput cnorm
    cd ~ || exit
    exit
else
    echo ""
    echo "Script already up to date."
    sleep 0.5s
    tput rc; tput ed
    get_components
fi
grep -q decipher ~/.dialogrc || cp dialog-config.txt ~/.dialogrc
grep -q flag ~/../usr/bin/revancify || cp revancify ~/../usr/bin/revancify


selectapp()
{
    selectapp=$(dialog --backtitle "Revancify" --title 'App Selection Menu' --ascii-lines --ok-label "Select" --menu "Select App" 12 30 10 1 "YouTube" 2 "YouTube Music" 3 "Twitter" 4 "Reddit" 5 "TikTok" 2>&1> /dev/tty)
    exitstatus=$?
    if [ "$exitstatus" -eq "0" ]
    then
        if [ "$selectapp" -eq "1" ]
        then
            appname=YouTube
            pkgname=com.google.android.youtube
        elif [ "$selectapp" -eq "2" ]
        then
            appname=YouTubeMusic
            pkgname=com.google.android.apps.youtube.music
        elif [ "$selectapp" -eq "3" ]
        then
            appname=Twitter
            pkgname=com.twitter.android
        elif [ "$selectapp" -eq "4" ]
        then
            appname=Reddit
            pkgname=com.reddit.frontpage
        elif [ "$selectapp" -eq "5" ]
        then
            appname=TikTok
            pkgname=com.ss.android.ugc.trill

        fi
    elif [ "$exitstatus" -ne "0" ]
    then
        mainmenu
    fi
}

selectpatches()
{  
    selectapp
    declare -a patches
    while read -r line
    do
        read -r -a eachline <<< "$line"
        patches+=("${eachline[@]}")
    done < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname))[] | "\(.patchname) \(.status)"' patches.json)
    mapfile -t choices < <(dialog --backtitle "Revancify" --title 'Patch Selection Menu' --no-items --ascii-lines --ok-label "Save" --no-cancel --separate-output --checklist "Select patches to include" 20 45 10 "${patches[@]}" 2>&1 >/dev/tty)
    tmp=$(mktemp)
    jq --arg pkgname "$pkgname" 'map(select(.appname == $pkgname).status = "off")' patches.json | jq 'map(select(IN(.patchname; $ARGS.positional[])).status = "on")' --args "${choices[@]}" > "$tmp" && mv "$tmp" ./patches.json
    mainmenu
}


patchoptions()
{
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./noinput.apk -o nooutput.apk > /dev/null 2>&1
    tput cnorm
    tmp=$(mktemp)
    dialog --backtitle "Revancify" --ascii-lines --title "Options File Editor" --editbox options.toml 22 50 2> "$tmp" && mv "$tmp" ./options.toml
    tput civis
    clear
    mainmenu
}

mainmenu()
{
    tput rc; tput ed
    mainmenu=$(dialog --backtitle "Revancify" --title 'Select App' --ascii-lines --ok-label "Select" --cancel-label "Exit" --menu "Select Option" 12 30 10 1 "Patch App" 2 "Select Patches" 3 "Edit Patch Options" 2>&1> /dev/tty)
    exitstatus=$?
    if [ "$exitstatus" -eq "0" ]
    then
        if [ "$mainmenu" -eq "1" ]
        then
            selectapp
        elif [ "$mainmenu" -eq "2" ]
        then
            selectpatches
        elif [ "$mainmenu" -eq "3" ]
        then
            patchoptions
        fi
    elif [ "$exitstatus" -ne "0" ]
    then
        revive
    fi
}



arch=$(getprop ro.product.cpu.abi | cut -d "-" -f 1)


mainmenu

# App Downloader
app_dl()
{
    if ls ./"$1"-* > /dev/null 2>&1
    then
        app_available=$(basename "$1"-* .apk | cut -d '-' -f 2) #get version
        if [ "$2" = "$app_available" ];then
            echo "Latest $1 apk already exists."
            echo ""
            sleep 0.5s
            wget -q -c "$3" -O "$1"-"$2".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            sleep 0.5s
            tput rc; tput ed
        else
            echo "$1 update available !!"
            sleep 0.5s
            tput rc; tput ed
            echo "Removing previous $1 apk..."
            rm $1-*.apk
            sleep 0.5s
            tput rc; tput ed
            echo "Downloading latest $1 apk..."
            echo " "
            wget -q -c "$3" -O "$1"-"$2".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            sleep 0.5s
            tput rc; tput ed
        fi
    else
        echo "No $1 apk found in Current Directory"
        echo " "
        echo "Downloading latest $1 apk..."
        echo " "
        wget -q -c "$3" -O "$1"-"$2".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
        sleep 0.5s
        tput rc; tput ed
    fi
}

excludepatches=$(while read -r line; do printf %s"$line" " "; done < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname and .status == "off"))[].patchname' patches.json | sed "s/^/-e /g"))


#Build apps
if [ "$pkgname" = "com.google.android.youtube" ] || [ "$pkgname" = "com.google.android.apps.youtube.music" ]
then
    if su -c exit > /dev/null 2>&1
    then
        su -c 'mkdir -p /data/adb/revanced'
        if su -c ls /data/adb/service.d | grep -q mount_revanced_com.google.android.youtube.sh && su -c ls /data/adb/service.d | grep -q mount_revanced_com.google.android.apps.youtube.music.sh
        then
            :
        else
            su -c cp mount_revanced_com.google.android.youtube.sh /data/adb/service.d/
            su -c chmod +x /data/adb/service.d/mount_revanced_com.google.android.youtube.sh
            su -c cp mount_revanced_com.google.android.apps.youtube.music.sh /data/adb/service.d/
            su -c chmod +x /data/adb/service.d/mount_revanced_com.google.android.apps.youtube.music.sh
        fi
        if su -c dumpsys package $pkgname | grep -q path
        then
            appver=$(su -c dumpsys package $pkgname | grep versionName | cut -d= -f 2 )
        else
            sleep 0.5s
            echo "Oh No, YouTube is not installed"
            echo ""
            sleep 0.5s
            echo "Install YouTube from PlayStore and run this script again."
            tput cnorm
            cd ~ || exit
            exit
        fi
        
    else
        mkdir -p /storage/emulated/0/Revancify
        mapfile -t appverlist < <(python3 ./python-utils/version-list.py "$appname")
        appver=$(dialog --backtitle "Revancify" --title "Version Selection Menu" --no-items --no-cancel --ascii-lines --ok-label "Select" --menu "Choose App Version" 20 40 10 "${appverlist[@]}" 2>&1> /dev/tty)

        if dialog --backtitle "Revancify" --title 'MicroG' --no-items --defaultno --ascii-lines --yesno "Download MicroG?" 8 30
        then
            clear
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress
            echo ""
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify
            echo MicroG App saved to Revancify folder.
        fi
    fi
    clear
    intro
    echo "Please wait fetching link ..."
    getlink=$(python3 ./python-utils/fetch-link.py "$appname" "$appver")
    tput rc; tput ed
    app_dl "$appname" "$appver" "$getlink" &&
    echo "Building $appname Revanced..."
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./"$appname"-"$appver".apk $excludepatches --keystore ./revanced.keystore -o ./"$appname"Revanced-"$appver".apk --custom-aapt2-binary ./aapt2_"$arch" --options options.toml --experimental
    rm -rf revanced-cache

    if su -c exit > /dev/null 2>&1
    then
        mv "$appname"Revanced-"$appver".apk "$pkgname".apk
        echo "Mounting the app"
        if su -mm -c 'pkgname=$( ls /data/data/com.termux/files/home/storage/Revancify | grep '^com.google.android' | sed 's/.apk//g' ) && stockapp=$(pm path $pkgname | grep base | sed 's/package://g') && grep $pkgname /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | xargs -r umount -l > /dev/null 2>&1; done && rm /data/adb/revanced/"$pkgname".apk > /dev/null 2>&1 && mv "$pkgname".apk /data/adb/revanced && revancedapp=/data/adb/revanced/"$pkgname".apk && chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0 "$revancedapp"; mount -o bind "$revancedapp" "$stockapp" && am force-stop com.google.android.apps.youtube.music && exit'
        then
            echo "Mounting successful"
            tput cnorm && cd ~ && exit
        
        else
            echo "Mount failed..."
            echo "Exiting the script"
            tput cnorm && cd ~ && exit
        fi
    else
        mv "$appname"Revanced* /storage/emulated/0/Revancify/ &&
        sleep 0.5s
        echo "$appname App saved to Revancify folder." &&
        echo "Thanks for using Revancify..." &&
        [[ -f Vanced_MicroG.apk ]] && termux-open /storage/emulated/0/Revancify/Vanced_MicroG.apk
        termux-open /storage/emulated/0/Revancify/"$appname"Revanced-"$appver".apk
    fi

else
    mkdir -p /storage/emulated/0/Revancify
    mapfile -t appverlist < <(python3 ./python-utils/version-list.py "$appname")
    appver=$(dialog --backtitle "Revancify" --title "Version Selection Menu" --no-items --no-cancel --ascii-lines --ok-label "Select" --menu "Select App Version" 20 40 10 "${appverlist[@]}" 2>&1> /dev/tty)
    clear
    intro
    echo "Please wait fetching link ..."
    getlink=$(python3 ./python-utils/fetch-link.py "$appname" "$appver")
    app_dl "$appname" "$appver" "$getlink" &&
    echo "Building $appname Revanced..."
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./"$appname"-"$appver".apk --keystore ./revanced.keystore -o ./"$appname"Revanced-"$appver".apk --custom-aapt2-binary ./aapt2_"$arch" --options options.toml --experimental
    rm -rf revanced-cache
    mkdir -p /storage/emulated/0/Revancify
    mv "$appname"Revanced* /storage/emulated/0/Revancify/ &&
    sleep 0.5s &&
    echo "$appname App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    termux-open /storage/emulated/0/Revancify/"$appname"Revanced-"$appver".apk
fi

tput cnorm
rm -rf ./*cache
cd ~ || exit
exit