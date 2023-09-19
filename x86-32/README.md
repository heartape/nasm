# nasm-x86-32

## 1.软件安装
1. [Bochs](https://nchc.dl.sourceforge.net/project/bochs/bochs/2.7/Bochs-win64-2.7.exe)
2. [nasm](https://www.nasm.us/pub/nasm/releasebuilds/2.16/win64/nasm-2.16-win64.zip)
3. [dd](http://www.chrysocome.net/downloads/dd-0.5.zip)

## 2.配置
- build.bat: 配置软件路径
- bochsrc.txt: 配置romimage、vgaromimage、keyboard路径

## 3.运行
执行 build.bat

## 4.debug
执行 build-debug.bat
```shell
b 0x7c00
c
s
info gdt
x/512 0x7c00
```
