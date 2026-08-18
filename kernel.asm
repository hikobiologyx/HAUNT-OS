# HAUNT OS Kernel - Multiboot Compliant (GAS Syntax)
.section .multiboot
.align 4
.long 0x1BADB002          # Magic number
.long 0x00000000          # Flags
.long 0xE1BF4594          # Checksum (-(magic + flags))

.section .bss
.align 16
stack_bottom:
.skip 16384               # 16 KB stack
stack_top:

.section .text
.global _start
.type _start, @function
_start:
    mov $stack_top, %esp  # Initialize stack pointer

    # Clear screen (BIOS interrupt 10h, function 06h)
    mov $0x0600, %ax
    mov $0x0000, %bx
    mov $0x184F, %cx      # Bottom right (80x25)
    mov $0x0000, %dx      # Top left
    int $0x10

    # Set cursor position to 0,0
    mov $0x0200, %ax
    mov $0x0000, %bx
    int $0x10

    # Print "HAUNT OS v1.0" using direct memory access (0xB8000)
    mov $0xB8000, %edi    # Video memory address
    mov $message, %esi    # Message address
    mov $0x0F, %ah        # White on black attribute

.print_loop:
    lodsb                 # Load byte from ESI into AL
    test %al, %al         # Check for null terminator
    jz .halt              # If zero, stop
    stosw                 # Store AX (char + attr) to ES:EDI
    jmp .print_loop

.halt:
    cli                   # Disable interrupts
.loop:
    hlt                   # Halt CPU
    jmp .loop             # Infinite loop

.section .rodata
message:
    .ascii "HAUNT OS v1.0 - System Online"
    .byte 0
.align 4
