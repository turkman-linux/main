#!/bin/bash
export PIPEWIRE_RUNTIME_DIR=/run/pipewire
export XDG_RUNTIME_DIR=/run/pipewire
export PULSE_RUNTIME_PATH=/run/pipewire/pulse
umask 002

# We need to kill any existing pipewire instance to restore sound
pkill -u "${USER}" -fx /usr/bin/pipewire-pulse 1>/dev/null 2>&1
pkill -u "${USER}" -fx /usr/bin/pipewire-media-session 1>/dev/null 2>&1
pkill -u "${USER}" -fx /usr/bin/wireplumber 1>/dev/null 2>&1
pkill -u "${USER}" -fx /usr/bin/pipewire 1>/dev/null 2>&1

exec /usr/bin/pipewire &

# wait for pipewire to start before attempting to start related daemons
while [ "$(pgrep -f /usr/bin/pipewire)" = "" ]; do
        sleep 1
done

if [ -x /usr/bin/wireplumber ]; then
	exec /usr/bin/wireplumber &
elif [ -x /usr/bin/pipewire-media-session ]; then
	exec /usr/bin/pipewire-media-session &
fi
# wait until start pipewire
while ! [ -e /run/pipewire/pipewire-0 ] ; do
    sleep 1
done
chgrp audio -R /run/pipewire/
# start pipewire-pulse
if [ -f "/usr/share/pipewire/pipewire-pulse.conf" ] ; then
    dbus=''
    if [ -f /usr/bin/dbus-run-session ] ; then
        dbus='/usr/bin/dbus-run-session'
    fi
    exec $dus /usr/bin/pipewire-pulse &
    # wait until start pipewire-pulse
    while ! [ -e /run/pipewire/pulse/native ] ; do
        sleep 1
    done
    chgrp audio -R /run/pipewire/pulse
    chmod 775 /run/pipewire/pulse
fi
wait