### ESP-IDF installation

## Configuration variables
idf_zip          := https://dl.espressif.com/github_assets/espressif/esp-idf/releases/download/v4.4.2/esp-idf-v4.4.2.zip
idf_version      := v4.4.2
IDF_PATH         ?= $(COMMON_DEPS_PATH)/esp-idf-$(idf_version)
IDF_TOOLS_PATH   ?= $(COMMON_DEPS_PATH)/esp-idf-$(idf_version)-tools
IDF_TOOLS_XTENSA ?= $(IDF_TOOLS_PATH)/tools/xtensa-esp32-elf/esp-2021r2-patch3-8.4.0/xtensa-esp32-elf/bin
ESP_PYTHON       := $(IDF_TOOLS_PATH)/python_env/idf4.4_py3.10_env/bin/python
IDF_PY            = $(ESP_PYTHON) $(IDF_PATH)/tools/idf.py
ESP_TARGETS      ?= esp32

$(foreach v,IDF_TOOLS_PATH IDF_TOOLS_XTENSA ESP_PYTHON IDF_PY, \
	$(info $(shell printf "%-16s\n%s" $v $($v))))

## Only check installation when not installing
ifneq ($(MAKECMDGOALS),install)
## Check configuration variables
$(if $(wildcard $(IDF_PATH)),, \
	$(info Path not found: IDF_PATH = $(IDF_PATH)) \
	$(info `make install` to install it) \
	$(error ^))
endif

export IDF_PATH # Configures ./install.sh
export IDF_TOOLS_PATH # Configures ./install.sh 
export IDF_CCACHE_ENABLE := 1 # Export for idf.py
export ESPPORT ?= $(PORT)
export ESPBAUD ?= 2000000
ifeq (,$(findstring $(IDF_TOOLS_XTENSA),$(PATH)))
export PATH := $(IDF_TOOLS_XTENSA):$(PATH)
endif

## Installation rules
install: esp-idf
$(IDF_PATH).zip:
	wget $(idf_zip) -P $(@D)
# Unzip `-n` not overwriting files, -x "*.git/*/" excluding git folders
$(IDF_PATH): $(IDF_PATH).zip
	unzip -n $< -d $(COMMON_DEPS_PATH) -x "*.git/*"
# Install
esp-idf: $(IDF_PATH)
	(cd $(IDF_PATH) && . ./install.sh $(ESP_TARGETS))
	@printf "\033[4A\033[K" # Remove 'export.sh' message
