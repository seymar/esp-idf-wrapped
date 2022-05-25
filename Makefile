SHELL=bash
.DEFAULT_GOAL := build

include mk/init_config.mk

APP_PATH ?= apps/$(APP)
APP_PATH := $(abspath $(APP_PATH))

# Include ESP-IDF into the project
include mk/esp-idf.mk

install:

# ESP-IDF: Set current working directory
IDF_PY_FLAGS := $(IDF_PY_FLAGS) -C $(APP_PATH)

# ESP-IDF: Command targets
.PHONY: build
b: build
build:
	$(IDF_PY) $(IDF_PY_FLAGS) build

c: clean
clean:
	$(IDF_PY) $(IDF_PY_FLAGS) clean

fullclean:
	$(IDF_PY) $(IDF_PY_FLAGS) fullclean

f: flash
flash:
	$(IDF_PY) $(IDF_PY_FLAGS) flash

af: flash
aflash:
	$(IDF_PY) $(IDF_PY_FLAGS) app-flash

m: monitor
monitor:
	$(IDF_PY) $(IDF_PY_FLAGS) monitor

menuconfig:
	$(IDF_PY) $(IDF_PY_FLAGS) menuconfig