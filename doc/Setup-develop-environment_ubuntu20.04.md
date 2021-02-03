# setup develop enviromment for ubuntu20.04

## preinstall

```shell
sudo apt install build-essential
sudo apt install bison
sudo apt install flex
sudo apt-get install gconf2
sudo apt install net-tools
sudo apt-get install bridge-utils
sudo apt-get install uml-utilities
sudo apt-get install libncurses5-dev libncursesw5-dev
sudo apt-get install u-boot-tools
```

## qemu install

```shell
sudo apt install qemu
sudo apt install qemu-system
```

## toolchain install

```shell
wget https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz 
sudo tar xvf gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz -C /opt
```

- **environment variables set**

  `sudo vim /etc/profile`

  add `PATH=$PATH:/opt/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf/bin` at tail

- **test toolchain**

  ```shell
  source /etc/profile`
  arm-none-linux-gnueabihf-gcc --version
  ```

  if output as below, succeed:

  > arm-none-linux-gnueabihf-gcc (GNU Toolchain for the A-profile Architecture 9.2-2019.12 (arm-9.10)) 9.2.1 20191025

## network setting

```shell
sudo brctl addbr br0
sudo apt-get install uml-utilities
sudo tunctl -u develop -t tap0
sudo brctl addif br0 tap0
sudo ifconfig tap0 192.168.1.111 promisc up
sudo ip address add 192.168.1.100/24 dev ens33
```

## NFS config

```shell
sudo apt-get install nfs-kernel-server
vim /etc/exports
	append /home/develop/develop/v-kernel-qemu/rootfs	192.168.1.100(ro,no_root_squash,sync,nohide) 
sudo service nfs-kernel-server restart 
showmount -e
```

in the qemu linux client:

```shell
ifconfig eth0 192.168.1.123 promisc up
mount -t nfs -o nolock 192.168.1.111:/home/develop/develop/v-kernel-qemu/rootfs /mnt
```

## fixed error

* **libtinfo.so.5**

> ./debug uboot
> arm-none-linux-gnueabihf-gdb: error while loading shared libraries: libtinfo.so.5: cannot open shared object file: No such file or directory

**fixed:**

```shell
ls -la /lib/x86_64-linux-gnu/libtinfo.so.*
lrwxrwxrwx 1 root root     15 May 12 07:00 /lib/x86_64-linux-gnu/libtinfo.so.6 -> libtinfo.so.6.2
-rw-r--r-- 1 root root 192032 Feb 25 23:14 /lib/x86_64-linux-gnu/libtinfo.so.6.2
```

`sudo ln -s /lib/x86_64-linux-gnu/libtinfo.so.6.2 /lib/x86_64-linux-gnu/libtinfo.so.5`

* **libncursesw.so.5**

> arm-none-linux-gnueabihf-gdb: error while loading shared libraries: libncursesw.so.5: cannot open shared object file: No such file or directory

**fixed:**

```shell
develop@ubuntu:~/develop/v-kernel-qemu/shell$ ls -la /lib/x86_64-linux-gnu/libncursesw.*
lrwxrwxrwx 1 root root     18 May 12 07:00 /lib/x86_64-linux-gnu/libncursesw.so.6 -> libncursesw.so.6.2
-rw-r--r-- 1 root root 231504 Feb 25 23:14 /lib/x86_64-linux-gnu/libncursesw.so.6.2
```

`sudo ln -s /lib/x86_64-linux-gnu/libncursesw.so.6.2 /lib/x86_64-linux-gnu/libncursesw.so.5`

* **python2.7**

  > arm-none-linux-gnueabihf-gdb: error while loading shared libraries: libpython2.7.so.1.0: cannot open shared object file: No such file or director

```shell
sudo apt-get install python2.7
sudo apt-get install libpython2.7
```

