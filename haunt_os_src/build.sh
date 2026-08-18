#!/bin/bash
set -e

echo "Building HAUNT OS..."

# Ассемблирование ядра в объектный файл
as --32 -o kernel.o kernel.asm

# Линковка в ELF формат с использованием скрипта линковки
ld -m elf_i386 -T linker.ld -o kernel.bin kernel.o

# Создание структуры ISO
mkdir -p isodir/boot/grub
cp kernel.bin isodir/boot/kernel.bin

# Создание конфигурации GRUB
cat > isodir/boot/grub/grub.cfg << 'GRUBCFG'
menuentry "HAUNT OS" {
    multiboot /boot/kernel.bin
}
GRUBCFG

# Генерация ISO образа
grub-mkrescue -o haunt_os.iso isodir

echo "Build complete! haunt_os.iso created."
ls -lh haunt_os.iso
