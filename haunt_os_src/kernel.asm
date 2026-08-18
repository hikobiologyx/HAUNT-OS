# Multiboot header constants
.set MBALIGN, 1 << 0
.set MEMINFO, 1 << 1
.set FLAGS, MBALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .bss
.align 16
stack_bottom:
.space 16384
stack_top:

.section .text
.global _start
.type _start, @function

_start:
    mov $stack_top, %esp

    # Очистка экрана (режим VGA 80x25)
    movw $0xB800, %ax
    movw %ax, %es
    xorw %di, %di
    
    # Заполняем экран пробелами (черный фон)
    movw $0x0720, %ax
    movw $2000, %cx
clear_loop:
    stosw
    loop clear_loop

    # Вывод сообщения "HAUNT OS v1.0"
    movw $0xB800, %ax
    movw %ax, %es
    xorw %di, %di
    
    movw $0x0F48, %ax
    stosw
    movw $0x0F41, %ax
    stosw
    movw $0x0F55, %ax
    stosw
    movw $0x0F4E, %ax
    stosw
    movw $0x0F54, %ax
    stosw
    movw $0x0F20, %ax
    stosw
    movw $0x0F4F, %ax
    stosw
    movw $0x0F53, %ax
    stosw
    movw $0x0F20, %ax
    stosw
    movw $0x0F76, %ax
    stosw
    movw $0x0F31, %ax
    stosw
    movw $0x0F2E, %ax
    stosw
    movw $0x0F30, %ax
    stosw

    # Бесконечный цикл
hang:
    hlt
    jmp hang

.size _start, . - _start
