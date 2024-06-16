#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

void printf(const char* str);

void kernel_main() {
    printf("Hello, World!");
    printf("0x10");
    while (1) {
        // Infinite loop to keep the kernel running
    }
}

void printf(const char* str) {
    unsigned short* VideoMemory = (unsigned short*)0xB8000;
    for (int i = 0; str[i] != '\0'; ++i) {
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | str[i];
    }
}
