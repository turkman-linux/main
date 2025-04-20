#!/bin/sh
source /etc/profile
mkdir -p ~/.cache/
exec &> ~/.cache/lightdm-user.log
if [ ${XDG_SESSION_TYPE} == "wayland" ] ; then
    # Wait until the Xorg process for the user finishes
    while pgrep -u 0 Xorg > /dev/null; do
        sleep 0.1
    done
    if [ "${XDG_RUNTIME_DIR}" == "" ] ; then
        export XDG_RUNTIME_DIR=/tmp/runtime-$USER
        mkdir -p ${XDG_RUNTIME_DIR}
    fi
    exec env dbus-run-session $@
else
    exec /etc/X11/xinit/Xsession $@
fi
