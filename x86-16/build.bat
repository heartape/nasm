IF EXIST target (
    del target\bootsect.bin > nul
    del target\setup.bin > nul
    del target\x86-16.bin > nul
    del target\x86-16.img > nul
    del target\x86-16.img.lock > nul
) ELSE (
    md target
)
cd target

::start powershell -Command D:\program\Bochs-2.7\bximage -q -hd=16M -func=create -sectsize=512 -imgmode=flat x86-16.img
::@ping 127.0.0.1 -n 5 > nul
D:\program\Bochs-2.7\bximage -q -hd=16M -func=create -sectsize=512 -imgmode=flat x86-16.img

D:\nasm\nasm -f bin ..\boot\bootsect.asm -o bootsect.bin
D:\nasm\dd if=bootsect.bin of=x86-16.img bs=512 count=1

D:\nasm\nasm -f bin ..\boot\setup.asm -o setup.bin
D:\nasm\dd if=setup.bin of=x86-16.img bs=512 seek=1 count=4

D:\nasm\nasm -f bin ..\boot\head.asm -o x86-16.bin -I D:\work\project\github\nasm\x86-16
D:\nasm\dd if=x86-16.bin of=x86-16.img bs=512 seek=5 count=16

D:\program\Bochs-2.7\bochs -f ../bochsrc.txt