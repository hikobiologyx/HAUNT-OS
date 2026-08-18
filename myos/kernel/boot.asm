; MyOS - A Simple Operating System Kernel
; boot.asm - Bootloader entry point (NASM syntax)

MAGIC_NUMBER equ 0x1BADB002
FLAGS equ (1 << 0 | 1 << 1)
CHECKSUM equ -(MAGIC_NUMBER + FLAGS)

section .multiboot
align 4
dd MAGIC_NUMBER
dd FLAGS
dd CHECKSUM

section .bss
align 16
stack_bottom:
resb 16384
stack_top:

section .text
global _start
extern kernel_main

_start:
    mov esp, stack_top
    
    push eax
    push ebx
    call kernel_main
    add esp, 8
    
.cli
.hang_loop:
    hlt
    jmp .hang_loop

; VGA print function
global kb_heap
kb_heap:
    mov ah, 0x0F
    mov al, 0x20
    mov edi, 0xB8000
    xor ecx, ecx

.print_loop:
    cmp edx, 0
    je .print_done
    
    mov al, [esi]
    mov [edi], ax
    add edi, 2
    inc esi
    dec edx
    jmp .print_loop

.print_done:
    ret
