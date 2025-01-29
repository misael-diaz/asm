.global _start

.section .data
stdout:
.quad 1
sys_write:
.quad 1
sys_exit:
.quad 60
msg:
.ascii "hello world!\n"
len:
.quad 13
exit_success:
.quad 0

.section .text
_start:
movq sys_write, %rax
movq stdout, %rdi
movq $msg, %rsi
movq len, %rdx
syscall
movq sys_exit, %rax
movq exit_success, %rdi
syscall

# author: @misael-diaz
# source: hello.asm
# Synopsis:
# Hello World Example
# License: GPL2-only
