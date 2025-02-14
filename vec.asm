.global _start

sys_exit:
.quad 60
exit_success:
.quad 0
.align 8

.section .text
_start:
pushq %rbp
movq %rsp, %rbp
# we subtract 120 bytes to get the stack pointer aligned to a 64-byte boundary
# we checked this with GDB
subq $120, %rsp
# fast way of clearing bits out of registers
xorq %r8, %r8
xorq %r9, %r9
pxor %xmm0, %xmm0
pxor %xmm1, %xmm1
# sets all 128 bits to ones
vpcmpeqb %xmm0, %xmm0, %xmm0
movq $0xffffffffffffffff, %rax
movq %rax, %xmm0
# first 64-bits are ones and the following 64-bits are zeroes
vmovapd %xmm0, (%rsp)
# this is the data (binary pattern presents 1.0 for a 64-bit floating point)
movq $0x3ff0000000000000, %rax
movq $0x3ff0000000000000, %rbx
movq %rax, 16(%rsp)
movq %rbx, 24(%rsp)
vmovapd 16(%rsp), %xmm1
# conditional move for packed data to initialize an array of doubles with [1.0, 0.0]
vmaskmovpd %xmm1, %xmm0, 32(%rsp)
# we copy the data to these registers to look at the values with GDB's `i r` command
movq   (%rsp), %rax
movq  8(%rsp), %rbx
movq 16(%rsp), %rcx
movq 24(%rsp), %rdx
movq 32(%rsp), %r8
movq 40(%rsp), %r9
# restore the stack by adding 120 bytes and pop the stack bottom pointer
addq $120, %rsp
popq %rbp
movq sys_exit, %rax
movq exit_success, %rdi
syscall

# author: @misael-diaz
# source: vec.asm
# License: GPL2-only
