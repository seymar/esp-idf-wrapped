### ESP-IDF installation

## Configuration variable defaults
IDF_PATH       ?= $(CDP)/esp-idf-4.4
IDF_TOOLS_PATH ?= $(CDP)/esp-idf-4.4-tools

$(if $Q,,$(info IDF_PATH = $(IDF_PATH)))
$(if $Q,,$(info IDF_TOOLS_PATH = $(IDF_TOOLS_PATH)))

## Check configuration variables
$(if $(wildcard $(IDF_PATH)/.git),, \
	$(error IDF_PATH not found))

$(if $(wildcard $(IDF_TOOLS_PATH)/idf-env.json),, \
	$(error IDF_PATH '$(IDF_TOOLS_PATH)/idf-env.json' not found))

## Export configuration variables
export IDF_PATH
export IDF_TOOLS_PATH

## Installation rules
.PHONY: esp-idf-4.4                                                              
.NOTPARALLEL:                                                                    
esp-idf-4.4: $(IDF_PATH)/.git esp-idf-4.4-tools
$(IDF_PATH)/.git:                                                                
	git clone -b v4.4 --recursive https://github.com/espressif/esp-idf.git $@
                                                                                 
.PHONY:                                                                          
esp-idf-4.4-tools: $(CDP)esp-idf-4.4-tools/idf-env.json                                
$(CDP)esp-idf-4.4-tools/idf-env.json: $(IDF_PATH)/.git
	(cd $(IDF_PATH) && . ./install.sh esp32)               


# Add ESP-IDF to the install target
install: esp-idf-4.4                                                                 

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
