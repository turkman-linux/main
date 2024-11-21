#!/bin/sh

export PIPEWIRE_RUNTIME_DIR=$HOME/.config/pipewire
export XDG_RUNTIME_DIR=$HOME/.config

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

if [ -f "/usr/share/pipewire/pipewire-pulse.conf" ] ; then
    exec /usr/bin/pipewire-pulse &
fi
