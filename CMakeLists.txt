cmake_minimum_required(VERSION 3.10)
project(feroOS)

# Variables
set(ARCH "i686-elf" CACHE STRING "Target architecture")
set(MODE "debug" CACHE STRING "Build mode (debug or release)")

set(TOOLCHAIN_HAS_NEWLIB ON CACHE BOOL "True if toolchain supports newlib")

# Directories
set(BUILD_DIR "${CMAKE_BINARY_DIR}/build")
set(BOOT_DIR "${CMAKE_SOURCE_DIR}/boot/arch/x86_32/")
set(KERNEL_DIR "${CMAKE_SOURCE_DIR}/kernel")
set(LINKER_DIR "${CMAKE_SOURCE_DIR}/linker")

# Compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99 -ffreestanding -O2 -Wall -Wextra")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -O2")

# Include directories
include_directories(${CMAKE_SOURCE_DIR}/usr/include)  # Adjust to your include directory path
include_directories(${CMAKE_SOURCE_DIR}/opt/cross)  # Adjust to your include directory path

file(MAKE_DIRECTORY ${BUILD_DIR}/isodir/boot/grub)

# Step 1: Assemble boot.s
add_custom_command(
    OUTPUT ${BUILD_DIR}/boot.o
    COMMAND ${ARCH}-as ${BOOT_DIR}/boot.S -o ${BUILD_DIR}/boot.o
    DEPENDS ${BOOT_DIR}/boot.S
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Assembling ${ARCH} boot.S"
)

# Step 2: Compile kernel.c
add_custom_command(
    OUTPUT ${BUILD_DIR}/kernel.o
    COMMAND ${ARCH}-gcc -c ${KERNEL_DIR}/kernel.c -o ${BUILD_DIR}/kernel.o ${CMAKE_C_FLAGS}
    DEPENDS ${KERNEL_DIR}/kernel.c
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Compiling kernel.c"
)

# Step 3: Link boot.o and kernel.o into myos.bin using linker.ld
add_custom_command(
    OUTPUT ${BUILD_DIR}/myos.bin
    COMMAND ${ARCH}-gcc -T ${LINKER_DIR}/x86_32.ld -o ${BUILD_DIR}/myos.bin ${BUILD_DIR}/boot.o ${BUILD_DIR}/kernel.o -ffreestanding -O2 -nostdlib -lgcc
    DEPENDS ${BUILD_DIR}/boot.o ${BUILD_DIR}/kernel.o ${LINKER_DIR}/x86_32.ld
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Linking ${ARCH} myos.bin"
)

# Step 4: Create ISO image
add_custom_command(
    OUTPUT ${BUILD_DIR}/myos.iso
    COMMAND cp ${BUILD_DIR}/myos.bin ${BUILD_DIR}/isodir/boot/myos.bin
    COMMAND cp ${CMAKE_SOURCE_DIR}/grub.cfg ${BUILD_DIR}/isodir/boot/grub/grub.cfg
    COMMAND grub-mkrescue -o ${BUILD_DIR}/myos.iso ${BUILD_DIR}/isodir
    DEPENDS ${BUILD_DIR}/myos.bin ${CMAKE_SOURCE_DIR}/grub.cfg
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Creating ISO image"
)

# Add custom target for building myos.iso
add_custom_target(
    myos_iso ALL
    DEPENDS ${BUILD_DIR}/myos.iso
)

# Print build configuration
message(STATUS "Architecture: ${ARCH}")
message(STATUS "Build mode: ${MODE}")

# Set output directories for built targets
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BUILD_DIR})

