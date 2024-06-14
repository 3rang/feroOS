# feroOS (Unified OS Project x86_64 & RISC-V)

## Overview

**feroOS** is a minimalistic operating system designed to run on both x86_64 and RISC-V 64-bit architectures. This project, also known as the **Unified OS Project**, aims to serve as an educational resource for understanding the fundamentals of cross-architecture OS development, including basic bootloading, kernel initialization, and simple system calls.

## Features

- Dual architecture support: x86_64 and RISC-V 64-bit.
- Basic bootloader implementation for both architectures.
- Simple kernel to demonstrate printing a welcome message.
- Cross-compilation support using GCC and the RISC-V toolchain.
- Extensible design for adding more OS features in the future.

## Getting Started

### Prerequisites

Ensure you have the required toolchains installed:

- **For x86_64**: `gcc`, `nasm`
- **For RISC-V**: `riscv64-unknown-elf-gcc`

### Building the Project

1. **Clone the repository**:
    ```sh
    git clone https://github.com/3rang/feroOS.git
    cd feroOS
    ```

2. **Build the project**:
    ```sh
    make
    ```

### Running the Binaries

You can use QEMU to run the binaries for both architectures.

- **For x86_64**:
    ```sh
    qemu-system-x86_64 -drive format=raw,file=x86_64.bin
    ```

- **For RISC-V**:
    ```sh
    qemu-system-riscv64 -machine virt -nographic -bios none -kernel riscv.bin
    ```

## Project Structure

- `boot/`: bootcode
- `kernel/`: main kernel code
- `linker/`: linker files
- `Makefile`: Build script for automating the compilation process.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Acknowledgments

Inspired by educational resources on bare-metal programming and cross-architecture development.

---

By providing a minimal and clear setup, this project aims to be a helpful starting point for those interested in low-level system programming and operating system development across different architectures.

