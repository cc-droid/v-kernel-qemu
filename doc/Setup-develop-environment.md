# Setup develop environment

> [TOC]

## **Host environment**

* **Platform**

  `win10 + vmware15.5 + fedora32 + qemu4.2 + gcc10.0.1`

* **network**

  ![network-env](./images/network.png)

## **prerequites install**
```shell
sudo dnf install flex
sudo dnf install bison
sudo yum install ncurses-devel
sudo dnf install ncurses-compat-libs.x86_64
sudo dnf install python27.x86_64
```

## **qemu install**

```shell
sudo dnf install qemu
sudo dnf install qemu-kvm
sudo dnf install virt-manager
```

##  **arm-toolchain install**

* **download address**

  [gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz](https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz?revision=fed31ee5-2ed7-40c8-9e0e-474299a3c4ac&la=en&hash=76DAF56606E7CB66CC5B5B33D8FB90D9F24C9D20)

* **install**

  ```shell
  wget https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz 
  tar zxvf gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz -C /opt
  ```

* **environment variables set**

  `sudo vim /etc/profile`

  add `PATH=$PATH:/opt/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf/bin` at tail

* **test toolchain**

  ```shell
  source /etc/profile`
  arm-none-linux-gnueabihf-gcc --version
  ```

  if output as below, succeed:

  > arm-none-linux-gnueabihf-gcc (GNU Toolchain for the A-profile Architecture 9.2-2019.12 (arm-9.10)) 9.2.1 20191025

## **tftpd install and configure**

```shell
sudo yum install tftp
sudo yum install tftp-server
sudo yum install xinetd
```

* Edit `/usr/lib/systemd/system/tftp.service`

  ExecStart=/usr/sbin/in.tftpd -s <font color="red"><u>/home/develop/vexpress-a9/linux-5.6.11/arch/arm/boot</u> </font>, append in this file, red underline text indicate your **tftp boot directory**  

* start xinetd.service and tftp.service

```shell
sudo systemctl daemon-reload
sudo systemctl start xinetd.service
sudo systemctl enable  xinetd.service
sudo systemctl start tftp.service
sudo systemctl enable tftp.service
```

* test tftpd

```shell
tftp 192.168.1.80
	get uImage
```

uImage is a file at tftp boot directory , you can desigate as your self, indicate succeed if get it :smile_cat:

## **nfs install and configure**
* install 
  `dnf install nfs-utils rpcbind`
  
* configure
  ``vim /etc/exports``
  append <font color="red"><u>`/home/develop/vexpressa9/rootfs`</u></font>  (ro,no_root_squash,sync,nohide) , 

  red underline text indicate your **nfs mount directory**  

* enable RPC and NFS services:

```shell
sudo systemctl enable rpcbind.service
sudo systemctl enable nfs-server.service
sudo systemctl restart rpcbind.service
sudo systemctl restart nfs-server.service
```

* check ststus

```shell
sudo systemctl status rpcbind.service
sudo systemctl status nfs-server.service
```

if output as below, succeed:athletic_shoe:

> Active: active (running)
> Active: active (exited)

## **qemu network configure**

when you boot kernel with qemu, to use nfs, you must setup the network

```shell
ifconfig eth0 192.168.1.100 up 
mount -t nfs -o nolock 192.168.1.80:/home/develop/vexpressa9/rootfs /mnt
```



just have fun!~~~~

any problem can contact me ~	

