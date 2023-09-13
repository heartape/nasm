    jmp near start
         
hello db 'hello world!'

start:
	mov ax,7c0h
	mov ds,ax
	xor si,si

	mov ax,0b800h
	mov es,ax
	xor di,di

	mov cx,12
            
show:
	mov al,[si+3]
	mov ah,4
	mov [es:di],ax
	add di,2
	inc si
	loop show

	jmp near ($)

  	times 510 - ($ - $$) db 0
    db 55h, 0aah
