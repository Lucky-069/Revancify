#!/system/bin/sh
while [ "$(getprop sys.boot_completed | tr -d '\r')" != "1" ]; do sleep 1; done
revancedapp="/data/adb/revanced/com.google.android.apps.youtube.music.apk"
stockapp=$(pm path com.google.android.apps.youtube.music | grep base | sed 's/package://g' )
chcon u:object_r:apk_data_file:s0  $revancedapp
mount -o bind $revancedapp $stockapp
