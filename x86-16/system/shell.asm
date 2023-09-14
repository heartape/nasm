SECTION .code vstart=0
start_shell:

    mov ax,0b800h
	mov es,ax

    call clear_all

	jmp near ($)

clear_all:
	xor di,di
    mov cx,2000
            
do_clear_all:
    mov ax,0
	mov [es:di],ax
	add di,2
	loop do_clear_all

    mov bx,1
    jmp init_line
    ret

; 初始化行
; 参数bx：行号
init_line:
    dec bx
    mov ax,80
    mul bx
    mov bx,ax
    ; 写入'>'标号
    mov al,'>'
	mov ah,0x7
	mov [es:bx],ax
    ; 写入光标
    add bx,2
    jmp write_cursor

    ret

; 写入光标
; 参数bx：光标位置(0-1999)
write_cursor:
    ;请求操作0x0e号寄存器
    mov dx,0x3d4
    mov al,0x0e
    out dx,al
    ;写入屏幕光标位置的高8位
    mov dx,0x3d5
    mov al,bh
    out dx,al

    ;请求操作0x0f号寄存器
    mov dx,0x3d4
    mov al,0x0f
    out dx,al
    ;写入屏幕光标位置的低8位
    mov dx,0x3d5
    mov al,bl
    out dx,al

    ret

SECTION .data vstart=0

SECTION .stack vstart=0
