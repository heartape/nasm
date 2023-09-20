# nasm

## examples

1. hello
2. x86-16
3. x86-32-mbr
4. x86-32

## 软件安装

1. [Bochs](https://nchc.dl.sourceforge.net/project/bochs/bochs/2.7/Bochs-win64-2.7.exe)
2. [nasm](https://www.nasm.us/pub/nasm/releasebuilds/2.16/win64/nasm-2.16-win64.zip)
3. [dd](http://www.chrysocome.net/downloads/dd-0.5.zip)

centos nasm安装方式如下：

```shell
yum update
yum install make
yum install gcc gcc-c++ -y

wget --no-check-certificate https://www.nasm.us/pub/nasm/releasebuilds/2.16/nasm-2.16.tar.gz
tar zxvf nasm-2.16.tar.gz
cd nasm-2.16.tar.gz
./configure
make install
```

## 参考

1. 《x86汇编语言-从实模式到保护模式》
2. linux 0.11
