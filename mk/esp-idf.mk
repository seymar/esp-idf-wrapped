### ESP-IDF installation

## Configuration variable defaults
IDF_VERSION	   ?= v4.4.1
IDF_PATH       ?= $(COMMON_DEPS_PATH)/esp-idf-$(IDF_VERSION)
IDF_TOOLS_PATH ?= $(COMMON_DEPS_PATH)/esp-idf-$(IDF_VERSION)-tools

$(if $Q,,$(info IDF_PATH = $(IDF_PATH)))
$(if $Q,,$(info IDF_TOOLS_PATH = $(IDF_TOOLS_PATH)))

## Only check installation when not installing
ifneq ($(MAKECMDGOALS),install)

## Check configuration variables
$(if $(wildcard $(IDF_PATH)),, \
	$(error IDF_PATH directory not found $(IDF_PATH)))

$(if $(wildcard $(IDF_TOOLS_PATH)),, \
	$(error IDF_TOOLS_PATH directory not found not found: $(IDF_TOOLS_PATH)))

endif

## Installation rules
ESP_IDF_ZIP ?= https://dl.espressif.com/github_assets/espressif/esp-idf/releases/download/v4.4.1/esp-idf-v4.4.1.zip
ESP_IDF_ZIP_DST := $(COMMON_DEPS_PATH)/esp-idf-$(IDF_VERSION).zip
.PHONY: esp-idf
.NOTPARALLEL:
esp-idf: $(IDF_PATH) esp-idf-tools
$(IDF_PATH): $(ESP_IDF_ZIP_DST)
	unzip -n $< -d $(COMMON_DEPS_PATH)
$(ESP_IDF_ZIP_DST):
	wget $(ESP_IDF_ZIP) -P $(@D)

# Export for ./install.sh
export IDF_PATH
export IDF_TOOLS_PATH
.PHONY:
esp-idf-tools: $(IDF_TOOLS_PATH)

$(IDF_TOOLS_PATH):
	(cd $(IDF_PATH) && . ./install.sh esp32)

# Add ESP-IDF to the install target
install: esp-idf

# Export paths for command targets
IDF_PY := $(IDF_PATH)/tools/idf.py
$(info IDF_PY = $(IDF_PY))

# Export tools 
IDF_TOOLS_XTENSA := $(realpath $(IDF_TOOLS_PATH)/tools/xtensa-esp32-elf/esp-2021r2-8.4.0/xtensa-esp32-elf/bin)
$(info IDF_TOOLS_XTENSA = $(IDF_TOOLS_XTENSA))
export PATH := $(IDF_TOOLS_XTENSA):$(PATH)


# Set idf.py flags through environment variables
export IDF_CCACHE_ENABLE := 1
export ESPPORT := $(PORT)
export ESPBAUD := 2000000
