.section .text
.globl _start
_start:
    # Set up stack pointer
    la sp, stack_top

    # Call kernel entry point
    jal kernel_entry

hang:
    # Wait for interrupt
    wfi
    j hang

.section .bss
.align 4
stack:
    .skip 4096
stack_top:
