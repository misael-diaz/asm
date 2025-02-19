.global _start

.section .rodata
sys_exit:
.quad 60
exit_success:
.quad 0

.section .text
_start:
movq $0x8000000000000000, %rax
bswapq %rax
movq sys_exit, %rax
movq exit_success, %rdi
syscall

# author: @misael-diaz
# source: swap.asm
# Synopsis:
# Swaps bytes.
# License: GPL2-only
