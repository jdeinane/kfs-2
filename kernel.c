# include "gdt.h"
/* fonction principale du noyau */

void kmain(void) {
    gdt_init();
}
