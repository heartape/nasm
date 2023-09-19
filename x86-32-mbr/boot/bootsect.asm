jmp start

; gdtr 寄存器值
gdt_48:
    dw   31       ; gdt limit=31
    dw   gdt+0x7c00, 0 ; gdt base = 0X7c00

; gdt(全局描述符表)
gdt:
    dw   0,0,0,0     ; 首个为空

    dw   0x01ff      ; 512
    dw   0x7c00      ; base address=0
    dw   0x9A00      ; code read/exec
    dw   0x00C0      ; granularity=4096, 386

    dw   0xffff
    dw   0x8000      ; base address=0x8000
    dw   0x920b      ; data read/write
    dw   0x0040      ; granularity=4096, 386

    dw   0x7a00
    dw   0x0000      ; base address=0
    dw   0x9200      ; stack read/write
    dw   0x00C0      ; granularity=4096, 386

start:
    lgdt  [0x7c00+gdt_48]

    ; 打开 A20 地址线，为了突破地址信号线 20 位的宽度，变成 32 位可用。
    in al,0x92          ; 南桥芯片内的端口 
    or al,0000_0010B
    out 0x92,al  

    cli

    ; 更改保护模式标志位
    mov ax,0x0001
    lmsw ax      ; This is it; 将 cr0 这个寄存器的位 0 置 1

    ; 段选择子结构（16位） 0~1：RPL，2：TI，3~15：描述符索引（需要跳转的段基址在gdt中的位置）
    jmp dword 0b0000_0000_0000_1000:flush     ; 8 -> 0000_0000_0000_1000 -> 0_0000_0000_0001 -> 1
    
[bits 32]
flush:
    ; stack
    mov cx,0b0000_0000_0001_1000        ;加载堆栈段选择子
    mov ss,cx
    mov esp,0x7c00

    mov ebp,esp                        ;保存堆栈指针
    push byte '.'                      ;压入立即数（字节）

    sub ebp,4
    cmp ebp,esp                        ;判断压入立即数时，ESP是否减4
    jnz end

    pop eax
    mov cx,0b0000_0000_0001_0000         ;加载数据段选择子(0b10)
    mov ds,cx

    mov cx,2000
    xor di,di
clear:
    mov ax,0x0f00
	mov [di],ax
	add di,2
	loop clear

    ;以下在屏幕上显示"Protect mode OK!"
    mov byte [0x00],'P'
    mov byte [0x02],'r'
    mov byte [0x04],'o'
    mov byte [0x06],'t'
    mov byte [0x08],'e'
    mov byte [0x0a],'c'
    mov byte [0x0c],'t'
    mov byte [0x0e],' '
    mov byte [0x10],'m'
    mov byte [0x12],'o'
    mov byte [0x14],'d'
    mov byte [0x16],'e'
    mov byte [0x18],' '
    mov byte [0x1a],'O'
    mov byte [0x1c],'K'
    mov byte [0x1e],'!'

end:
    hlt

    times 510-($-$$) db 0
    db 0x55,0xaa