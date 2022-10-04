#!/data/data/com.termux/files/usr/bin/bash

revive(){
    clear && echo "Script terminated" && rm -rf ./*cache ; tput cnorm ; cd ~ || : ; exit
}
trap revive SIGINT

# For update change this sentence here ...

intro()
{
    tput civis
    tput cs 5 $LINES
    leave1=$(($(($(tput cols) - 34)) / 2))
    tput cm 1 $leave1
    echo "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█"
    tput cm 2 $leave1
    echo "█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░"
    tput cm 5 0
    tput sc
}

leavecols=$(($(($(tput cols) - 38)) / 2))
fullpagewidth=$(tput cols )
fullpageheight=$(($(tput lines) - 5 ))
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
    mainmenu
}

intro


selectapp()
{
    selectapp=$(dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'App Selection Menu' --ascii-lines --ok-label "Select" --menu "Select App" $fullpageheight $fullpagewidth 10 1 "YouTube" 2 "YouTube Music" 3 "Twitter" 4 "Reddit" 5 "TikTok" 2>&1> /dev/tty)
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
    mapfile -t choices < <(dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'Patch Selection Menu' --no-items --ascii-lines --ok-label "Save" --no-cancel --separate-output --checklist "Select patches to include" $fullpageheight $fullpagewidth 10 "${patches[@]}" 2>&1 >/dev/tty)
    tmp=$(mktemp)
    jq --arg pkgname "$pkgname" 'map(select(.appname == $pkgname).status = "off")' patches.json | jq 'map(select(IN(.patchname; $ARGS.positional[])).status = "on")' --args "${choices[@]}" > "$tmp" && mv "$tmp" ./patches.json
    mainmenu
}


patchoptions()
{
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./noinput.apk -o nooutput.apk > /dev/null 2>&1
    tput cnorm
    tmp=$(mktemp)
    dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --ascii-lines --title "Options File Editor" --editbox options.toml $fullpageheight $fullpagewidth 2> "$tmp" && mv "$tmp" ./options.toml
    tput civis
    clear
    mainmenu
}

mainmenu()
{   python3 ./python-utils/fetch-patches.py
    tput rc; tput ed
    mainmenu=$(dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'Select App' --ascii-lines --ok-label "Select" --cancel-label "Exit" --menu "Select Option" $fullpageheight $fullpagewidth 10 1 "Patch App" 2 "Select Patches" 3 "Edit Patch Options" 4 "Update Resources" 2>&1> /dev/tty)
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
        elif [ "$mainmenu" -eq "4" ]
        then
            clear
            intro
            get_components
        fi
    elif [ "$exitstatus" -ne "0" ]
    then
        revive
    fi
}

mountapk()
{
    if [ "$pkgname" = "com.google.android.youtube" ]
    then
        echo "Unmounting YouTube..."
        su -c 'grep com.google.android.youtube /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done && am force-stop com.google.android.youtube'
        su -c "cp /data/data/com.termux/files/home/storage/Revancify/"$appname"Revanced-"$appver".apk /data/local/tmp/revanced.delete && mv /data/local/tmp/revanced.delete /data/adb/revanced/com.google.android.youtube.apk"
        echo "Mounting YouTube Revanced ..."
        if su -mm -c 'stockapp=$(pm path com.google.android.youtube | grep base | sed 's/package://g') && revancedapp=/data/adb/revanced/com.google.android.youtube.apk && chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0 "$revancedapp" && mount -o bind "$revancedapp" "$stockapp" && am force-stop com.google.android.youtube && exit'
        then
            echo "Mounting successful"
            tput cnorm && cd ~ && exit
        
        else
            echo "Mount failed..."
            echo "Exiting the script"
            tput cnorm && cd ~ && exit
        fi
    elif [ "$pkgname" = "com.google.android.apps.youtube.music" ]
    then
        echo "Unmounting YouTube Music ..."
        su -mm -c 'grep com.google.android.apps.youtube.music /proc/mounts | while read -r line; do echo $line | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done'
        su -c "cp /data/data/com.termux/files/home/storage/Revancify/"$appname"Revanced-"$appver".apk /data/local/tmp/revanced.delete && mv /data/local/tmp/revanced.delete /data/adb/revanced/com.google.android.apps.youtube.music.apk && am force-stop com.google.android.apps.youtube.music"
        echo "Mounting YouTube Music Revanced ..."
        if su -c -mm 'stockapp=$(pm path com.google.android.apps.youtube.music | grep base | sed 's/package://g') && revancedapp=/data/adb/revanced/com.google.android.apps.youtube.music.apk && chmod 644 "$revancedapp" && chown system:system "$revancedapp" && chcon u:object_r:apk_data_file:s0 "$revancedapp" && mount -o bind "$revancedapp" "$stockapp" && am force-stop com.google.android.apps.youtube.music && exit'
        then
            echo "Mounting successful"
            tput cnorm && cd ~ && exit
        
        else
            echo "Mount failed..."
            echo "Exiting the script"
            tput cnorm && cd ~ && exit
        fi
    fi
    tput cnorm
    rm -rf ./*cache
    cd ~ || exit
    exit
}

moveapk()
{
    mkdir -p /storage/emulated/0/Revancify
    mv "$appname"Revanced* /storage/emulated/0/Revancify/ &&
    echo "$appname App saved to Revancify folder." &&
    echo "Thanks for using Revancify..." &&
    [[ -f Vanced_MicroG.apk ]] && termux-open /storage/emulated/0/Revancify/Vanced_MicroG.apk
    termux-open /storage/emulated/0/Revancify/"$appname"Revanced-"$appver".apk
}


dlmicrog()
{
    if dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'MicroG Prompt' --no-items --defaultno --ascii-lines --yesno "Vanced MicroG is used to run MicroG services without root.\nYouTube and YouTube Music won't work without it.\nIf you already have MicroG, You don't need to download it.\n\n\n\n\n\nDo you want to download Vanced MicroG app?" $fullpageheight $fullpagewidth
        then
            clear
            wget -q -c "https://github.com/TeamVanced/VancedMicroG/releases/download/v0.2.24.220220-220220001/microg.apk" -O "Vanced_MicroG.apk" --show-progress
            echo ""
            mv "Vanced_MicroG.apk" /storage/emulated/0/Revancify
            echo MicroG App saved to Revancify folder.
    fi
}

checkpatched()
{
    if su -c exit > /dev/null 2>&1
    then
        if ls ./"$appname"Revanced-"$appver"* > /dev/null 2>&1
        then
            if dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'Patched APK found' --no-items --defaultno --ascii-lines --yesno "Current directory contains a patched apk. Do You still want to patch?" $fullpageheight $fullpagewidth
            then
                rm ./"$appname"Revanced-"$appver"*
            else
                clear
                intro
                mountapk
            fi
        else
            rm ./"$appname"Revanced-*
        fi
    else
        if ls /storage/emulated/0/Revancify/"$appname"Revanced-"$appver"* > /dev/null 2>&1
        then
            if dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title 'Patched APK found' --no-items --defaultno --ascii-lines --yesno "Patched $appname with version $appver already exists. Do You still want to patch?" $fullpageheight $fullpagewidth
            then
                :
            else
                clear
                intro
                termux-open /storage/emulated/0/Revancify/"$appname"Revanced-"$appver".apk
                tput cnorm
                rm -rf ./*cache
                cd ~ || exit
                exit
            fi
        fi
    fi

}

arch=$(getprop ro.product.cpu.abi | cut -d "-" -f 1)


mainmenu

sucheck()
{
    if su -c exit > /dev/null 2>&1
    then
        su -c "mkdir -p /data/adb/revanced"
        if su -c "ls /data/adb/service.d/mount_revanced*" > /dev/null 2>&1
        then
            :
        else
            su -c "cp mount_revanced_com.google.android.youtube.sh /data/adb/service.d/ && chmod +x /data/adb/service.d/mount_revanced_com.google.android.youtube.sh"
            su -c "cp mount_revanced_com.google.android.apps.youtube.music.sh /data/adb/service.d/ && chmod +x /data/adb/service.d/mount_revanced_com.google.android.apps.youtube.music.sh"
        fi
        if su -c "dumpsys package $pkgname" | grep -q path
        then
            :
        else
            sleep 0.5s
            echo "Oh No, $appname is not installed"
            echo ""
            sleep 0.5s
            echo "Install $appname from PlayStore and run this script again."
            tput cnorm
            cd ~ || exit
            exit
        fi
    else
        dlmicrog
    fi
}

# App Downloader
app_dl()
{
    if ls ./"$appname"-* > /dev/null 2>&1
    then
        app_available=$(basename "$appname"-* .apk | cut -d '-' -f 2) #get version
        if [ "$appver" = "$app_available" ]
        then
            echo "Latest $appname apk already exists."
            echo ""
            sleep 0.5s
            wget -q -c "$applink" -O "$appname"-"$appver".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            sleep 0.5s
            tput rc; tput ed
        else
            echo "$appname update available !!"
            sleep 0.5s
            tput rc; tput ed
            echo "Removing previous $appname apk..."
            rm $appname-*.apk
            sleep 0.5s
            tput rc; tput ed
            echo "Downloading latest $appname apk..."
            echo " "
            wget -q -c "$applink" -O "$appname"-"$appver".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
            sleep 0.5s
            tput rc; tput ed
        fi
    else
        echo "No $appname apk found in Current Directory"
        echo " "
        echo "Downloading latest $appname apk..."
        echo " "
        wget -q -c "$applink" -O "$appname"-"$appver".apk --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
        sleep 0.5s
        tput rc; tput ed
    fi
}

patchexclusion()
{
    excludepatches=$(while read -r line; do printf %s"$line" " "; done < <(jq -r --arg pkgname "$pkgname" 'map(select(.appname == $pkgname and .status == "off"))[].patchname' patches.json | sed "s/^/-e /g"))
}

versionselector()
{
    if su -c exit > /dev/null 2>&1
    then
        if [ "$pkgname" = "com.google.android.youtube" ] || [ "$pkgname" = "com.google.android.apps.youtube.music" ]
        then
            appver=$(su -c dumpsys package $pkgname | grep versionName | cut -d= -f 2 )
        fi
    else
        mapfile -t appverlist < <(python3 ./python-utils/version-list.py "$appname")
        appver=$(dialog --begin 0 $leavecols --no-lines --infobox "█▀█ █▀▀ █░█ ▄▀█ █▄░█ █▀▀ █ █▀▀ █▄█\n█▀▄ ██▄ ▀▄▀ █▀█ █░▀█ █▄▄ █ █▀░ ░█░" 4 38 --and-widget --begin 5 0 --title "Version Selection Menu" --no-items --no-cancel --ascii-lines --ok-label "Select" --menu "Choose App Version" $fullpageheight $fullpagewidth 10 "${appverlist[@]}" 2>&1> /dev/tty)
    fi
}

fetchapk()
{
    clear
    intro
    echo "Please wait fetching link ..."
    applink=$(python3 ./python-utils/fetch-link.py "$appname" "$appver" "$arch")
    tput rc; tput ed
    app_dl
}

patchapp()
{
    echo "Patching $appname ..."
    patchexclusion
    java -jar ./revanced-cli*.jar -b ./revanced-patches*.jar -m ./revanced-integrations*.apk -c -a ./"$appname"-"$appver".apk $excludepatches --keystore ./revanced.keystore -o ./"$appname"Revanced-"$appver".apk --custom-aapt2-binary ./aapt2_"$arch" --options options.toml --experimental
    rm -rf revanced-cache
}

#Build apps
if [ "$pkgname" = "com.google.android.youtube" ] || [ "$pkgname" = "com.google.android.apps.youtube.music" ]
then
    sucheck
    versionselector
    checkpatched
    fetchapk
    patchapp
    if su -c exit > /dev/null 2>&1
    then
        mountapk
    else
        moveapk
    fi

else
    versionselector
    checkpatched
    fetchapk
    patchapp
    moveapk
fi

