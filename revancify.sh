#!/data/data/com.termux/files/usr/bin/bash

cd ~/storage/Revancify || echo "Revancify directory non found !!"

revive(){
    clear && echo "Script terminated" && tput cnorm && cd ~ && exit
}
trap revive SIGINT


clear

internet()
{
    if wget -q --spider http://google.com
    then
        :
    else
        echo "Oops, No internet"
        sleep 1
        echo "Connect to internet and try again."
        cd ~
        tput cnorm
        exit
    fi
}

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
}

anim()
{
    echo "Fetching latest version info"
    echo ""
    echo "Please Wait..."
    echo ""
    tput sc
    echo "█░░░░░░░░░"
    sleep 0.1
    tput rc
    echo "░█░░░░░░░░"
    sleep 0.1
    tput rc
    echo "░░█░░░░░░░"
    sleep 0.1
    tput rc
    echo "░░░█░░░░░░"
    sleep 0.1
    tput rc
    echo "░░░░█░░░░░"
    sleep 0.1
    tput rc
    echo "░░░░░█░░░░"
    sleep 0.1
    tput rc
    echo "░░░░░░█░░░"
    sleep 0.1
    tput rc
    echo "░░░░░░░█░░"
    sleep 0.1
    tput rc
    echo "░░░░░░░░█░"
    sleep 0.1
    tput rc
    echo "░░░░░░░░░█"
    sleep 0.1
    tput rc
    echo "░░░░░░░░░░"
    sleep 0.1
    tput rc
    tput cuu1
    tput cuu1
    tput cuu1
    tput cuu1
    tput sc
}

branding="--options options.toml"
options(){
    tput rc; tput cd
    tput sc
    echo "Which app icon you want to use?"
    echo "1. Revanced default"
    echo "2. YouTube default"
    echo "3. Custom icon by decipher"
    read -p "Your input: " iconprompt
    if [ $iconprompt = "1" ]
    then
        sed -i "s/appIconPath = \".*\"/appIconPath = \"null\"/g" options.toml
        tput rc; tput cd
        echo "What app name do you want to use?"
        echo "1. YouTube Revanced"
        echo "2. YouTube"
        read -p "Your input: " nameprompt
        if [ $nameprompt = "1" ]
        then
            name="YouTube Revanced"
        elif [ $nameprompt = "2" ]
        then
            name="YouTube"
        fi
        sed -i "s/appName = \".*\"/appName = \"$name\"/g" options.toml
    elif [ $iconprompt = "2" ]
    then
        branding="-e custom-branding --options.toml"
    elif [ $iconprompt = "3" ]
    then
        if [ -d "revanced-icons" ]
        then
            cd revanced-icons
            git pull > /dev/null 2>&1
            cd ..
        else
            echo "Downloading icons..."
            git clone https://github.com/decipher3114/revanced-icons.git > /dev/null 2>&1
        fi
        sed -i "s/appIconPath = \".*\"/appIconPath = \"revanced-icons\/youtube\"/g" options.toml
        tput rc; tput cd
        echo "What app name do you want to use?"
        echo "1. YouTube Revanced"
        echo "2. YouTube"
        read -p "Your input: " nameprompt
        if [ $nameprompt = "1" ]
        then
            name="YouTube Revanced"
        elif [ $nameprompt = "2" ]
        then
            name="YouTube"
        fi
        sed -i "s/appName = \".*\"/appName = \"$name\"/g" options.toml
    fi
    tput rc; tput cd
    user_input
}

