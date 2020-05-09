#!/bin/bash

sudo brctl addbr br0 #建立网桥br0
sudo tunctl -t tap0 -u develop # 建立一个tap设备，-t表示创建tap设备，-u表示用户名
sudo ifconfig ens33 down  #宿主机的网络接口关闭
sudo brctl addif br0 tap0    #给网桥添加tap0作为一个接口
sudo brctl addif br0 ens33 #给网桥添加ens33作为一个接口
sudo ifconfig br0 192.168.1.253 netmask 255.255.255.0   #为br0设置ip地址
sudo ifconfig tap0 192.168.1.252 netmask 255.255.255.0  #为tap0设置ip地址
sudo ifconfig ens33 192.168.1.80 netmask 255.255.255.0
sudo ifup ens33 up
