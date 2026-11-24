# nom du fichier binaire final
NAME = kernel.bin

# outils utilises
CC = gcc	# compilateur
AS = nasm	# assembleur
LD = ld		# editeur de lien

# -m32 : compile en 32 bits
# -ffreestanding : compile pour un environnement sans OS (bare metal)
# -nostdlib : sans fichiers de demarrage ni bibliotheques standard
# -nodefaultlibs : sans les bibliotheques systeme par defaut au linker
# -fno-builtin : sans les builtins de GCC
# -fno-stack-protector : desactive la protection de pile
CFLAGS = -m32 \
	-ffreestanding \
	-nostdlib \
	-nodefaultlibs \
	-fno-builtin \
	-fno-stack-protector \
	-Wall -Wextra
# demande a NASM de produire des fichiers objets au format ELF 32 bits
ASFLAGS = -f elf32	
# options pour le linker:
# 	-m elf_i386: utilise le format ELF pour i386
#	-T linker.ld: utilise le script d'editions de lens linker.ld
LDFLAGS = -m elf_i386 -T linker.ld

# liste les fichiers objets necessaires pour construire le noyau
OBJS = boot.o kernel.o

# definit la cible all, elle depend de $(NAME)
# executer `make` construit donc kernel.bin
all: $(NAME)

# kernel.bin depend des OBJS, ensuite le linker LD creer le binaire final
$(NAME): $(OBJS)
	$(LD) $(LDFLAGS) -o $(NAME) $(OBJS)

# regle generique: compile un fichier C en fichier objet
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# 2e regle generique: compile un fichier AS en fichier objet
%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

# supprime les fichiers objets
clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)

re: fclean all

# lance le noyau avec QEMU dans une VM i386
run: $(NAME)
	qemu-system-i386 -kernel $(NAME)

.PHONY: all clean fclean re run