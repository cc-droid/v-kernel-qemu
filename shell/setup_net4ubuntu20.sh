#!/bin/sh
sudo brctl addbr br0
sudo tunctl -u develop -t tap0
sudo ifconfig tap0 192.168.1.111 promisc up
sudo  ifconfig ens33 192.168.1.100 promisc up
