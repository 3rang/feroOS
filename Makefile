# Define variables
ARCH = i686-elf
AS = $(ARCH)-as
CC = $(ARCH)-gcc
LD = $(ARCH)-gcc
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -ffreestanding -O2 -nostdlib
LIBS = -lgcc
BOOT_DIR = boot/arch/x86_32
KERNEL_DIR = kernel
LINKER_DIR = linker
BUILD_DIR = build
ISO_DIR = $(BUILD_DIR)/isodir

# Targets
all: $(BUILD_DIR)/myos.iso

# Assemble the boot file
$(BUILD_DIR)/boot.o: $(BOOT_DIR)/boot.S
	$(AS) $< -o $@

# Compile the kernel
$(BUILD_DIR)/kernel.o: $(KERNEL_DIR)/kernel.c
	$(CC) -c $< -o $@ $(CFLAGS)

# Link the object files into the final binary
$(BUILD_DIR)/myos.bin: $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o
	$(LD) -T $(LINKER_DIR)/x86_32.ld -o $@ $^ $(LDFLAGS) $(LIBS)

# Create the ISO directory structure and copy files
$(ISO_DIR)/boot/grub/grub.cfg: grub.cfg
	mkdir -p $(ISO_DIR)/boot/grub
	cp $< $@

$(ISO_DIR)/boot/myos.bin: $(BUILD_DIR)/myos.bin
	mkdir -p $(ISO_DIR)/boot
	cp $< $@

# Create the ISO image
$(BUILD_DIR)/myos.iso: $(ISO_DIR)/boot/myos.bin $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o $@ $(ISO_DIR)

# Clean up build artifacts
clean:
	rm -rf $(BUILD_DIR)/*

# Print help message
help:
	@echo "Usage:"
	@echo "  make all      - Build the project"
	@echo "  make clean    - Clean the build artifacts"
	@echo "  make help     - Print this help message"

.PHONY: all clean help
