#!/bin/bash
cd ../
export SRC_DIR=`pwd`/src
export IMAGE_DIR=`pwd`/images
export BUSY_BOX=$SRC_DIR/busybox-1.31.1 # 设置busybox的环境变量进行命令的转移
export ETC=$SRC_DIR/busybox-1.31.1/examples/bootfloppy/etc # 使用busybox中默认的配置
if [ 1 -eq $# ]; then
    if [ $1 = "clean" ]; then
        sudo rm -rf rootfs
        sudo rm -rf tmpfs
    fi
   exit 
fi
# 1.先进行清理操作
sudo rm -rf rootfs
sudo rm -rf tmpfs
sudo mkdir images
sudo mkdir rootfs
# 2.创建Linux中的必要文件夹
sudo mkdir -p rootfs/bin # /bin包含普通用户和超级用户都能使用的命令
sudo mkdir -p rootfs/sbin # /sbin包含系统运行的关键可执行文件以及一些管理程序
sudo mkdir -p rootfs/home # /home普通用户的工作目录，没有普通用户都会在这里建立一个文件夹
sudo mkdir -p rootfs/etc # /etc存放系统配置文件以及应用程序的配置文件
sudo mkdir -p rootfs/lib # /lib存放所有应用程序的共享文件以及内核模块
sudo mkdir -p rootfs/lib/modules # /lib存放所有应用程序的共享文件以及内核模块
sudo mkdir -p rootfs/proc/ # /proc目录是内核在内存中映射的实时文件系统，存放内核向用户应用程序提供的信息文件
sudo mkdir -p rootfs/sys/ # /sys是文件系统挂载的地方
sudo mkdir -p rootfs/tmp/ # /tmp存放系统或应用程序产生的临时文件
sudo mkdir -p rootfs/root/ # /root是超级用户的用户目录
sudo mkdir -p rootfs/var/ # /var存放假脱机数据以及系统日志
sudo mkdir -p rootfs/mnt/ # /mnt用于加载磁盘分区和硬件设备挂载点
sudo mkdir -p rootfs/usr # /usr包含所有用户的二进制文件和库文件等
sudo mkdir -p rootfs/dev/ # /dev用于存放设备文件

# 3.将busybox中的编译的可执行文件放到rootfs下
sudo cp -arf ${BUSY_BOX}/_install/*  rootfs/
sudo cp -arf ${ETC} rootfs/

# 4.添加交叉编译环境
sudo cp -arf /opt/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf/arm-none-linux-gnueabihf/lib rootfs/
sudo rm rootfs/lib/*.a
arm-none-linux-gnueabihf-strip rootfs/lib/*

# 5.创建设备文件
sudo mknod rootfs/dev/tty1 c 4 1
sudo mknod rootfs/dev/tty2 c 4 2
sudo mknod rootfs/dev/tty3 c 4 3
sudo mknod rootfs/dev/tty4 c 4 4
sudo mknod rootfs/dev/console c 5 1
sudo mknod rootfs/dev/null c 1 3

# 6.生成一个空的文件作为文件系统
sudo dd if=/dev/zero of=rootfs.ext3 bs=1M count=100
sudo mkfs -t ext3 rootfs.ext3
# 7.将文件系统挂载到tmpfs目录下
sudo mkdir -p tmpfs
sudo mount -t ext3 rootfs.ext3 tmpfs/ -o loop
# 8.将之前创建的文件系统相关的文件放到通过tmpfs放到rootfs.ext3文件系统中去
sudo cp -r rootfs/*  tmpfs/
sudo umount tmpfs
sudo mv rootfs.ext3 $IMAGE_DIR
sudo rm -rf tmpfs
