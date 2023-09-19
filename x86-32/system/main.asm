[bits 32]
SECTION code_shell vstart=512 align=16

main:
    mov eax,0x0008
	mov es,eax

    call clear_all

end_shell:
	jmp end_shell

clear_all:
	xor edi,edi
    mov ecx,2000
            
do_clear_all:
    mov eax,0
	mov [es:edi],eax
	add edi,2
	loop do_clear_all

    mov ebx,1
    jmp init_line
    ret

; 初始化行
; 参数bx：行号
init_line:
    dec ebx
    mov eax,80
    mul ebx
    mov ebx,eax
    call write_line_prefix
    ; 写入光标
    add ebx,9
    jmp write_cursor

    ret

; 写入行前缀
write_line_prefix:
    mov eax,0x1001
	mov ds,eax
    xor esi,esi
    xor edi,edi
	mov ecx,9
            
show_line_prefix:
    ; 如果需要读取data，需要重定位表
	mov al,[si+prefix+0x200]
	mov ah,0b00001111
	mov [es:edi],ax
	inc esi
	add edi,2
	loop show_line_prefix

    ret

; 写入光标
; 参数bx：光标位置(0-1999)
write_cursor:
    push ebx
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
    pop ebx
    shl ebx,1
    inc ebx
    mov byte [es:ebx],0x0f

    ret

prefix:
    db '[root ~]#'

times 512 - ($ - $$) db 0
