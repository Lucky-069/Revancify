#!/data/data/com.termux/files/usr/bin/bash

revive(){
    clear && echo "Script terminated" && rm -rf ./*cache && tput cnorm && cd ~ && exit
}
trap revive SIGINT

# For update change this sentence here ...

clear
rm -rf ./*cache

if [ -e ~/../usr/bin/java ] && [ -e ~/../usr/bin/python ] && [ -e ~/../usr/bin/wget ] && [ -e ~/../usr/bin/dialog ] && [ -e ~/../usr/bin/tput ] && [ "$(find ~/../usr/lib/ -name "wheel" | wc -l)" != "0" ] && [ "$(find ~/../usr/lib/ -name "requests" | wc -l)" != "0" ] && [ "$(find ~/../usr/lib/ -name "bs4" | wc -l)" != "0" ] && [ -e ~/../usr/bin/revancify ] 
then
    :
else
    echo "Installing dependencies..."
    sleep 0.5s
    git pull
    pkg update -y &&
    pkg install python openjdk-17 wget ncurses-utils dialog -y
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

anim()
{
    echo "Fetching latest version info"
    echo ""
    echo "Please Wait..."
    echo ""
    tput sc
    echo "█░░░░░░░░░"
    sleep 0.1s
    tput rc
    echo "░█░░░░░░░░"
    sleep 0.1s
    tput rc
    echo "░░█░░░░░░░"
    sleep 0.1s
    tput rc
    echo "░░░█░░░░░░"
    sleep 0.1s
    tput rc
    echo "░░░░█░░░░░"
    sleep 0.1s
    tput rc
    echo "░░░░░█░░░░"
    sleep 0.1s
    tput rc
    echo "░░░░░░█░░░"
    sleep 0.1s
    tput rc
    echo "░░░░░░░█░░"
    sleep 0.1s
    tput rc
    echo "░░░░░░░░█░"
    sleep 0.1s
    tput rc
    echo "░░░░░░░░░█"
    sleep 0.1s
    tput rc
    echo "░░░░░░░░░░"
    sleep 0.1s
    tput rc
    tput cuu1
    tput cuu1
    tput cuu1
    tput cuu1
    tput sc
}

selectapp()
{
    selectapp=$(dialog --backtitle "Revancify" --title 'App Selection Menu' --ascii-lines --ok-label "Select" --menu "Select App" 12 30 10 1 "YouTube" 2 "YouTube Music" 3 "Twitter" 4 "Reddit" 5 "TikTok" 2>&1> /dev/tty)
    exitstatus=$?
    if [ "$exitstatus" -eq "0" ]
    then
        if [ "$selectapp" -eq "1" ]
        then
            pkgname=com.google.android.youtube
        elif [ "$selectapp" -eq "2" ]
        then
            pkgname=com.google.android.apps.youtube.music
        elif [ "$selectapp" -eq "3" ]
        then
            pkgname=com.twitter.android
        elif [ "$selectapp" -eq "4" ]
        then
            pkgname=com.reddit.frontpage
        elif [ "$selectapp" -eq "5" ]
        then
            pkgname=com.zhiliaoapp.musically
        fi
    elif [ "$exitstatus" -ne "0" ]
    then
        user_input
    fi
}

selectpatches()
{  
    selectapp
    while read -r line
    do
        read -r -a eachline <<< "$line"
        patches+=("${eachline[@]}")
    done < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname))[] | "\(.patchname) \(.status)"' patches.json)
    mapfile -t choices < <(dialog --backtitle "Revancify" --title 'Patch Selection Menu' --no-items --ascii-lines --ok-label "Save" --no-cancel --separate-output --checklist "Select patches to include" 20 45 10 "${patches[@]}" 2>&1 >/dev/tty)
    tmp=$(mktemp)
    jq --arg pkgname "$pkgname" 'map(select(.appname == $pkgname).status = "off")' patches.json | jq 'map(select(IN(.patchname; $ARGS.positional[])).status = "on")' --args "${choices[@]}" > "$tmp" && mv "$tmp" patches.json
    mainmenu
}


patchoptions()
{
    echo ""
    echo "Generating Options File. Please wait..."
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
    mainmenu=$(dialog --backtitle "Revancify" --title 'Select App' --ascii-lines --ok-label "Select" --menu "Select Option" 12 30 10 1 "Patch App" 2 "Select Patches" 3 "Edit Patch Options" 2>&1> /dev/tty)
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


user_input

su_check()
{
    # variant
    if su -c exit > /dev/null 2>&1
    then
        variant="root"
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
        if [ "$pkgname" = "com.google.android.youtube" ]
        then
            if su -c dumpsys package com.google.android.youtube | grep -q path
            then
                :
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
        elif [ "$pkgname" = "com.google.android.apps.youtube.music" ]
        then
            if su -c dumpsys package com.google.android.apps.youtube.music | grep -q path
            then
                :
            else
                sleep 0.5s
                tput rc; tput ed
                echo "Oh No, YouTube Music is not installed"
                echo ""
                sleep 0.5s
                echo "Install YouTube Music from PlayStore and run this script again."
                tput cnorm
                cd ~ || exit
                exit
                
            fi
        fi
    else
        variant="non_root"
        mkdir -p /storage/emulated/0/Revancify
    fi
}


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

excludepatches=$(while read -r line; do
        printf %s"$line" " "
    done < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname and .status == "off"))[].patchname' patches.json | sed "s/^/-e /g"))


#Build apps
su_check
if [ "$pkgname" = "com.google.android.youtube" ]
then
    if [ "$variant" = "root" ]
    then
        appver=$( su -c dumpsys package com.google.android.youtube | grep versionName | cut -d= -f 2 )
        getlink=$(python3 ./python-utils/fetch-link.py "YouTube" "$appver")
        app_dl YouTube "$appver" "$getlink" &&
        echo "Building Youtube Revanced ..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./YouTube-"$appver".apk -e microg-support $excludepatches --keystore ./revanced.keystore -o ./com.google.android.youtube.apk --custom-aapt2-binary ./aapt2_"$arch" --experimental --options options.toml
        rm -rf revanced-cache
        echo "Mounting the app"
        if su -mm -c 'stockapp=$(pm path com.google.android.youtube | grep base | sed 's/package://g'); grep com.google.android.youtube /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | xargs -r umount -l > /dev/null 2>&1; done; rm /data/adb/revanced/com.google.android.youtube.apk > /dev/null 2>&1; mv com.google.android.youtube.apk /data/adb/revanced && revancedapp=/data/adb/revanced/com.google.android.youtube.apk; chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0 "$revancedapp"; mount -o bind "$revancedapp" "$stockapp" && am force-stop com.google.android.youtube && exit'
        then
            echo "Mounting successful"
            tput cnorm && cd ~ && exit
            
        else
            echo "Mount failed..."
            echo "Exiting the script"
            tput cnorm && cd ~ && exit
        fi
    elif [ "$variant" = "non_root" ]
    then
        mapfile -t appverlist < <(python3 ./python-utils/version-list.py "YouTube")
        appver=$(dialog --backtitle "Revancify" --title "YouTube" --no-items --no-cancel --ascii-lines --ok-label "Select" --menu "Select App Version" 20 40 10 "${appverlist[@]}" 2>&1> /dev/tty)
        getlink=$(python3 ./python-utils/fetch-link.py "YouTube" "$appver")
        if dialog --backtitle "Revancify" --title 'MicroG' --no-items --defaultno --ascii-lines --yesno "Download MicroG?" 5 20
        then
            clear
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress
            echo ""
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify
            echo MicroG App saved to Revancify folder.
        fi
        clear
        intro
        tput rc; tput ed
        app_dl YouTube "$appver" "$getlink" &&
        echo "Building YouTube Revanced..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./YouTube-"$appver".apk $excludepatches --keystore ./revanced.keystore -o ./YouTubeRevanced-"$appver".apk --custom-aapt2-binary ./aapt2_"$arch" --options options.toml
        rm -rf revanced-cache
        mv YouTubeRevanced* /storage/emulated/0/Revancify/ &&
        sleep 0.5s
        echo "YouTube App saved to Revancify folder." &&
        echo "Thanks for using Revancify..." &&
        [[ -f Vanced_MicroG.apk ]] && termux-open /storage/emulated/0/Revancify/Vanced_MicroG.apk
        termux-open /storage/emulated/0/Revancify/YouTubeRevanced-"$appver".apk
    fi
elif [ "$pkgname" = "com.google.android.apps.youtube.music" ]
then
    if [ "$variant" = "root" ]
    then
        appver=$(su -c dumpsys package com.google.android.apps.youtube.music | grep versionName | cut -d= -f 2 )
        getlink=$(python3 ./python-utils/fetch-link.py "YouTubeMusic" "$appver" "$arch")
        app_dl YouTubeMusic "$appver" "$getlink" &&
        echo "Building YouTube Music Revanced..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./YouTubeMusic-"$appver".apk $excludepatches --keystore ./revanced.keystore -o ./com.google.android.apps.youtube.music.apk --custom-aapt2-binary ./aapt2_"$arch" --experimental
        rm -rf revanced-cache
        echo "Mounting the app"
        if su -mm -c 'stockapp=$(pm path com.google.android.apps.youtube.music | grep base | sed 's/package://g'); grep com.google.android.apps.youtube.music /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | xargs -r umount -l > /dev/null 2>&1; done; rm /data/adb/revanced/com.google.android.apps.youtube.music.apk > /dev/null 2>&1; mv com.google.android.apps.youtube.music.apk /data/adb/revanced && revancedapp=/data/adb/revanced/com.google.android.apps.youtube.music.apk; chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0 "$revancedapp"; mount -o bind "$revancedapp" "$stockapp" && am force-stop com.google.android.apps.youtube.music && exit'
        then
            echo "Mounting successful"
            tput cnorm && cd ~ && exit
        
        else
            echo "Mount failed..."
            echo "Exiting the script"
            tput cnorm && cd ~ && exit
        fi
    elif [ "$variant" = "non_root" ]
    then
        mapfile -t appverlist < <(python3 ./python-utils/version-list.py "YouTubeMusic")
        appver=$(dialog --backtitle "Revancify" --title "YouTube Music" --no-items --no-cancel --ascii-lines --ok-label "Select" --menu "Select App Version" 20 40 10 "${appverlist[@]}" 2>&1> /dev/tty)
        getlink=$(python3 ./python-utils/fetch-link.py "YouTubeMusic" "$appver" "$arch")
        if dialog --backtitle "Revancify" --title 'MicroG' --no-items --defaultno --ascii-lines --yesno "Download MicroG?" 5 20
        then
            clear
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress
            echo ""
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify
            echo MicroG App saved to Revancify folder.
        fi
        clear
        intro
        tput rc; tput ed
        app_dl YouTubeMusic "$appver" "$getlink" &&
        echo "Building YouTube Music Revanced..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./YouTubeMusic-"$appver".apk $excludepatches --keystore ./revanced.keystore -o ./YouTubeMusicRevanced-"$appver".apk --custom-aapt2-binary ./aapt2_"$arch"
        rm -rf revanced-cache
        mv YouTubeMusicRevanced* /storage/emulated/0/Revancify/ &&
        sleep 0.5s &&
        echo "YouTube Music App saved to Revancify folder." &&
        echo "Thanks for using Revancify..." &&
        [[ -f Vanced_MicroG.apk ]] && termux-open /storage/emulated/0/Revancify/Vanced_MicroG.apk
        termux-open /storage/emulated/0/Revancify/YouTubeMusicRevanced-"$appver".apk
    fi
elif [ "$pkgname" = "com.twitter.android" ]
then
    mapfile -t appverlist < <(python3 ./python-utils/version-list.py "Twitter")
    appver=$(dialog --backtitle "Revancify" --title "Twitter" --no-items --no-cancel --ascii-lines --ok-label "Select" --menu "Select App Version" 20 40 10 "${appverlist[@]}" 2>&1> /dev/tty)
    getlink=$(python3 ./python-utils/fetch-link.py "Twitter" "$appver")
    clear
    intro
    app_dl Twitter "$appver" "$getlink" &&
    echo "Building Twitter Revanced..."
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./Twitter-"$appver".apk $excludepatches --keystore ./revanced.keystore -o ./TwitterRevanced-"$appver".apk --custom-aapt2-binary ./aapt2_"$arch" --experimental
    rm -rf revanced-cache
    mkdir -p /storage/emulated/0/Revancify
    mv TwitterRevanced* /storage/emulated/0/Revancify/ &&
    sleep 0.5s &&
    echo "Twitter App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    termux-open /storage/emulated/0/Revancify/TwitterRevanced-"$appver".apk
elif [ "$pkgname" = "com.reddit.frontpage" ]
then
    mapfile -t appverlist < <(python3 ./python-utils/version-list.py "Reddit")
    appver=$(dialog --backtitle "Revancify" --title "Reddit" --no-items --no-cancel --ascii-lines --ok-label "Select" --menu "Select App Version" 20 40 10 "${appverlist[@]}" 2>&1> /dev/tty)
    getlink=$(python3 ./python-utils/fetch-link.py "Reddit" "$appver")
    clear
    intro
    app_dl Reddit "$appver" "$getlink" &&
    echo "Building Reddit Revanced..."
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./Reddit-"$appver".apk $excludepatches --keystore ./revanced.keystore -o ./RedditRevanced-"$appver".apk --custom-aapt2-binary ./aapt2_"$arch" --experimental
    rm -rf revanced-cache
    mkdir -p /storage/emulated/0/Revancify
    mv RedditRevanced* /storage/emulated/0/Revancify/ &&
    sleep 0.5s &&
    echo "Reddit App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    termux-open /storage/emulated/0/Revancify/RedditRevanced-"$appver".apk
elif [ "$pkgname" = "com.zhiliaoapp.musically" ]
then
    mapfile -t appverlist < <(python3 ./python-utils/version-list.py "TikTok")
    appver=$(dialog --backtitle "Revancify" --title "TikTok" --no-items --no-cancel --ascii-lines --ok-label "Select" --menu "Select App Version" 20 40 10 "${appverlist[@]}" 2>&1> /dev/tty)
    getlink=$(python3 ./python-utils/fetch-link.py "TikTok" "$appver")
    clear
    intro
    app_dl TikTok "$appver" "$getlink" &&
    echo "Building TikTok Revanced..."
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./TikTok-"$appver".apk --keystore ./revanced.keystore -o ./TikTokRevanced-"$appver".apk --custom-aapt2-binary ./aapt2_"$arch" --experimental
    rm -rf revanced-cache
    mkdir -p /storage/emulated/0/Revancify
    mv TikTokRevanced* /storage/emulated/0/Revancify/ &&
    sleep 0.5s &&
    echo "TikTok App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    termux-open /storage/emulated/0/Revancify/TikTokRevanced-"$appver".apk
fi
cd ~ || exit
tput cnorm
