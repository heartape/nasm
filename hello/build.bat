IF EXIST target (
    del target\hello.bin
    del target\hello.img
    del target\hello.img.lock
) ELSE (
    md target
)
cd target

start powershell -Command D:\program\Bochs-2.7\bximage -q -hd=16M -func=create -sectsize=512 -imgmode=flat hello.img
@ping 127.0.0.1 -n 5 > nul
D:\nasm\nasm -f bin ../hello.asm -o hello.bin
D:\nasm\dd if=hello.bin of=hello.img bs=512 count=1
D:\program\Bochs-2.7\bochs -f ../bochsrc.txt