; HAUNT OS Kernel - Multiboot Compliant
; Assemble with: nasm -f elf32 kernel.asm -o kernel.o
; Link with: ld -m elf_i386 -T linker.ld kernel.o -o boot/kernel.bin

section .multiboot
    align 4
    dd 0x1BADB002            ; Magic number
    dd 0x00000000            ; Flags
    dd -(0x1BADB002 + 0x00000000) ; Checksum

section .text
    global start
    global stack_top

extern main

start:
    cli
    mov esp, stack_top
    sti
    call main
    jmp $

section .bss
    align 16
stack_bottom:
    resb 16384
stack_top:
