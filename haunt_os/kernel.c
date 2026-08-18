// HAUNT OS Kernel Main - C Implementation
// Simple VGA text mode output

void putc(char c) {
    static char *vga = (char *)0xB8000;
    static int x = 0, y = 0;
    
    if (c == '\n') {
        x = 0;
        y++;
        return;
    }
    
    vga[(y * 80 + x) * 2] = c;
    vga[(y * 80 + x) * 2 + 1] = 0x0F; // White on black
    x++;
    
    if (x >= 80) {
        x = 0;
        y++;
    }
}

void puts(const char *str) {
    while (*str) {
        putc(*str);
        str++;
    }
}

void main() {
    // Clear screen by writing spaces
    char *vga = (char *)0xB8000;
    for (int i = 0; i < 80 * 25 * 2; i++) {
        vga[i] = (i % 2 == 0) ? ' ' : 0x07;
    }
    
    puts("================================");
    puts("       HAUNT OS v1.0            ");
    puts("================================");
    puts("");
    puts("System initialized successfully!");
    puts("Welcome to your new OS.");
    puts("");
    puts("HAUNT OS is now running...");
    
    while (1) {
        __asm__ volatile ("hlt");
    }
}
