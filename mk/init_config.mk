### Process config
$(if $Q,,$(info mk/config.mk:))

### Install example config if no config exists
include config.mk
config.mk: config.example.mk; cp $< $@


## Process common dependencies path, make absolute and strip trailing slash
COMMON_DEPS_PATH := $(abspath $(COMMON_DEPS_PATH))
COMMON_DEPS_PATH := $(COMMON_DEPS_PATH:%/=%)

$(if $(wildcard $(COMMON_DEPS_PATH)),, \
	$(error COMMON_DEPS_PATH not found $(COMMON_DEPS_PATH)))
