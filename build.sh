#!/bin/bash
set -e

echo "Building HAUNT OS Kernel..."

# Assemble kernel to object file
as --32 -o kernel.o kernel.asm

# Link kernel to ELF binary
ld -m elf_i386 -T linker.ld -o kernel.bin kernel.o

# Create ISO directory structure
mkdir -p iso/boot/grub

# Copy kernel
cp kernel.bin iso/boot/

# Create GRUB config
cat << 'GRUB_EOF' > iso/boot/grub/grub.cfg
set timeout=0
set default=0

menuentry "HAUNT OS" {
    multiboot /boot/kernel.bin
    boot
}
GRUB_EOF

# Generate ISO using grub-mkrescue
grub-mkrescue -o haunt_os.iso iso

echo "Build complete: haunt_os.iso"
ls -lh haunt_os.iso
readelf -h kernel.bin | head -5
