IF EXIST target (
    del target\bootsect.bin > nul
    del target\x86-32.img > nul
    del target\x86-32.img.lock > nul
) ELSE (
    md target
)
cd target

D:\program\Bochs-2.7\bximage -q -hd=16M -func=create -sectsize=512 -imgmode=flat x86-32.img

D:\nasm\nasm -f bin ..\boot\bootsect.asm -o bootsect.bin
D:\nasm\dd if=bootsect.bin of=x86-32.img bs=512 count=1

D:\nasm\nasm -f bin ..\boot\setup.asm -o setup.bin
D:\nasm\dd if=setup.bin of=x86-32.img bs=512 seek=1 count=4

D:\nasm\nasm -f bin ..\boot\head.asm -o x86-32.bin
D:\nasm\dd if=x86-32.bin of=x86-32.img bs=512 seek=5 count=1

D:\nasm\nasm -f bin ..\system\main.asm -o x86-32.bin
D:\nasm\dd if=x86-32.bin of=x86-32.img bs=512 seek=6 count=1

D:\program\Bochs-2.7\bochs -f ../bochsrc.txt