#Directories
MSPGCC_ROOT_DIR = /home/velu/dev/tools/msp430-gcc
MSPGCC_BIN_DIR = $(MSPGCC_ROOT_DIR)/bin
MSPGCC_INCLUDE_DIR = /home/velu/dev/tools/ccs1250/ccs/ccs_base/msp430/include_gcc
INCLUDE_DIRS = $(MSPGCC_INCLUDE_DIR) \
			   ./src/app \
		       ./eternal/ \
			   ./

LIB_DIRS = $(MSPGCC_INCLUDE_DIR)
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin

# Toolchain
CC = $(MSPGCC_ROOT_DIR)/bin/msp430-elf-gcc

# Files
TARGET = $(BIN_DIR)/blink
MCU = msp430g2553

SOURCES_WITH_HEADERS = \
			src/app/led.c \

MAIN_FILE = src/main.c
SOURCES = \
			$(MAIN_FILE) \
		  	$(SOURCES_WITH_HEADERS)

HEADERS = \
			$(SOURCES_WITH_HEADERS:.c=.h) \

OBJECT_NAMES = $(SOURCES:.c=.o)
OBJECTS = $(patsubst %,$(OBJ_DIR)/%,$(OBJECT_NAMES))

# Flags
WFLAGS = -Wall -Wextra -Werror -Wshadow
CFLAGS = -mmcu=$(MCU) $(WFLAGS) $(addprefix -I, $(INCLUDE_DIRS)) -Og -g
LDFLAGS = -mmcu=$(MCU) $(addprefix -L,$(LIB_DIRS))


# Build
$(TARGET): $(OBJECTS) $(HEADERS)
	mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) $^ -o $@


## Compiling
$(OBJ_DIR)/%.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $^


# Phonies

.PHONY: all clean

all: $(TARGET)

clean:

	$(RM) -rf $(BUILD_DIR)/*
