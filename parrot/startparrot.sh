#!/data/data/com.termux/files/usr/bin/bash

#
# Parrot OS start script.
# Simple launcher by: dhocnet
# https://youtube.com/@HotPrendRoom
# https://dhocnet.work
#

echo "Initialing ..."
sleep 0.5
echo "Starting audio server ..."
pulseaudio --start \
    --load="module-native-protocol-tcp \
        auth-ip-acl=127.0.0.1 \
        auth-anonymous=1" \
    --exit-idle-time=-1
pacmd load-module \
    module-native-protocol-tcp \
    auth-ip-acl=127.0.0.1 \
    auth-anonymous=1

sleep 0.5
echo "Starting 3D graphic engine ..."
virgl_test_server_android &

sleep 0.5
echo "Starting X11 server ..."
sleep 0.5
echo "Entering Parrot Security OS ..."
sleep 1
am start --user 0 -n \
    com.termux.x11/com.termux.x11.MainActivity

### start x11
termux-x11 :0 -ac &

### chrooting to parrot
pd login beo --user nyet \
    --shared-tmp \
    -- /bin/bash -c "
        export DISPLAY=:0
        export PULSE_SERVER=tcp:127.0.0.1
        dbus-run-session xfce4-session > /dev/null 2>&1" &&

sleep 0.5
echo "Stopping service ..."
sleep 0.5
echo "Stopping audio server ..."
pkill pulseaudio
pkill pacmd
sleep 0.5
echo "Stopping 3D graphics engine ..."
pkill virgl_test_server
sleep 0.5
echo "Stopping X11 server ..."
pkill app_process
sleep 0.5
echo "Leaving Parrot Security OS ..."
sleep 0.5

