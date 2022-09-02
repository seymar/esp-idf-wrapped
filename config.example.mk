### Environment configuration

## Where to install common dependencies and tools?
## Installed dependencies and tools can be used by other projects to save space.
## `make install` will them if not otherwise configured in their config section.
COMMON_DEPS_PATH := $(HOME)/dev/common

## List of installed dependencies and tools:
##     esp-idf-<version>
##     esp-idf-<version>-tools

## esp-idf
IDF_PATH       = $(COMMON_DEPS_PATH)/esp-idf-4.4.1
IDF_TOOLS_PATH = $(COMMON_DEPS_PATH)/esp-idf-4.4.1-tools

APP := hello
PORT ?= 
