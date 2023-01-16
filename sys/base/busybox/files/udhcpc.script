#!/bin/sh

# This script gets called by udhcpc to setup the network interfaces

ip addr add $ip/$mask dev $interface

if [ "$router" ]; then
  ip route add default via $router dev $interface
fi
