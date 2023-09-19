[bits 32]
start:
	; 再次设置gdt、idt，因为之前的数据将要被覆盖,这里没有需要就不做了

	push 0		; These are the parameters to main :-)
	push 0
	push 0
	push L6		; return address for main, if it decides to.
	push 0x200
	jmp setup_paging
L6:
	jmp L6

; 设置分页
setup_paging:
	; ......
	ret

times 512 - ($ - $$) db 0