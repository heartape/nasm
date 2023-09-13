SECTION header vstart=0
    program_length  dd program_end                  ;1.用户程序的尺寸 dd progarm_end
    code_entry      dw start                        ;2.应用程序的入口点 dw 偏移地址
                    dd section.code.start                              ;dd 段地址
    realloc_tbl_len dw (header_end-code_segment)/4  ;3.段重定位表长度 dw 长度
    code_segment    dd section.code.start           ;4.段重定位表数据 dd section.xxx.start
    data_segment    dd section.data.start
    stack_segment   dd section.stack.start
header_ends:

SECTION .code vstart=0

SECTION .data vstart=0

SECTION .stack vstart=0
