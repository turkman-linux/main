#!/bin/bash
if [[ ! -f /var/cache/disable-gpu ]] &>/dev/null; then
    exit 0
fi
if grep "nomodeset" /proc/cmdline ; then
    exit 0
fi

remove_pci(){
    if [[ -d "/sys/bus/pci/devices/0000:$1/driver" ]] ; then
        module=$(basename $(readlink /sys/bus/pci/devices/0000:$1/driver/module))
        echo "Disabled: $module ($1)"
        rmmod -f $module
    fi
    echo 1 > /sys/bus/pci/devices/0000:$1/remove
}

echo 1 > /sys/bus/pci/rescan

for dir in /sys/class/drm/card[0-9*] ; do
    # 03 Display controller
    # 02 3D controller
    if grep "^0x0302" $dir/device/class ; then
      pci="$(basename $(readlink $dir/device))"
      echo "Found 3D controller: ${pci:5}"
      remove_pci "${pci:5}"
    fi
done
udevadm control --reload
