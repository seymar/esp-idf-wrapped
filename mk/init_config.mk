### Process config
$(if $Q,,$(info mk/config.mk:))

### Install example config if no config exists
include config.mk
config.mk: config.example.mk; cp $< $@

## Process common dependencies path, make absolute and strip trailing slash
CDP = $(COMMON_DEPS_PATH)
CDP := $(abspath $(CDP))
CDP := $(CDP:%/=%)
