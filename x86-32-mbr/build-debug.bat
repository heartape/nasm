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

D:\program\Bochs-2.7\bochsdbg -f ../bochsrc.txt