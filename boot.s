; produit des instructions pour le mode 32 bits
bits 32

; constante magique du protocole Multiboot (le bootloader s'en sert pour reconnaitre l'en-tete du noyau)
MAGIC       equ 0x1BADB002
; options du Multiboot
FLAGS       equ 0x0
; calcule la some de controle de l'en-tete
CHECKSUM    equ -(MAGIC + FLAGS)

; l'en-tete pour le bootloader
section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

; donnes reservees en memoire mais non itialisees
section .bss
align 16
stack_bottom:   ; debut de la zone reservee a la stack
    resb 16384  ; reserve 16 Ko initial stack
stack_top:      ; fin de la zone reservee, sommet initial de la stack

; contient le code machine executable
section .text
global _start   ; entrypoint du noyau
extern kmain    ; indique la definition externe du kmain (dans boot.s)

; etiquette du debut du code execute au demarrage
_start:
    mov esp, stack_top  ; initialise ESP (pointeur de stack): la stack x86 grandit vers les adresses + basses
    call kmain          ; appelle la fonction principale du noyau

; etiquette locale pour la boucle d'attente
.hang:
    cli         ; desactive les interruptions masquables du processeur
    hlt         ; met le processeur en attente jusqu'a ce qu'un event le reveille
    jmp .hang   ; revient a .hang et recommence
