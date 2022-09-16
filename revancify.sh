#!/data/data/com.termux/files/usr/bin/bash

revive(){
    clear && echo "Script terminated" && tput cnorm && cd ~ && exit
}
trap revive SIGINT

clear
rm -rf ./*cache

if [ -e ~/../usr/bin/java ] && [ -e ~/../usr/bin/python ] && [ -e ~/../usr/bin/wget ] && [ -e ~/../usr/bin/dialog ] && [ -e ~/../usr/bin/tput ] && [ "$(find ~/../usr/lib/ -name "wheel" | wc -l)" != "0" ] && [ "$(find ~/../usr/lib/ -name "requests" | wc -l)" != "0" ] && [ "$(find ~/../usr/lib/ -name "bs4" | wc -l)" != "0" ] && [ -e ~/../usr/bin/revancify ] 
then
    :
else
    echo "Installing dependencies..."
    sleep 0.5s
    pkg update -y &&
    pkg install python openjdk-17 wget ncurses-utils libxml2 libxslt dialog -y &&
    pip install --upgrade pip &&
    pip install requests wheel bs4 cython &&
    printf "#!/data/data/com.termux/files/usr/bin/bash"'\n'"cd ~/storage/Revancify/ && bash revancify.sh" > /data/data/com.termux/files/usr/bin/revancify &&
    chmod +x /data/data/com.termux/files/usr/bin/revancify
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
    #get patches version
    patches_latest=$(sed -n '1p' revanced-latest.txt)

    #get cli version
    cli_latest=$(sed -n '2p' revanced-latest.txt)

    #get patches version
    int_latest=$(sed -n '3p' revanced-latest.txt)

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
            echo "Patches update available."
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
}

intro

echo "Checking for update..."
sleep 0.5s

if [ "$(git pull)" != "Already up to date." ]
then
    sleep 0.5s
    tput rc; tput ed
    echo Revancify updated...
    printf "#!/data/data/com.termux/files/usr/bin/bash"'\n'"cd ~/storage/Revancify/ && bash revancify.sh" > /data/data/com.termux/files/usr/bin/revancify
    chmod +x /data/data/com.termux/files/usr/bin/revancify
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
    python3 revanced-latest.py
    get_components
fi

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


ytpatches()
{
    if dialog --backtitle "Revancify" --title 'YouTube Patches' --no-items --no-lines --no-shadow --no-cancel --yesno "All patches will be reset. Do You want to continue?" 10 40
    then
        :
    else
        clear
        intro
        user_input
        return 0
    fi
    python3 latest-app.py yt patches
    sed -i '/microg-support/d' youtube-patches.txt
    sed -i '/enable-debugging/d' youtube-patches.txt
    cmd=(dialog --backtitle "Revancify" --title 'YouTube Patches' --no-items --no-lines --no-shadow --ok-label "Save" --no-cancel --separate-output --checklist "Select patches to include" 20 40 10)
    patches=()
    while read -r line
    do
        read -r -a arr <<< "$line"
        patches+=("${arr[@]}")
    done < <(cat youtube-patches.txt)
    mapfile -t choices < <("${cmd[@]}" "${patches[@]}" 2>&1 >/dev/tty)
    while read -r line
    do
        echo "${choices[*]}" | grep -q "$line" || sed -i "/$line/s/ on/ off/" youtube-patches.txt
    done < <(cut -d " " -f 1 youtube-patches.txt)
    clear
    intro
    user_input
}


ytmpatches()
{
    if dialog --backtitle "Revancify" --title 'YouTube Patches' --no-items --no-lines --no-shadow --no-cancel --yesno "All patches will be reset. Do You want to continue?" 30 40
    then
        :
    else
        clear
        intro
        user_input
        return 0
    fi
    python3 latest-app.py ytm patches
    sed -i '/music-microg-support/d' youtubemusic-patches.txt
    cmd=(dialog --backtitle "Revancify" --title 'YouTube Music Patches' --no-items --no-lines --no-shadow --ok-label "Save" --no-cancel --separate-output --checklist "Select patches to include" 20 40 10)
    patches=()
    while read -r line
    do
        read -r -a arr <<< "$line"
        patches+=("${arr[@]}")
    done < <(cat youtubemusic-patches.txt)
    mapfile -t choices < <("${cmd[@]}" "${patches[@]}" 2>&1 >/dev/tty)
    while read -r line
    do
        echo "${choices[*]}" | grep -q "$line" || sed -i "/$line/s/ on/ off/" youtubemusic-patches.txt
    done < <(cut -d " " -f 1 youtubemusic-patches.txt)
    clear
    intro
    user_input
}



user_input()
{
    tput rc; tput ed
    echo "What do you want to do?"
    echo "1. Patch YouTube"
    echo "2. Patch YouTube Music"
    echo "3. Patch Twitter"
    echo "4. Patch Reddit"
    echo "5. Patch TikTok"
    echo "6. Edit Patches"
    echo "7. Edit Patches Options"
    read -r -p "Your Input: " input
    if [ "$input" -eq "1" ]
    then
        options="YouTube"
    elif [ "$input" -eq "2" ]
    then
        options="YouTubeMusic"
    elif [ "$input" -eq "3" ]
    then
        options="Twitter"
    elif [ "$input" -eq "4" ]
    then
        options="Reddit"
    elif [ "$input" -eq "5" ]
    then
        options="TikTok"
    elif [ "$input" -eq "6" ]
    then
        patchedit=$(dialog --backtitle "Revancify" --title 'Select App' --no-lines --no-shadow --ok-label "Select" --no-cancel --menu "Select Option" 10 40 10 1 "YouTube" 2 "YouTube Music" 2>&1> /dev/tty)
        if [ "$patchedit" -eq "1" ]
        then
            ytpatches
        elif [ "$patchedit" -eq "2" ]
        then
            ytmpatches
        fi

    elif [ "$input" -eq "7" ]
    then
        [ ! -e options.toml ] && echo "Generating Options File. Please wait..." &&
        java -jar revanced-cli* -b revanced-patches* -m revanced-integrations* -a no.apk -o nooutput.apk > /dev/null 2>&1
        rm -rf revanced-cache
        tput cnorm
        dialog --backtitle "Revancify" --no-lines --no-shadow --title "Edit Options file" --editbox options.toml 25 60 2> file.tmp && cat file.tmp > options.toml && rm file.tmp
        tput civis
        clear
        intro
        user_input
    else
        echo No input given..
        user_input
    fi
    tput rc; tput ed
}



arch=$(getprop ro.product.cpu.abi | cut -d "-" -f 1)
if [ -e ./aapt2 ]
then
    :
else 
    mv ./aapt2_$arch ./aapt2
    rm ./aapt2_*
fi

user_input

su_check()
{
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
        if [ "$options" = "YouTube" ]
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
        elif [ "$options" = "YouTubeMusic" ] 
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

#Build apps
su_check
if [ "$options" = "YouTube" ]
then
    [[ ! -f youtube-patches.txt ]] && python3 latest-app.py yt patches
    excludeyt=$(while read -r line; do
        patch=$(echo "$line"| cut -d " " -f 1)
        printf -- " -e "
        printf "%s""$patch"
    done < <(grep " off" youtube-patches.txt))
    if [ "$variant" = "root" ]
    then
        appver=$( su -c dumpsys package com.google.android.youtube | grep versionName | cut -d= -f 2)
        python3 latest-app.py yt root "$appver" & pid=$!
        trap 'kill $pid 2> /dev/null' EXIT
        while kill -0 $pid 2> /dev/null; do
            anim
        done
        trap - EXIT
        sleep 0.5s
        tput rc; tput ed
        getlink="$(sed -n '2p' latest-app.txt)"
        app_dl YouTube "$appver" "$getlink" &&
        echo "Building Youtube Revanced ..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./YouTube-"$appver".apk -e microg-support $excludeyt --keystore ./revanced.keystore -o ./com.google.android.youtube.apk --custom-aapt2-binary ./aapt2 --experimental --options options.toml
        rm -rf revanced-cache
        echo "Mounting the app"
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
        python3 latest-app.py yt non_root & pid=$!
        trap 'kill $pid 2> /dev/null' EXIT
        while kill -0 $pid 2> /dev/null; do
            anim
        done
        trap - EXIT
        sleep 0.5s
        tput rc; tput ed
        read -r -p "Download MicroG [y/n]: " mgprompt
        if [[ "$mgprompt" =~ [Y,y] ]]
        then
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress
            echo ""
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify
            echo MicroG App saved to Revancify folder.
            sleep 0.5s
        else
            :
        fi
        tput rc; tput ed
        appver=$(sed -n '1p' latest-app.txt)
        getlink="$(sed -n '2p' latest-app.txt)"
        app_dl YouTube "$appver" "$getlink" &&
        echo "Building YouTube Revanced..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./YouTube-"$appver".apk $excludeyt --keystore ./revanced.keystore -o ./YouTubeRevanced-"$appver".apk --custom-aapt2-binary ./aapt2 --experimental --options options.toml
        rm -rf revanced-cache
        mv YouTubeRevanced* /storage/emulated/0/Revancify/ &&
        sleep 0.5s
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
elif [ "$options" = "YouTubeMusic" ]
then
    [[ ! -f youtubemusic-patches.txt ]] && python3 latest-app.py ytm patches
    excludeytm=$(while read -r line; do
        patch=$(echo "$line"| cut -d " " -f 1)
        printf -- " -e "
        printf "%s""$patch"
    done < <(grep " off" youtubemusic-patches.txt))
    if [ "$variant" = "root" ]
    then
        appver=$(su -c dumpsys package com.google.android.apps.youtube.music | grep versionName | cut -d= -f 2 )
        if [ "$arch" = "arm64" ]
        then
            python3 latest-app.py ytm root arm64 "$appver" & pid=$
            trap 'kill $pid 2> /dev/null' EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
        elif [ "$arch" = "armeabi" ]
        then
            python3 latest-app.py ytm root armeabi "$appver" & pid=$!
            trap 'kill $pid 2> /dev/null' EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
        fi
        sleep 0.5s
        tput rc; tput ed
        getlink=$(sed -n '2p' latest-app.txt)
        app_dl YouTubeMusic "$appver" "$getlink" &&
        echo "Building YouTube Music Revanced..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./YouTubeMusic-"$appver".apk -e music-microg-support $excludeytm --keystore ./revanced.keystore -o ./com.google.android.apps.youtube.music.apk --custom-aapt2-binary ./aapt2 --experimental
        rm -rf revanced-cache
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
    elif [ "$variant" = "non_root" ]
    then
        if [ "$arch" = "arm64" ]
        then
            python3 latest-app.py ytm non_root arm64 & pid=$!
            trap 'kill $pid 2> /dev/null' EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
        elif [ "$arch" = "armeabi" ]
        then
            python3 latest-app.py ytm non_root armeabi & pid=$!
            trap 'kill $pid 2> /dev/null' EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
        fi
        sleep 0.5s
        tput rc; tput ed
        read -r -p "Download MicroG [y/n]: " mgprompt
        if [[ "$mgprompt" =~ [Y,y] ]]
        then
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress
            echo ""
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify
            echo MicroG App saved to Revancify folder.
        else
            :
        fi
        tput rc; tput ed
        appver=$(sed -n '1p' latest-app.txt | sed 's/-/\./g')
        getlink=$(sed -n '2p' latest-app.txt)
        app_dl YouTubeMusic "$appver" "$getlink" &&
        echo "Building YouTube Music Revanced..."
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./YouTubeMusic-"$appver".apk $excludeytm --keystore ./revanced.keystore -o ./YouTubeMusicRevanced-"$appver".apk --custom-aapt2-binary ./aapt2 --experimental
        rm -rf revanced-cache
        mv YouTubeMusicRevanced* /storage/emulated/0/Revancify/ &&
        sleep 0.5s &&
        echo "YouTube Music App saved to Revancify folder." &&
        echo "Thanks for using Revancify..." &&
        termux-open /storage/emulated/0/Revancify/YouTubeMusicRevanced-"$appver".apk
    fi
elif [ "$options" = "Twitter" ]
then
    python3 latest-app.py twitter & pid=$!
    trap 'kill $pid 2> /dev/null' EXIT
    while kill -0 $pid 2> /dev/null; do
        anim
    done
    trap - EXIT
    sleep 0.5s
    tput rc; tput ed
    appver=$(sed -n '1p' latest-app.txt | cut -d "-" -f 1)
    getlink=$(sed -n '2p' latest-app.txt)
    app_dl Twitter "$appver" "$getlink" &&
    echo Building Twitter Revanced
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./Twitter-"$appver".apk --keystore ./revanced.keystore -o ./TwitterRevanced-"$appver".apk --custom-aapt2-binary ./aapt2 --experimental
    rm -rf revanced-cache
    mkdir -p /storage/emulated/0/Revancify
    mv TwitterRevanced* /storage/emulated/0/Revancify/ &&
    sleep 0.5s &&
    echo "Twitter App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    termux-open /storage/emulated/0/Revancify/TwitterRevanced-"$appver".apk
elif [ "$options" = "Reddit" ]
then
    python3 latest-app.py reddit & pid=$!
    trap 'kill $pid 2> /dev/null' EXIT
    while kill -0 $pid 2> /dev/null; do
        anim
    done
    trap - EXIT
    sleep 0.5s
    tput rc; tput ed
    appver=$(sed -n '1p' latest-app.txt)
    getlink=$(sed -n '2p' latest-app.txt)
    app_dl Reddit "$appver" "$getlink" &&
    echo Building Reddit Revanced
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./Reddit-"$appver".apk -r --keystore ./revanced.keystore -o ./RedditRevanced-"$appver".apk --custom-aapt2-binary ./aapt2 --experimental
    rm -rf revanced-cache
    mkdir -p /storage/emulated/0/Revancify
    mv RedditRevanced* /storage/emulated/0/Revancify/ &&
    sleep 0.5s &&
    echo "Reddit App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    termux-open /storage/emulated/0/Revancify/RedditRevanced-"$appver".apk
elif [ "$options" = "TikTok" ]
then
    python3 latest-app.py tiktok & pid=$!
    trap 'kill $pid 2> /dev/null' EXIT
    while kill -0 $pid 2> /dev/null; do
        anim
    done
    trap - EXIT
    sleep 0.5s
    tput rc; tput ed
    appver=$(sed -n '1p' latest-app.txt)
    getlink=$(sed -n '2p' latest-app.txt)
    app_dl TikTok "$appver" "$getlink" &&
    echo Building TikTok Revanced
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./TikTok-"$appver".apk -r --keystore ./revanced.keystore -o ./TikTokRevanced-"$appver".apk --custom-aapt2-binary ./aapt2 --experimental
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
