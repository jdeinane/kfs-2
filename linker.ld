ENTRY(_start)

/* declaration des sections qui composent le prog de sortie */
SECTIONS
{
    /* positionne le noyau a 1 Mo (adresse standard ou GRUB charge les noyaux) */
    . = 1M;

    /* contient le code executable (.text) */
    .text ALIGN(4K) :
    {
        *(.multiboot)
        *(.text)
    }

    /* sert aux donnees constantes en READONLY */
    .rodata ALIGN(4K) :
    {
        *(.rodata)
    }

    /* contient les donnees initialisees et modifiables */
    .data ALIGN(4K) :
    {
        *(.data)
    }

    /* contient les variables globales ou statiques non initialisees */
    .bss ALIGN(4K) :
    {
        *(COMMON)
        *(.bss)
    }
}
