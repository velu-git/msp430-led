#Directories
MSPGCC_ROOT_DIR = /home/velu/dev/tools/msp430-gcc
MSPGCC_BIN_DIR = $(MSPGCC_ROOT_DIR)/bin
MSPGCC_INCLUDE_DIR = /home/velu/dev/tools/ccs1250/ccs/ccs_base/msp430/include_gcc
INCLUDE_DIRS = $(MSPGCC_INCLUDE_DIR) \
			   ./src/app \
		       ./external/ \
			   ./

LIB_DIRS = $(MSPGCC_INCLUDE_DIR)
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin

# Toolchain
CC = $(MSPGCC_ROOT_DIR)/bin/msp430-elf-gcc
RM = rm
CPPCHECK = cppcheck
CLANG_FORMATTER = clang-format-12
# Files
TARGET = $(BIN_DIR)/blink
MCU = msp430g2553

SOURCES_WITH_HEADERS = \
			src/app/led.c \
			external/printf/printf.c \

MAIN_FILE = src/main.c
SOURCES = \
			$(MAIN_FILE) \
		  	$(SOURCES_WITH_HEADERS)

HEADERS = \
			$(SOURCES_WITH_HEADERS:.c=.h) \

OBJECT_NAMES = $(SOURCES:.c=.o)
OBJECTS = $(patsubst %,$(OBJ_DIR)/%,$(OBJECT_NAMES))

# Static Analysis
## Don't check the msp430 helper headers (they have a LOT of ifdefs)
CPPCHECK_INCLUDES = ./src/app ./src ./
IGNORE_FILES_FORMAT_CPPCHECK = \
	external/printf/printf.h \
	external/printf/printf.c
SOURCES_FORMAT_CPPCHECK = $(filter-out $(IGNORE_FILES_FORMAT_CPPCHECK),$(SOURCES))
HEADERS_FORMAT = $(filter-out $(IGNORE_FILES_FORMAT_CPPCHECK),$(HEADERS))
CPPCHECK_FLAGS = \
	--quiet --enable=all --error-exitcode=1 \
	--inline-suppr \
	--suppress=missingIncludeSystem \
	--suppress=unmatchedSuppression \
	$(addprefix -I,$(CPPCHECK_INCLUDES)) \


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

.PHONY: all clean cppcheck format

all: format cppcheck $(TARGET)

clean:

	$(RM) -rf $(BUILD_DIR)/*

cppcheck:
	$(CPPCHECK) $(CPPCHECK_FLAGS) $(SOURCES_FORMAT_CPPCHECK)


format:
	$(CLANG_FORMATTER) -i $(SOURCES)
