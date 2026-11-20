# include <stdint.h>

void kmain(void) {
    uint16_t *vga = (uint16_t *)0xB8000;
    const char *msg = "42 kfs-2: Boot OK";
    uint8_t color = 0x0A;

    for (int i = 0; msg[i]; i++) {
        vga[i] = (uint16_t)msg[i] | ((uint16_t)color << 8);
    }
}
