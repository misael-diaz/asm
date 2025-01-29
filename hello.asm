.global _start

.section .data
msg:
.byte 'h','e','l','l','o',' ','w','o','r','l','d','!',10,0
msg_end:
.byte 0
stdout:
.quad 1
sys_write:
.quad 1
sys_exit:
.quad 60
exit_success:
.quad 0

.section .text
_start:
movq sys_write, %rax
movq stdout, %rdi
movq $msg, %rsi
# gets the length of the message string `msg'
movq $msg_end, %rbx
subq %rsi, %rbx
movq %rbx, %rdx
syscall
movq sys_exit, %rax
movq exit_success, %rdi
syscall

# author: @misael-diaz
# source: hello.asm
# Synopsis:
# Hello World Example
# License: GPL2-only
