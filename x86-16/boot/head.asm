%include    'main.asm'

start:
; 32位保护模式步骤
; 再次设置gdt、idt，因为之前的将要被覆盖
; 设置分页

; 16位
	push 0		; These are the parameters to main :-)
	push 0
	push 0
	push L6		; return address for main, if it decides to.
	push _main
	ret
L6:
	jmp L6

	times 512*16 - ($ - $$) db 0