# include <stdint.h>

/* fonction principale du noyau */

void kmain(void) {
    // cree un pointeur vers la memoire video VGA
    uint16_t *vga = (uint16_t *)0xB8000;
    // definit l'attribut de couleur VGA (vert clair sur fond noir)
    uint8_t color = 0x0A;
    const char *msg = "42 kfs-2: Boot OK";

    for (int i = 0; msg[i]; i++) {
        // ecrit le caracteur et sa couleur dans une cellule video de 16 bits
        vga[i] = (uint16_t)msg[i] | ((uint16_t)color << 8);
    }
}
