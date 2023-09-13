INITSEG  equ 0x9000	; we move boot here - out of the way
SYSSEG   equ 0x1000	; system loaded at 0x10000 (65536).
SETUPSEG equ 0x9020	; this is the current segment

start:
    mov ax,0x9000
    mov ds,ax
    mov ah,0x03
    xor bh,bh
    int 0x10        ;获取光标的位置,ah=3:读光标位置,bh:页号,dh:行号,dl:列号
    mov [0],dx


; Get memory size (extended mem, kB) - 获取内存信息。
    mov ah,0x88
    int 0x15
    mov [2],ax

; Get video-card data - 获取显卡显示模式。
    mov ah,0x0f
    int 0x10
    mov [4],bx      ; bh = display page
    mov [6],ax      ; al = video mode, ah = window width

; check for EGA/VGA and some config parameters - 检查显示方式并取参数
    mov ah,0x12
    mov bl,0x10
    int 0x10
    mov [8],ax
    mov [10],bx
    mov [12],cx

; Get hd0 data - 获取第一块硬盘的信息。
    mov ax,0x0000
    mov ds,ax
    lds si,[4*0x41]
    mov ax,INITSEG
    mov es,ax
    mov di,0x0080
    mov cx,0x10
    rep
    movsb

; Get hd1 data - 获取第二块硬盘的信息。
    mov ax,0x0000
    mov ds,ax
    lds si,[4*0x46]
    mov ax,INITSEG
    mov es,ax
    mov di,0x0090
    mov cx,0x10
    rep
    movsb

    cli                 ;把原本BIOS提供的中断向量表覆盖掉，写上操作系统的中断向量表，所以这个时候不允许中断

    mov ax,0x0000
    cld
;将操作系统向前移动0x1000
do_move:
    mov es,ax
    add ax,0x1000
    cmp ax,0x9000
    jz  end_move
    mov ds,ax
    sub di,di
    sub si,si
    mov cx,0x8000
    rep movsw
    jmp do_move

end_move:


;对可编程中断控制器 8259 芯片进行的编程
    mov al,0x11        ; initialization sequence
    out 0x20,al        ; send it to 8259A-1
    .word   0x00eb,0x00eb       ; jmp $+2, jmp $+2
    out 0xA0,al        ; and to 8259A-2
    .word   0x00eb,0x00eb
    mov al,0x20        ; start of hardware int's (0x20)
    out 0x21,al
    .word   0x00eb,0x00eb
    mov al,0x28        ; start of hardware int's 2 (0x28)
    out 0xA1,al
    .word   0x00eb,0x00eb
    mov al,0x04        ; 8259-1 is master
    out 0x21,al
    .word   0x00eb,0x00eb
    mov al,0x02        ; 8259-2 is slave
    out 0xA1,al
    .word   0x00eb,0x00eb
    mov al,0x01        ; 8086 mode for both
    out 0x21,al
    .word   0x00eb,0x00eb
    out 0xA1,al
    .word   0x00eb,0x00eb
    mov al,0xFF        ; mask off all interrupts for now
    out 0x21,al
    .word   0x00eb,0x00eb
    out 0xA1,al

    sti