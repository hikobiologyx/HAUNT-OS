section .text
    org 0x1000
    global _start

_start:
    ; Set up video mode (text mode)
    mov ax, 0x0003
    int 0x10
    
    ; Clear screen with welcome message
    mov si, welcome_msg
    call print_string
    
    ; Main loop
main_loop:
    jmp main_loop

print_string:
    pusha
    lodsb
    test al, al
    jz print_done
    mov ah, 0x0e
    mov bh, 0x00
    int 0x10
    jmp print_string

print_done:
    popa
    ret

welcome_msg db 'HAUNT OS v1.0', 13, 10
            db 'Welcome to HAUNT Operating System!', 13, 10
            db 'System initialized successfully.', 13, 10
            db 13, 10
            db 'HAUNT OS is running...', 13, 10
            db 0

; Padding to ensure kernel fits in allocated sectors
times 512*10-($-$$) db 0
