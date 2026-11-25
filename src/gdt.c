#include "gdt.h"

static struct  gdt_entry *gdt = (struct gdt_entry *)GDT_ADDRESS;
static struct  gdt_ptr gp;

static void gdt_set_gate(int num, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran) {
    gdt[num].base_low       = (base & 0xFFFF);
    gdt[num].base_middle    = (base >> 16) & 0xFF;
    gdt[num].base_high      = (base >> 24) & 0xFF;

    gdt[num].limit_low      = (limit & 0xFFFF);
    gdt[num].granularity    = (limit >> 16) & 0x0F;
    gdt[num].granularity    |= gran & 0xF0;
    gdt[num].access         = access;
}

void gdt_init(void) {
    gp.limit = (sizeof(struct gdt_entry) * GDT_ENTRIES) - 1;
    gp.base = GDT_ADDRESS;

    gdt_set_gate(0, 0, 0, 0, 0);                // 0x00 : Null descriptor
    gdt_set_gate(1, 0, 0xFFFFF, 0x9A, 0xCF);    // 0x08 : Kernel Code
    gdt_set_gate(2, 0, 0xFFFFF, 0x92, 0xCF);    // 0x10 : Kernel Data
    gdt_set_gate(3, 0, 0xFFFFF, 0x92, 0xCF);    // 0x18 : Kernel Stack
    gdt_set_gate(4, 0, 0xFFFFF, 0xFA, 0xCF);    // 0x20 : User Code
    gdt_set_gate(5, 0, 0xFFFFF, 0xF2, 0xCF);    // 0x28 : User Data
    gdt_set_gate(6, 0, 0xFFFFF, 0xF2, 0xCF);    // 0x30 : User Stack

    gdt_flush((uint32_t)&gp);
}
