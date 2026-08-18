/*
 * MyOS - A Simple Operating System Kernel
 * kernel.c - Main kernel code
 */

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;
typedef uint32_t size_t;

#define VGA_MEMORY 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

static size_t vga_row = 0;
static size_t vga_col = 0;

static inline uint16_t vga_entry(unsigned char uc, uint8_t color) {
    return (uint16_t)uc | ((uint16_t)color << 8);
}

static void vga_putchar(char c) {
    if (c == '\n') {
        vga_col = 0;
        vga_row++;
        return;
    }
    
    uint16_t* vga = (uint16_t*)VGA_MEMORY;
    size_t index = vga_row * VGA_WIDTH + vga_col;
    
    if (index >= VGA_WIDTH * VGA_HEIGHT) {
        vga_row = 0;
        vga_col = 0;
        index = 0;
    }
    
    vga[index] = vga_entry(c, 0x0F);
    vga_col++;
    
    if (vga_col >= VGA_WIDTH) {
        vga_col = 0;
        vga_row++;
    }
}

static void vga_print(const char* str) {
    while (*str) {
        vga_putchar(*str);
        str++;
    }
}

static void vga_println(const char* str) {
    vga_print(str);
    vga_putchar('\n');
}

static void clear_screen() {
    uint16_t* vga = (uint16_t*)VGA_MEMORY;
    for (size_t i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga[i] = vga_entry(' ', 0x07);
    }
    vga_row = 0;
    vga_col = 0;
}

void kernel_main(uint32_t magic, uint32_t* mboot_info) {
    clear_screen();
    
    vga_println("================================");
    vga_println("   Welcome to MyOS!");
    vga_println("================================");
    vga_println("");
    vga_println("Kernel loaded successfully!");
    vga_println("Multiboot magic: 0x");
    
    uint32_t temp = magic;
    char hex[9];
    int i = 7;
    do {
        hex[i--] = "0123456789ABCDEF"[temp & 0xF];
        temp >>= 4;
    } while (temp > 0 && i >= 0);
    while (i >= 0) hex[i--] = '0';
    hex[8] = '\0';
    vga_print(hex);
    
    vga_println("");
    vga_println("");
    vga_println("System Information:");
    vga_println("- CPU: x86 (32-bit)");
    vga_println("- Memory: Protected Mode");
    vga_println("- Bootloader: GRUB");
    vga_println("");
    vga_println("MyOS is running!");
    vga_println("Press any key to continue...");
    
    while(1) {
        __asm__ volatile ("hlt");
    }
}
