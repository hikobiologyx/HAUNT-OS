; HAUNT OS Kernel with Multiboot Header (32-bit)
bits 32

; Multiboot constants
MBALIGN  equ  1 << 0
MEMINFO  equ  1 << 1
FLAGS    equ  MBALIGN | MEMINFO
MAGIC    equ  0x1BADB002
CHECKSUM equ -(MAGIC + FLAGS)

; Multiboot header section
section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

; Stack setup
section .bss
align 16
stack_bottom:
    resb 16384
stack_top:

; Kernel entry point
section .text
global _start

_start:
    ; Set up the stack
    mov esp, stack_top

    ; Clear screen using BIOS interrupt
    mov ax, 0x0003      ; Set video mode 3 (80x25 text)
    int 0x10

    ; Print string using BIOS
    mov esi, welcome_msg
    call print_string

    ; Halt
    cli
hang_state:
    hlt
    jmp hang_state

; Function to print string at ESI
print_string:
    pusha
    mov ah, 0x0E        ; Teletype output
print_loop:
    lodsb
    test al, al
    jz print_done
    int 0x10
    jmp print_loop
print_done:
    popa
    ret

welcome_msg db 'HAUNT OS v1.0 - System Online', 13, 10, 0

section .note.GNU-stack noalloc noexec nowrite progbits
