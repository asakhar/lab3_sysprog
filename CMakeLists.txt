cmake_minimum_required(VERSION 3.12)

project(lab6)
enable_language(CXX ASM_NASM)
set(CMAKE_ASM_NASM_LINK_EXECUTABLE "ld <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)

add_executable(main main.cpp main.asm)