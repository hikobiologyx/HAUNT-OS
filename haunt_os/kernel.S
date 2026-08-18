# HAUNT OS Kernel - Pure Assembly with Multiboot Header (32-bit)
.section .multiboot
    .align 4
    .long 0x1BADB002            # Magic number
    .long 0x00000003            # Flags (align 4K, memory info)
    .long -(0x1BADB002 + 0x00000003)  # Checksum

.section .text
.globl _start
.type _start, @function

_start:
    # Set up stack
    mov $stack_top, %esp
    
    # Clear screen by writing directly to VGA buffer at 0xB8000
    mov $0xB8000, %edi
    
    # Clear screen with spaces (80*25 = 2000 characters)
    mov $0x0720, %ax          # Space character with attribute
    mov $2000, %cx            # Counter
clear_loop:
    mov %ax, (%edi)
    add $2, %edi
    loop clear_loop
    
    # Reset pointer to beginning
    mov $0xB8000, %edi
    
    # Print "HAUNT OS v1.0" using immediate values
    # H
    mov $'H', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # A
    mov $'A', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # U
    mov $'U', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # N
    mov $'N', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # T
    mov $'T', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # Space
    mov $' ', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # O
    mov $'O', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # S
    mov $'S', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # Space
    mov $' ', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # v
    mov $'v', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # 1
    mov $'1', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # .
    mov $'.', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    # 0
    mov $'0', %al
    mov %al, (%edi)
    mov $0x0F, 1(%edi)
    add $2, %edi
    
    # Halt loop
halt_loop:
    hlt
    jmp halt_loop

.section .bss
.align 16
stack_bottom:
    .skip 16384
stack_top:
