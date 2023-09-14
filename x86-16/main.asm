SECTION code vstart=0
	; todo
	; hello db 'hello world!'

_main:
	mov ax,0
	mov ds,ax
	xor si,si

	mov ax,0b800h
	mov es,ax
	xor di,di

	mov cx,12
            
show:
	mov al,'$'
	mov ah,4
	mov [es:di],ax
	add di,2
	inc si
	loop show

sleep:
    hlt
	jmp sleep