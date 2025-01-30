.global _start

.section .rodata
seed:
.long 0xffffffffffffffff
size:
.long 0x0000000000010000
stdout:
.quad 1
sys_write:
.quad 1
sys_exit:
.quad 60
exit_success:
.quad 0
msg:
.byte 's','u','c','c','e','s','s',10,0
msg_end:
.byte 0

.section .text
_start:
movq $0, %rcx
movq seed, %rax
.xorshift64:
movq %rax, %rbx
shlq $13, %rbx
xorq %rbx, %rax
movq %rax, %rbx
shrq $7, %rbx
xorq %rbx, %rax
movq %rax, %rbx
shlq $17, %rbx
xorq %rbx, %rax
addq $1, %rcx
cmpq size, %rcx
jne .xorshift64
movq sys_write, %rax
movq stdout, %rdi
movq $msg, %rsi
movq $msg_end, %rbx
subq %rsi, %rbx
movq %rbx, %rdx
syscall
movq sys_exit, %rax
movq exit_success, %rdi
syscall

# author: @misael-diaz
# source: xorshift64.asm
# Synopsis:
# Implements Marsaglia's xorshift64 algorithm to generate pseudo-random numbers.
# Displays the string "success" at the end.
# That is the expected output for this code.
# License: GPL2-only
