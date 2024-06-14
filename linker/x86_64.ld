OUTPUT_FORMAT(elf64-x86-64)  // 64-bit ELF

ENTRY(start)

SECTIONS {
    . = 0x100000;   // Set the starting address for the executable (adjust as needed)

    .text : {
        *(.text)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
    }
}

