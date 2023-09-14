%include    '..\system\shell.asm'

SECTION code vstart=0

_main:
	
	call start_shell

sleep:
    hlt
	jmp sleep