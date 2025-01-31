.global _start

.section .rodata
seed:
.quad 0xffffffffffffffff
size:
.quad 0x0000000000010000
stdout:
.quad 1
stderr:
.quad 2
sys_write:
.quad 1
sys_open:
.quad 2
sys_close:
.quad 3
sys_fsync:
.quad 74
sys_exit:
.quad 60
exit_success:
.quad 0
exit_failure:
.quad 1
# values of flags can be found in header `/usr/include/bits/fcntl-linux.h'
O_CREAT:
.long 100
O_WRONLY:
.long 1
O_TRUNC:
.long 1000
# values of stat flags can be found in man open(2)
S_IWUSR:
.long 200
S_IRUSR:
.long 400
.align 8
msg:
.byte 's','u','c','c','e','s','s',10,0
msg_end:
.byte 0
.align 8
err:
.byte 'f','a','i','l','u','r','e',10,0
err_end:
.byte 0
.align 8
data:
.byte 'd','a','t','a','.','b','i','n',0
.align 8

.section .text
_start:
.stack:
pushq %rbp
movq %rsp, %rbp
subq $32, %rsp
.open:
movq sys_open, %rax
movq $data, %rdi
xorq %rsi, %rsi
orl O_CREAT, %esi
orl O_WRONLY, %esi
orl O_TRUNC, %esi
xorq %rdx, %rdx
orl S_IWUSR, %edx
orl S_IRUSR, %edx
syscall
cmpq $0, %rax
jl .error
# file-descriptor fd
movq %rax, -24(%rbp)
.ixorshift:
# loop index
movq $0, -16(%rbp)
# need an effective address to write pseudo-random numbers to the data file
leaq -8(%rbp), %rax
movq seed, %rbx
movq %rbx, (%rax)
.xorshift64:
movq (%rax), %rbx
shlq $13, %rbx
xorq %rbx, (%rax)
movq (%rax), %rbx
shrq $7, %rbx
xorq %rbx, (%rax)
movq (%rax), %rbx
shlq $17, %rbx
xorq %rbx, (%rax)
movq %rax, %rsi
movq sys_write, %rax
movq -24(%rbp), %rdi
movq $8, %rdx
syscall
cmpq $0, %rax
jl .error
addq $1, -16(%rbp)
leaq -8(%rbp), %rax
movq -16(%rbp), %rcx
cmpq size, %rcx
jne .xorshift64
.success:
movq sys_write, %rax
movq stdout, %rdi
movq $msg, %rsi
movq $msg_end, %rbx
subq %rsi, %rbx
movq %rbx, %rdx
syscall
.close:
movq sys_fsync, %rax
movq -24(%rbp), %rdi
syscall
movq sys_close, %rax
movq -24(%rbp), %rdi
syscall
.exit:
addq $32, %rsp
popq %rbp
movq sys_exit, %rax
movq exit_success, %rdi
syscall
.error:
movq sys_write, %rax
movq stderr, %rdi
movq $err, %rsi
movq $err_end, %rbx
subq %rsi, %rbx
movq %rbx, %rdx
syscall
addq $32, %rsp
popq %rbp
movq sys_exit, %rax
movq exit_failure, %rdi
syscall

# author: @misael-diaz
# source: xorshift64.asm
# Synopsis:
# Implements Marsaglia's xorshift64 algorithm to generate pseudo-random numbers.
# Displays the string "success" at the end.
# That is the expected output for this code.
# License: GPL2-only
