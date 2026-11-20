NAME = kernel.bin

CC = gcc
AS = nasm
LD = ld

CFLAGS = -m32 -ffreestanding -nostdlib -nodefaultlibs -fno-builtin -fno-stack-protector -Wall -Wextra
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T linker.ld

OBJS = boot.o kernel.o

all: $(NAME)

$(NAME): $(OBJS)
	$(LD) $(LDFLAGS) -o $(NAME) $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)

re: fclean all

run: $(NAME)
	qemu-system-i386 -kernel $(NAME)

.PHONY: all clean fclean re run