ytpatches()
{
    echo "All saved patches will be reset."
    read -p "Do you want to continue? [y/n] " patchprompt
    if [[ "$patchprompt" =~ [Y,y] ]]
    then
        :
    else
        user_input
    fi
    echo Updating patches...
    python3 fetch.py yt patches
    sed -i '/microg-support/d' youtube_patches.txt
    sed -i '/enable-debugging/d' youtube_patches.txt
    echo "$(nl -n rz -w2 -s " " youtube_patches.txt)" > youtube_patches.txt
    sleep 1
    cmd=(dialog --keep-tite --separate-output --checklist "Select patches to include" 22 76 16)
    options=()
    len="$(wc -l < youtube_patches.txt)"
    mapfile -t nums < <(seq -w 1 $len)
    while read -r line
    do
        read -r -a arr <<< "$line"
        options+=("${arr[@]}")
    done < <(cat youtube_patches.txt)
    tput rc; tput cd
    mapfile -t choices < <("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    for num in "${nums[@]}"
    do
        echo "${choices[@]}" | grep -q "$num" || sed -i "/$num/s/ on/ off/" youtube_patches.txt
    done
    tput sc
    user_input
}


ytmpatches()
{
    echo "All saved patches will be reset. "
    read -p "Do you want to continue? [y/n] " patchprompt
    if [[ "$patchprompt" =~ [Y,y] ]]
    then
        :
    else
        user_input
    fi
    echo Updating Patches...
    python3 fetch.py ytm patches
    sed -i '/music-microg-support/d' youtubemusic_patches.txt
    echo "$(nl -n rz -w2 -s " " youtubemusic_patches.txt)" > youtubemusic_patches.txt
    sleep 1
    cmd=(dialog --keep-tite --separate-output --checklist "Select patches to include" 22 76 16)
    options=()
    len="$(wc -l < youtubemusic_patches.txt)"
    mapfile -t nums < <(seq -w 1 $len)
    while read -r line
    do
        read -r -a arr <<< "$line"
        options+=("${arr[@]}")
    done < <(cat youtubemusic_patches.txt)
    tput rc; tput cd
    mapfile -t choices < <("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    for num in "${nums[@]}"
    do
        echo "${choices[@]}" | grep -q "$num" || sed -i "/$num/s/ on/ off/" youtubemusic_patches.txt
    done
    tput sc
    user_input
}



user_input()
{
    echo "Which do you want to do?"
    echo "1. Patch YouTube"
    echo "2. Patch YouTube Music"
    echo "3. Patch Twitter"
    echo "4. Patch Reddit"
    echo "5. Patch TikTok"
    echo "6. Edit Patches"
    echo "7. Edit Patch-options"
    read -p "Your Input: " input
    if [ "$input" -eq "1" ]
    then
        appname="YouTube"
    elif [ "$input" -eq "2" ]
    then
        appname="YouTubeMusic"
    elif [ "$input" -eq "3" ]
    then
        appname="Twitter"
    elif [ "$input" -eq "4" ]
    then
        appname="Reddit"
    elif [ "$input" -eq "5" ]
    then
        appname="TikTok"
    elif [ "$input" -eq "6" ]
    then
        tput rc; tput cd
        echo "Which app patches do you want to edit?"
        echo "1. YouTube"
        echo "2. YouTube Music"
        read -p "Your Input: " patchedit
        tput rc; tput cd
        if [ "$patchedit" -eq "1" ]
        then
            ytpatches
        elif [ "$patchedit" -eq "2" ]
        then
            ytmpatches
        fi
    elif [ "$input" -eq "7" ]
    then
        options
    else
        echo No input given..
        user_input
    fi
    tput rc
    tput cd
}

if [ -e ~/../usr/bin/java ] && [ -e ~/../usr/bin/python ] && [ -e ~/../usr/bin/wget ] && [ -e ~/../usr/bin/dialog ] && [ -e ~/../usr/bin/tput ] && [ "$(find ~/../usr/lib/ -name "wheel" | wc -l)" != "0" ] && [ "$(find ~/../usr/lib/ -name "requests" | wc -l)" != "0" ] && [ "$(find ~/../usr/lib/ -name "bs4" | wc -l)" != "0" ] && [ "$(find ~/../usr/lib/ -name "lxml" | wc -l)" != "0" ] && [ "$(find ~/../usr/lib/ -name "cchardet" | wc -l)" != "0" ] && [ -e ~/../usr/bin/revancify ] 
then
    intro
    internet
else
    echo "Installing dependencies..."
    sleep 1
    pkg update -y &&
    pkg install python openjdk-17 wget ncurses-utils libxml2 libxslt dialog -y &&
    pip install --upgrade pip &&
    pip install requests wheel bs4 cython cchardet lxml &&
    cp ./revancify.sh ~/../usr/bin/revancify &&
    sed -i 's/# allow-external-apps = true/allow-external-apps = true/g' ~/.termux/termux.properties
    sleep 1
    echo "Dependencies installed successfully."
    sleep 1
    echo "Run this script again"
    cd ~ 
    exit
fi

tput sc
echo "Checking for update..."
sleep 1





if [ "$(git pull)" != "Already up to date." ]
then
    sleep 1
    tput rc; tput cd
    cp ./revancify.sh ~/../usr/bin/revancify &&
    echo Revancify updated...
    sleep 1
    echo Run this script again
    sleep 1
    tput cnorm
    cd ~
    exit
else
    echo ""
    echo "Script already up to date."
    sleep 1
    tput rc; tput cd
fi


arch=$(getprop ro.product.cpu.abi | cut -d "-" -f 1)
if [ -e ./aapt2 ]
then
    :
else 
    mv ./aapt2_$arch ./aapt2
    rm ./aapt2_*
fi

user_input

# variant
if su -c exit > /dev/null 2>&1
then
    variant="root"
    su -c 'mkdir -p /data/adb/revanced'
    if su -c ls /data/adb/service.d | grep -q mountyt.sh && su -c ls /data/adb/service.d | grep -q mountytm.sh
    then
        :
    else
        su -c cp mountyt.sh /data/adb/service.d/
        su -c chmod +x /data/adb/service.d/mountyt.sh
        su -c cp mountytm.sh /data/adb/service.d/
        su -c chmod +x /data/adb/service.d/mountytm.sh
    fi
    echo "SU Status: Root"
    echo ""
    sleep 1
    tput rc; tput cd
    if [ "$appname" = "YouTube" ]
    then
        echo "Checking if YouTube is installed..."
        if su -c dumpsys package com.google.android.youtube | grep -q path
        then
            sleep 1
            echo ""
            echo "YouTube is installed"
            sleep 1
            tput rc; tput cd
        else
            sleep 1
            echo "Oh No, YouTube is not installed"
            echo ""
            sleep 1
            echo "Install YouTube from PlayStore and run this script again."
            tput cnorm
            cd ~
            exit
        fi
    elif [ "$appname" = "YouTubeMusic" ] 
    then
        echo "Checking if YouTube Music is installed..."
        if su -c dumpsys package com.google.android.apps.youtube.music | grep -q path
        then
            sleep 1
            echo ""
            echo "YouTube Music is installed"
            sleep 1
            tput rc; tput cd
        else
            sleep 1
            tput rc; tput cd
            echo "Oh No, YouTube Music is not installed"
            echo ""
            sleep 1
            echo "Install YouTube Music from PlayStore and run this script again."
            tput cnorm
            cd ~
            exit
            
        fi
    fi
else
    variant="non_root"
    mkdir -p /storage/emulated/0/Revancify
    echo "SU Status: Non Root"
    sleep 1
    tput rc; tput ed

fi

get_components(){
    #get patches version
    patches_latest=$(sed -n '1p' latest.txt)

    #get cli version
    cli_latest=$(sed -n '2p' latest.txt)

    #get patches version
    int_latest=$(sed -n '3p' latest.txt)

    #check patch
    if ls ./revanced-patches-* > /dev/null 2>&1
    then
        patches_available=$(basename revanced-patches* .jar | cut -d '-' -f 3) #get version
        if [ "$patches_latest" = "$patches_available" ]
        then
            echo "Latest Patches already exixts."
            echo ""
            sleep 1
            wget -q -c "https://github.com/revanced/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar" --show-progress
            sleep 1
            tput rc; tput cd
        else
            echo "Patches update available"
            sleep 1
            tput rc; tput cd
            echo "Removing previous Patches..."
            rm revanced-patches*
            sleep 1
            tput rc; tput cd
            echo "Downloading latest Patches..."
            echo " "
            wget -q -c "https://github.com/revanced/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar" --show-progress 
            sleep 1
            tput rc; tput cd
        fi
    else
        echo "No patches found in local storage"
        echo ""
        echo Downloading latest patches file...
        echo ""
        wget -q -c "https://github.com/revanced/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar" --show-progress 
        sleep 1
        tput rc; tput cd
    fi

    #check cli
    if ls -l ./revanced-cli-* > /dev/null 2>&1
    then
        cli_available=$(basename revanced-cli* .jar | cut -d '-' -f 3) #get version
        if [ "$cli_latest" = "$cli_available" ]
        then
            echo "Latest CLI already exists"
            echo ""
            sleep 1
            wget -q -c "https://github.com/revanced/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar" -O "revanced-cli-"$cli_latest".jar" --show-progress 
            sleep 1
            tput rc; tput cd
        else
            echo "CLI update available"
            sleep 1
            tput rc; tput cd
            echo Removing previous CLI
            rm revanced-cli*
            sleep 1
            tput rc; tput cd
            echo Downloading latest CLI...
            echo ""
            wget -q -c "https://github.com/revanced/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar" -O "revanced-cli-"$cli_latest".jar" --show-progress 
            sleep 1
            tput rc; tput cd
        fi
    else
        echo "No CLI found locally"
        echo ""
        echo Downloading latest CLI...
        echo ""
        wget -q -c "https://github.com/revanced/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar" -O "revanced-cli-"$cli_latest".jar" --show-progress 
        sleep 1
        tput rc; tput cd
    fi

    #check integrations
    if ls ./revanced-integrations-* > /dev/null 2>&1
    then
        int_available=$(basename revanced-integrations* .apk | cut -d '-' -f 3) #get version
        if [ "$int_latest" = "$int_available" ]
        then
            echo "Latest Integrations already exists"
            echo ""
            sleep 1
            wget -q -c "https://github.com/revanced/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk" -O "revanced-integrations-"$int_latest".apk" --show-progress  
            sleep 1
            tput rc; tput cd
        else
            echo "Integrations update available"
            sleep 1
            tput rc; tput cd
            echo removing previous Integrations
            rm revanced-integrations*
            sleep 1
            tput rc; tput cd
            echo "Downloading latest Integrations apk..."
            echo ""
            wget -q -c "https://github.com/revanced/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk" -O "revanced-integrations-"$int_latest".apk" --show-progress  
            echo ""
            sleep 1
            tput rc; tput cd
        fi
    else
        echo "No Integrations found locally"
        echo ""
        echo Downloading latest Integrations apk...
        echo ""
        wget -q -c "https://github.com/revanced/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk" -O revanced-integrations-$int_latest.apk --show-progress
        sleep 1
        tput rc; tput cd
    fi
}


# App Downloader
app_dl()
{
    if ls ./"$1"-* > /dev/null 2>&1
    then
        app_available=$(basename "$1"-* .apk | cut -d '-' -f 2) #get version
        if [ "$2" = "$app_available" ];then
            echo "$1 already on latest version"
            echo ""
            sleep 1
            wget -q -c "$3" -O "$1"-"$2".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            sleep 1
            tput rc; tput ed
        else
            echo "$1 update available"
            sleep 1
            tput rc; tput ed
            echo "Removing previous $1 apk..."
            rm $1-*.apk
            sleep 1
            tput rc; tput ed
            echo "Downloading latest $1 apk..."
            echo " "
            wget -q -c "$3" -O "$1"-"$2".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            sleep 1
            tput rc; tput ed
        fi
    else
        echo "No $1 apk found locally"
        echo " "
        echo "Downloading latest $1 apk..."
        echo " "
        wget -q -c "$3" -O "$1"-"$2".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
        sleep 1
        tput rc; tput ed
    fi
}

#Build apps

if [ "$appname" = "YouTube" ]
then
    [[ ! -f youtube_patches.txt ]] && python3 fetch.py yt patches
    excludeyt=$(while read -r line; do
        patch=$(echo "$line"| cut -d " " -f 2)
        printf -- " -e "
        printf "%s""$patch"
    done < <(grep " off" youtube_patches.txt))
    if [ "$variant" = "root" ]
    then
        appver=$( su -c dumpsys package com.google.android.youtube | grep versionName | cut -d= -f 2)
        python fetch.py yt root "$appver" & pid=$!
        trap 'kill $pid 2> /dev/null' EXIT
        while kill -0 $pid 2> /dev/null; do
            anim
        done
        trap - EXIT
        sleep 1
        tput rc; tput cd
        getlink="$(sed -n '5p' latest.txt)"
        get_components
        app_dl YouTube "$appver" "$getlink" &&
        echo "Building Youtube Revanced ..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./YouTube-* -e microg-support $excludeyt --keystore ./revanced.keystore -o ./com.google.android.youtube.apk --custom-aapt2-binary ./aapt2 --experimental
        echo "Mounting the apk"
        sleep 1; tput rc; tput cd
        if su -mm -c 'stockapp=$(pm path com.google.android.youtube | grep base | sed 's/package://g' ); grep com.google.android.youtube /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | xargs -r umount -l; done && mv com.google.android.youtube.apk /data/adb/revanced && revancedapp=/data/adb/revanced/com.google.android.youtube.apk; chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0 "$revancedapp"; mount -o bind "$revancedapp" "$stockapp" && am force-stop com.google.android.youtube && exit'
            then
                echo "Mounting successful"
                tput cnorm && cd ~ && exit
            
        else
            echo "Mount failed..."
            echo "Exiting the script"
            report
            tput cnorm && cd ~ && exit
        fi
    elif [ "$variant" = "non_root" ]
    then
        python fetch.py yt non_root & pid=$!
        trap 'kill $pid 2> /dev/null' EXIT
        while kill -0 $pid 2> /dev/null; do
            anim
        done
        trap - EXIT
        sleep 1
        tput rc; tput cd
        read -p "Download MicroG [y/n]: " mgprompt
        if [[ "$mgprompt" =~ [Y,y] ]]
        then
            microglink="$(sed -n '6p' latest.txt)"
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress
            echo ""
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify
            echo MicroG App saved to Revancify folder.
            sleep 1
        else
            :
        fi
        tput rc; tput cd
        appver=$(sed -n '4p' latest.txt)
        getlink="$(sed -n '5p' latest.txt)"
        get_components
        app_dl YouTube "$appver" "$getlink" &&
        echo "Building YouTube Revanced..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./YouTube-* $excludeyt --keystore ./revanced.keystore -o ./YouTubeRevanced-"$appver".apk --custom-aapt2-binary ./aapt2 --experimental
        mv YouTubeRevanced* /storage/emulated/0/Revancify/ &&
        sleep 1 &&
        echo "YouTube App saved to Revancify folder." &&
        echo "Thanks for using Revancify..." &&
        termux-open /storage/emulated/0/Revancify/YouTubeRevanced-"$appver".apk
        if [ "$mgprompt" = "y" ]
        then
            termux-open /storage/emulated/0/Revancify/Vanced_MicroG.apk
        else
            :
        fi
    fi
elif [ "$appname" = "YouTubeMusic" ]
then
    [[ ! -f youtubemusic_patches.txt ]] && python3 fetch.py ytm patches
    excludeytm=$(while read -r line; do
        patch=$(echo "$line"| cut -d " " -f 2)
        printf -- " -e "
        printf "%s""$patch"
    done < <(grep " off" youtubemusic_patches.txt))
    if [ "$variant" = "root" ]
    then
        appver=$(su -c dumpsys package com.google.android.apps.youtube.music | grep versionName | cut -d= -f 2 )
        if [ "$arch" = "arm64" ]
        then
            python fetch.py ytm root arm64 "$appver" & pid=$!
            trap 'kill $pid 2> /dev/null' EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
        elif [ "$arch" = "armeabi" ]
        then
            python fetch.py ytm root armeabi "$appver" & pid=$!
            trap 'kill $pid 2> /dev/null' EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
        fi
        sleep 1
        tput rc; tput cd
        getlink=$(sed -n '5p' latest.txt)
        get_components
        app_dl YouTubeMusic "$appver" "$getlink" &&
        echo "Building YouTube Music Revanced..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./YouTubeMusic* -e music-microg-support $excludeytm --keystore ./revanced.keystore -o ./com.google.android.apps.youtube.music.apk --custom-aapt2-binary ./aapt2 --experimental
        echo "Mounting the app"
        if su -mm -c 'stockapp=$(pm path com.google.android.apps.youtube.music | grep base | sed 's/package://g' ); grep com.google.android.apps.youtube.music /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | xargs -r umount -l; done && mv com.google.android.apps.youtube.music.apk /data/adb/revanced && revancedapp=/data/adb/revanced/com.google.android.apps.youtube.music.apk; chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0 "$revancedapp"; mount -o bind "$revancedapp" "$stockapp" && am force-stop com.google.android.apps.youtube.music && exit'
        then
            echo "Mounting successful"
            tput cnorm && cd ~ && exit
        
        else
            echo "Mount failed..."
            echo "Exiting the script"
            report
            tput cnorm && cd ~ && exit
        fi
    fi
    elif [ "$variant" = "non_root" ]
    then
        if [ "$arch" = "arm64" ]
        then
            python fetch.py ytm non_root arm64 & pid=$!
            trap 'kill $pid 2> /dev/null' EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
        elif [ "$arch" = "armeabi" ]
        then
            python fetch.py ytm non_root armeabi & pid=$!
            trap 'kill $pid 2> /dev/null' EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
        fi
        sleep 1
        tput rc; tput cd
        read -p "Download MicroG [y/n]: " mgprompt
        if [[ "$mgprompt" =~ [Y,y] ]]
        then
            microglink="$(sed -n '6p' latest.txt)"
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress
            echo ""
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify
            echo MicroG App saved to Revancify folder.
        else
            :
        fi
        tput rc; tput cd
        appver=$(sed -n '4p' latest.txt | sed 's/-/\./g')
        getlink="$(sed -n '5p' latest.txt)"
        get_components
        app_dl YouTubeMusic "$appver" "$getlink" &&
        echo "Building YouTube Music Revanced..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./YouTubeMusic* $excludeytm --keystore ./revanced.keystore -o ./YouTubeMusicRevanced-"$appver".apk --custom-aapt2-binary ./aapt2 --experimental
        mv YouTubeMusicRevanced* /storage/emulated/0/Revancify/ &&
        sleep 1 &&
        echo "YouTube Music App saved to Revancify folder." &&
        echo "Thanks for using Revancify..." &&
        termux-open /storage/emulated/0/Revancify/YouTubeMusicRevanced-"$appver".apk
elif [ "$appname" = "Twitter" ]
then
    python fetch.py twitter both & pid=$!
    trap 'kill $pid 2> /dev/null' EXIT
    while kill -0 $pid 2> /dev/null; do
        anim
    done
    trap - EXIT
    sleep 1
    tput rc; tput cd
    appver=$(sed -n '4p' latest.txt)
    getlink="$(sed -n '5p' latest.txt)"
    get_components
    app_dl Twitter "$appver" "$getlink" &&
    echo Building Twitter Revanced
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./Twitter-* --keystore ./revanced.keystore -o ./TwitterRevanced-"$appver".apk --custom-aapt2-binary ./aapt2 --experimental
    mv TwitterRevanced* /storage/emulated/0/Revancify/ &&
    sleep 1 &&
    echo "Twitter App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    termux-open /storage/emulated/0/Revancify/TwitterRevanced-"$appver".apk
elif [ "$appname" = "Reddit" ]
then
    python fetch.py reddit both & pid=$!
    trap 'kill $pid 2> /dev/null' EXIT
    while kill -0 $pid 2> /dev/null; do
        anim
    done
    trap - EXIT
    sleep 1
    tput rc; tput cd
    appver=$(sed -n '4p' latest.txt)
    getlink="$(sed -n '5p' latest.txt)"
    get_components
    app_dl Reddit "$appver" "$getlink" &&
    echo Building Reddit Revanced
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./Reddit-* -r --keystore ./revanced.keystore -o ./RedditRevanced-"$appver".apk --custom-aapt2-binary ./aapt2 --experimental
    mv RedditRevanced* /storage/emulated/0/Revancify/ &&
    sleep 1 &&
    echo "Reddit App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    termux-open /storage/emulated/0/Revancify/RedditRevanced-"$appver".apk
elif [ "$appname" = "TikTok" ]
then
    python fetch.py tiktok both & pid=$!
    trap 'kill $pid 2> /dev/null' EXIT
    while kill -0 $pid 2> /dev/null; do
        anim
    done
    trap - EXIT
    sleep 1
    tput rc; tput cd
    appver=$(sed -n '4p' latest.txt)
    getlink="$(sed -n '5p' latest.txt)"
    get_components
    app_dl TikTok "$appver" "$getlink" &&
    echo Building TikTok Revanced
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./TikTok-* -r --keystore ./revanced.keystore -o ./TikTokRevanced-"$appver".apk --custom-aapt2-binary ./aapt2 --experimental
    mv TikTokRevanced* /storage/emulated/0/Revancify/ &&
    sleep 1 &&
    echo "TikTok App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    termux-open /storage/emulated/0/Revancify/TikTokRevanced-"$appver".apk
fi
cd ~
tput cnorm
