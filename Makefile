#Directories
MSPGCC_ROOT_DIR = /home/velu/dev/tools/msp430-gcc
MSPGCC_BIN_DIR = $(MSPGCC_ROOT_DIR)/bin
MSPGCC_INCLUDE_DIR = /home/velu/dev/tools/ccs1250/ccs/ccs_base/msp430/include_gcc
INCLUDE_DIRS = $(MSPGCC_INCLUDE_DIR)
LIB_DIRS = $(MSPGCC_INCLUDE_DIR)


# Toolchain
CC = $(MSPGCC_ROOT_DIR)/bin/msp430-elf-gcc

# Files
TARGET = blink
MCU = msp430g2553
WFLAGS = -Wall -Wextra -Werror -Wshadow
CFLAGS = $(WFLAGS)
LDFLAGS = -mmcu=$(MCU)


# Build
blink: main.c led.c
	$(CC) -mmcu=msp430g2553 \
    -I $(INCLUDE_DIRS) \
    -L $(LIB_DIRS) \
    -Og -g -Wall \
    led.c main.c -o blink
	
