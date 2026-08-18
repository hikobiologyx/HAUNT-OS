; HAUNT OS - Minimal Operating System
; A simple bootloader and kernel

section .mbr
    org 0x7c00
    
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti
    
    ; Load kernel from disk
    mov ah, 0x02
    mov al, 10          ; Read 10 sectors
    mov ch, 0           ; Cylinder 0
    mov cl, 2           ; Sector 2 (kernel starts after boot sector)
    mov dh, 0           ; Head 0
    mov bx, 0x1000      ; Load to memory at 0x1000:0x0000
    int 0x13
    
    jc boot_error
    
    ; Jump to kernel
    jmp 0x0000:0x1000

boot_error:
    mov si, msg_error
    call print_string
    jmp $

print_string:
    lodsb
    test al, al
    jz print_done
    mov ah, 0x0e
    int 0x10
    jmp print_string

print_done:
    ret

msg_error db 'HAUNT OS Boot Error!', 0

; Padding and boot signature
times 510-($-$$) db 0
dw 0xaa55
