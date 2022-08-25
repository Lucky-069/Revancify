#!/data/data/com.termux/files/bin/bash

revive(){
    clear && echo "Script terminated" && tput cnorm && exit
}
trap revive SIGINT

clear

intro()
{
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

if [ -e ~/../usr/bin/java ] && [ -e ~/../usr/bin/python ] && [ -e ~/../usr/bin/wget ] && [ -e ~/../usr/bin/tput ] && [ $(find ~/../usr/lib/ -name "wheel" | wc -l) != "0" ] && [ $(find ~/../usr/lib/ -name "requests" | wc -l) != "0" ] && [ $(find ~/../usr/lib/ -name "bs4" | wc -l) != "0" ]
then
    tput civis
    intro
    tput sc
    echo "Dependencies already installed"
    sleep 1
    tput rc
    tput cd
    sleep 1
else
    echo "Installing dependencies..." &&
    sleep 1 &&
    pkg update -y && 
    pkg install python -y &&
    pkg install openjdk-17 -y && 
    pkg install wget -y && 
    pkg install ncurses-utils -y &&
    pip install --upgrade pip &&
    pip install requests &&
    pip install wheel &&
    pip install bs4 &&
    sleep 1
    echo "Dependencies installed successfully."
    sleep 1
    echo "Run this script again"
    exit
fi

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




arch=$(getprop ro.product.cpu.abi | cut -d"-" -f1)

tput sc
echo "Checking for update..."
sleep 1

if [ "$(git pull)" != "Already up to date." ]
then
    sleep 1
    tput rc; tput cd
    echo Revancify updated...
    sleep 1
    echo Run this script again
    sleep 1
    tput cnorm
    exit
else
    echo ""
    echo "Script already up to date."
    sleep 1
    tput rc; tput cd
fi

user_input()
{
    tput sc
    echo "Which app do you want to patch?"
    echo "1. YouTube"
    echo "2. YouTube Music"
    read -p "Your Input: " input
    if [ "$input" -eq "1" ]
    then
        appname="YouTube"
    elif [ "$input" -eq "2" ]
    then
        appname="YouTubeMusic"
    else
        echo No input given..
        user_input
    fi
    tput rc
    tput cd
}

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
    su -c 'rm -rf /data/adb/revanced'
    su -c 'mkdir /data/adb/revanced'
    tput sc
    echo "SU Status: Root"
    echo ""
    sleep 1
    if [ "$appname" = "YouTube" ]
    then
        echo "Checking if YouTube is installed..."
        if $( su -c dumpsys package com.google.android.youtube | grep -q path )
        then
            sleep 1
            echo ""
            echo "YouTube is installed"
            sleep 1
            tput rc; tput cd
        else
            sleep 1
            tput rc; tput cd
            echo "Oh No, YouTube is not installed"
            echo ""
            sleep 1
            echo "Install YouTube from PlayStore and run this script again."
            tput cnorm
            exit
        fi
    elif [ "$appname" = "YouTubeMusic" ] 
    then
        echo "Checking if YouTube Music is installed..."
        if $( su -c dumpsys package com.google.android.apps.youtube.music | grep -q path )
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
            exit
            
        fi
    fi
else
    variant="non_root"
    mkdir -p /storage/emulated/0/Revancify
    echo "SU Status: Non Root"
fi

get_components(){
    #get patches version
    patches_latest=$(sed -n '1p' latest.txt)

    #get cli version
    cli_latest=$(sed -n '2p' latest.txt)

    #get patches version
    int_latest=$(sed -n '3p' latest.txt)

    #check patch
    if ls -l | grep -q revanced-patches*
    then
        patches_available=$(basename revanced-patches* .jar | cut -d'-' -f 3) #get version
        if [ "$patches_latest" = "$patches_available" ]
        then
            tput sc
            echo "Latest Patches already exixts."
            sleep 1
            tput rc; tput cd
        else
            tput sc
            echo "Patches update available"
            sleep 1
            tput rc; tput cd
            echo "Removing previous Patches..."
            rm revanced-patches*
            sleep 1
            tput rc; tput cd
            echo "Downloading latest Patches..."
            echo " "
            wget -q -c "https://github.com/revanced/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" || rm revanced-patches*
            sleep 1
            tput rc; tput cd
        fi
    else
        tput sc
        echo "No patches found in local storage"
        echo ""
        echo Downloading latest patches file...
        echo ""
        wget -q -c "https://github.com/revanced/revanced-patches/releases/download/v"$patches_latest"/revanced-patches-"$patches_latest".jar" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" || rm revanced-patches*
        sleep 1
        tput rc; tput cd
    fi

    #check cli
    if ls -l | grep -q revanced-cli*
    then
        cli_available=$(basename revanced-cli* .jar | cut -d'-' -f 3) #get version
        if [ "$cli_latest" = "$cli_available" ]
        then
            tput sc
            echo "Latest CLI already exists"
            sleep 1
            tput rc; tput cd
        else
            tput sc
            echo "CLI update available"
            sleep 1
            tput rc; tput cd
            echo Removing previous CLI
            rm revanced-cli*
            sleep 1
            tput rc; tput cd
            echo " "
            echo Downloading latest CLI...
            echo ""
            wget -q -c "https://github.com/revanced/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar" -O "revanced-cli-"$cli_latest".jar" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" || rm revanced-cli*
            sleep 1
            tput rc; tput cd
        fi
    else
        tput sc
        echo "No CLI found locally"
        echo ""
        echo Downloading latest CLI...
        echo ""
        wget -q -c "https://github.com/revanced/revanced-cli/releases/download/v"$cli_latest"/revanced-cli-"$cli_latest"-all.jar" -O "revanced-cli-"$cli_latest".jar" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" || rm revanced-cli*
        sleep 1
        tput rc; tput cd
    fi

    #check integrations
    if ls -l | grep -q revanced-integrations*
    then
        int_available=$(basename revanced-integrations* .apk | cut -d'-' -f 3) #get version
        if [ "$int_latest" = "$int_available" ]
        then
            tput sc
            echo "Latest Integrations already exists"
            sleep 3
            tput rc; tput cd
        else
            tput sc
            echo "Integrations update available"
            sleep 1
            tput rc; tput cd
            echo removing previous Integrations
            rm revanced-integrations*
            sleep 1
            tput rc; tput cd
            echo "Downloading latest Integrations apk..."
            echo ""
            wget -q -c "https://github.com/revanced/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk" -O "revanced-integrations-"$int_latest".apk" --show-progress  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" || rm revanced-integrations*
            echo ""
            sleep 1
            tput rc; tput cd
        fi
    else
        tput sc
        echo "No Integrations found locally"
        echo ""
        echo Downloading latest Integrations apk...
        echo ""
        wget -q -c "https://github.com/revanced/revanced-integrations/releases/download/v"$int_latest"/app-release-unsigned.apk" -O "revanced-integrations-"$int_latest".apk" --show-progress  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" || rm revanced-integrations*
        sleep 1
        tput rc; tput cd
    fi
}



#Check and Get Youtube
yt_dl()
{
    if ls -l | grep -q YouTube-*
    then
        yt_available=$(basename YouTube-* .apk | cut -d'-' -f2) #get version
        if [ "$ytver" = "$yt_available" ];then
            tput sc
            echo "YouTube already on latest version"
            sleep 1
            tput rc; tput cd
        else
            tput sc
            echo "YouTube update available"
            sleep 1
            tput rc; tput cd
            echo Removing previous YouTube apk
            rm YouTube-*.apk
            sleep 1
            tput rc; tput cd
            echo "Downloading latest YouTube apk..."
            echo " "
            wget -q -c $getlink -O "YouTube-"$ytver".apk" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" || rm YouTube-*
            sleep 1
            tput rc; tput cd
        fi
    else
        tput sc
        echo "No YouTube apk found locally"
        echo " "
        echo "Downloading latest YouTube apk..."
        echo " "
        wget -q -c $getlink -O "YouTube-"$ytver".apk" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" || rm YouTube-*
        sleep 1
        tput rc; tput cd
    fi
}

#Check and Get Youtube Music
ytm_dl()
{
    if ls -l | grep -q YouTubeMusic-*
    then
        ytm_available=$(basename YouTubeMusic-* .apk | cut -d'-' -f2) #get version
        if [ "$ytmver" = "$ytm_available" ]
        then
            tput sc
            echo "YouTube Music already on latest version"
            sleep 1
            tput rc; tput cd
        else
            tput sc
            echo "YouTube update available"
            sleep 1
            tput rc; tput cd
            echo Removing previous YouTube Music apk
            rm YouTubeMusic-*.apk
            sleep 1
            tput rc; tput cd
            echo "Downloading latest YouTube Music apk..."
            echo ""
            wget -q -c $getlink -O "YouTubeMusic-"$ytmver".apk" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" || rm YouTubeMusic-*
            sleep 1
            tput rc; tput cd
        fi
    else
        tput sc
        echo "No YouTube Music apk found locally"
        echo " "
        echo "Downloading latest YouTube Music apk..."
        echo " "
        wget -q -c $getlink -O "YouTubeMusic-"$ytmver".apk" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" || rm YouTubeMusic-*
        sleep 1
        tput rc; tput cd
    fi
}



if [ "$appname" = "YouTube" ]
then
    if [ "$variant" = "root" ]
    then
        ytver=$( su -c dumpsys package com.google.android.youtube | grep versionName | cut -d= -f2)
        getapp=$( echo "$ytver" | sed 's/\./-/g')
        python fetch.py yt root $getapp & pid=$!
        trap "kill $pid 2> /dev/null" EXIT
        while kill -0 $pid 2> /dev/null; do
            anim
        done
        trap - EXIT
        sleep 1
        tput rc; tput cd
        getlink="$(sed -n '5p' latest.txt)"
        get_components
        yt_dl &&
        echo "Building Youtube Revanced ..."
        echo ""
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./YouTube-* -e custom-branding -e always-autorepeat -e custom-playback-speed -e microg-support --keystore ./revanced.keystore -o ./com.google.android.youtube.apk --custom-aapt2-binary ./aapt2 --experimental
        sleep 3
        echo "Mounting the apk"
        sleep 1; tput rc; tput cd
        su -c 'cp com.google.android.youtube.apk /data/adb/revanced && revancedapp=/data/adb/revanced/com.google.android.youtube.apk; chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0  "$revancedapp" && exit' &&
        su -mm -c 'revancedapp=/data/adb/revanced/com.google.android.youtube.apk; stockapp=$(pm path com.google.android.youtube | grep base | sed 's/package://g' ); mount -o bind "$revancedapp" "$stockapp" && exit' &&
        su -c 'am force-stop com.google.android.youtube' && echo "YouTube Revanced successfully mounted. You can now use YouTube Revanced." && echo " " && echo "Thanks for using the Revancify..." || echo "Mount failed..." && tput cnorm && exit
    elif [ "$variant" = "non_root" ]
    then
        ytver=$(sed -n '4p' latest.txt | sed 's/-/\./g' )
        python fetch.py yt non_root & pid=$!
        trap "kill $pid 2> /dev/null" EXIT
        while kill -0 $pid 2> /dev/null; do
            anim
        done
        trap - EXIT
        sleep 1
        tput rc; tput cd
        getlink="$(sed -n '5p' latest.txt)"
        get_components
        yt_dl &&
        echo Building YouTube Revanced
        java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./YouTube-* -e custom-branding -e always-autorepeat -e custom-playback-speed --keystore ./revanced.keystore -o ./com.google.android.youtube.apk --custom-aapt2-binary ./aapt2 --experimental
        trap - EXIT
        sleep 3
        cp com.google.android.youtube.apk /storage/emulated/0/Revancify/ &&
        echo "YouTube App saved to Revancify folder. You can install the app" &&
        echo "Thanks for using the Revancify..."
    fi
elif [ "$appname" = "YouTubeMusic" ]
then
    if [ "$variant" = "root" ]
    then
        ytmver=$(su -c dumpsys package com.google.android.apps.youtube.music | grep versionName | cut -d= -f2 )
        getapp=$( echo "$ytmver" | sed 's/\./-/g')
        if [ "$arch" = "arm64" ]
        then
            python fetch.py ytm root arm64 $getapp & pid=$!
            trap "kill $pid 2> /dev/null" EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
            sleep 1
            tput rc; tput cd
            getlink=$(sed -n '5p' latest.txt)
            get_components
            ytm_dl &&
            echo Building YouTube Music Revanced...
            java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./YouTubeMusic* -e music-microg-support --keystore ./revanced.keystore -o ./com.google.android.apps.youtube.music.apk --custom-aapt2-binary ./aapt2 --experimental
            echo "Mounting the app"
            su -c 'cp com.google.android.apps.youtube.music.apk /data/adb/revanced; revancedapp=/data/adb/revanced/com.google.android.apps.youtube.music.apk; chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0  "$revancedapp" && exit' &&
            su -mm -c 'revancedapp=/data/adb/revanced/com.google.android.apps.youtube.music.apk; stockapp=$(pm path com.google.android.apps.youtube.music | grep base | sed 's/package://g' ); mount -o bind "$revancedapp" "$stockapp" && exit' &&
            su -c 'am force-stop com.google.android.apps.youtube.music' && echo "YouTube Music Revanced successfully mounted. You can now use YouTube Revanced." && echo " " && echo "Thanks for using the Revancify..." || echo "Mount failed..." && echo "Exiting the script" && tput cnorm && exit
        elif [ "$arch" = "armeabi" ]
        then
            python fetch.py ytm root armeabi $getapp & pid=$!
            trap "kill $pid 2> /dev/null" EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
            sleep 1
            tput rc; tput cd
            getlink="$(sed -n '5p' latest.txt)"
            get_components
            ytm_dl &&
            echo Building YouTube Music Revanced...
            java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./YouTubeMusic* -e music-microg-support --keystore ./revanced.keystore -o ./com.google.android.apps.youtube.music.apk --custom-aapt2-binary ./aapt2 --experimental
            echo "Mounting the app"
            su -c 'cp com.google.android.apps.youtube.music.apk /data/adb/revanced; revancedapp=/data/adb/revanced/com.google.android.apps.youtube.music.apk; chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0  "$revancedapp" && exit' &&
            su -mm -c 'revancedapp=/data/adb/revanced/com.google.android.apps.youtube.music.apk; stockapp=$(pm path com.google.android.apps.youtube.music | grep base | sed 's/package://g' ); mount -o bind "$revancedapp" "$stockapp" && exit' &&
            su -c 'am force-stop com.google.android.apps.youtube.music' && echo "YouTube Music Revanced successfully mounted. You can now use YouTube Revanced." && echo " " && echo "Thanks for using the Revancify..." || echo "Mount failed..." && echo "Exiting the script" && tput cnorm && exit
            fi
    elif [ "$variant" = "non_root" ]
    then
        if [ "$arch" = "arm64" ]
        then
            python fetch.py ytm non_root arm64 & pid=$!
            trap "kill $pid 2> /dev/null" EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
            sleep 1
            tput rc; tput cd
            ytmver=$(sed -n '4p' latest.txt | sed 's/\./-/g')
            getlink="$(sed -n '5p' latest.txt)"
            get_components
            ytm_dl &&
            echo Building YouTube Music Revanced...
            java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./YouTubeMusic* --keystore ./revanced.keystore -o ./com.google.android.apps.youtube.music.apk --custom-aapt2-binary ./aapt2 --experimental
            cp com.google.android.apps.youtube.music.apk /storage/emulated/0/Revancify/ &&
            echo "YouTube Music App saved to Revancify folder. You can install the app" &&
            echo "Thanks for using the Revancify..."
        elif [ "$arch" = "armeabi" ]
        then
            python fetch.py ytm non_root armeabi & pid=$!
            trap "kill $pid 2> /dev/null" EXIT
            while kill -0 $pid 2> /dev/null; do
                anim
            done
            trap - EXIT
            sleep 1
            tput rc; tput cd
            ytmver=$(sed -n '4p' latest.txt | sed 's/\./-/g')
            getlink="$(sed -n '5p' latest.txt)"
            get_components
            ytm_dl &&
            echo Building YouTube Music Revanced...
            java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -a ./YouTubeMusic* --keystore ./revanced.keystore -o ./com.google.android.apps.youtube.music.apk --custom-aapt2-binary ./aapt2 --experimental
            cp com.google.android.apps.youtube.music.apk /storage/emulated/0/Revancify/ &&
            echo "YouTube Music App saved to Revancify folder. You can install the app" &&
            echo "Thanks for using the Revancify..."
            fi
    fi
fi
 
tput cnorm
