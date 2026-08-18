; HAUNT OS Bootloader (Stage 1)
; Simple bootloader that loads the kernel via GRUB

[bits 32]
[org 0x1000]

start:
    ; Set up stack
    mov esp, stack_top
    
    ; Clear screen (optional, GRUB already sets up video)
    mov edi, 0xb8000
    mov eax, 0x07200720  ; Space with gray on black
    mov ecx, 2000        ; 80x25 = 2000 characters
.clear_loop:
    stosd
    loop .clear_loop
    
    ; Print welcome message
    mov si, welcome_msg
    call print_string
    
    ; Halt (kernel would normally be loaded here by GRUB)
    cli
.halt:
    hlt
    jmp .halt

print_string:
    pusha
    mov edx, 0xb8000     ; VGA text mode address
.print_loop:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0F         ; White on black
    mov [edx], ax
    add edx, 2
    jmp .print_loop
.done:
    popa
    ret

welcome_msg db 'HAUNT OS v1.0 - Loading...', 13, 10, 'Copyright (C) 2024 HAUNT OS Project', 13, 10, 13, 10, 0

; Stack space
times 4096 db 0
stack_top:
