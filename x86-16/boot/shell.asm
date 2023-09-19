SECTION code_shell vstart=0 align=16

shell:

    mov ax,0b800h
	mov es,ax

    call clear_all

end_shell:
	jmp end_shell

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
    call write_line_prefix
    ; 写入光标
    add bx,9
    jmp write_cursor

    ret

; 写入行前缀
write_line_prefix:
    mov ax,0x1001
	mov ds,ax
    xor si,si
    xor di,di
	mov cx,9
            
show_line_prefix:
	mov al,'#'
	mov ah,0b00001111
	mov [es:di],ax
	inc si
	add di,2
	loop show_line_prefix

    ret

; 写入光标
; 参数bx：光标位置(0-1999)
write_cursor:
    push bx
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

    ;光标也需要写入样式
    pop bx
    shl bx,1
    inc bx
    mov byte [es:bx],0x0f

    ret
