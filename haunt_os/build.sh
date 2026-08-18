#!/bin/bash

echo "Building HAUNT OS..."

# Assemble the kernel with GAS (GNU Assembler)
gcc -m32 -nostdlib -static -T linker.ld -o iso/boot/kernel.bin kernel.S

echo "Kernel built successfully!"

# Verify multiboot header
echo "Checking multiboot header..."
objdump -h iso/boot/kernel.bin | grep -A 5 ".multiboot" || echo "No .multiboot section found in objdump output"

# Create ISO
grub-mkrescue -o haunt_os.iso iso

echo "ISO created: haunt_os.iso"
ls -lh haunt_os.iso
