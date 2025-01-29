.global _start

.section .data
nums:
.long 1,2,3,4,5,6,7,8,9,10
nums_end:
.long 0
res:
.long 55
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
movl $0, %eax
movq $nums, %rdx
.LC1:
movl (%rdx), %ebx
addl %ebx, %eax
addq $4, %rdx
cmpq $nums_end, %rdx
jne .LC1

cmpl res, %eax
jne .LC2
movq sys_write, %rax
movq stdout, %rdi
movq $msg, %rsi
movq $msg_end, %rbx
subq %rsi, %rbx
movq %rbx, %rdx

.LC2:
syscall
movq sys_exit, %rax
movq exit_success, %rdi
syscall

# author: @misael-diaz
# source: sum.asm
# Synopsis:
# Sums the elements of an array of integers.
# Displays the string "success" if the array sum was computed correctly.
# That is the expected output for this code.
# License: GPL2-only
