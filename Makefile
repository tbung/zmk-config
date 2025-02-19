BASE_DIR := ${HOME}/Projects
ZMK_DIR := ${BASE_DIR}/zmk
ZMK_CONFIG_DIR := ${BASE_DIR}/zmk-config
BUILD_DIR := $(ZMK_CONFIG_DIR)/build

$(info ZMK_DIR: ${ZMK_DIR})
$(info BUILD_DIR: ${BUILD_DIR})

.PHONY: all
all: $(BUILD_DIR)/splitkb_aurora_sofle_left.uf2 $(BUILD_DIR)/splitkb_aurora_sofle_right.uf2

$(BUILD_DIR)/splitkb_aurora_sofle_%.uf2: config/splitkb_aurora_sofle.conf config/splitkb_aurora_sofle.keymap
	mkdir -p $(BUILD_DIR)/$*
	cd $(ZMK_DIR)/app && \
		west build -d ${BUILD_DIR}/$* -b nice_nano_v2 -- \
		-DSHIELD="splitkb_aurora_sofle_$* nice_view_p8 nice_view_poke" \
		-DZMK_CONFIG=${ZMK_CONFIG_DIR}/config \
		-DZMK_EXTRA_MODULES="${ZMK_CONFIG_DIR};${BASE_DIR}/zmk-adaptive-key" \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=1
	mv $(BUILD_DIR)/$*/zephyr/zmk.uf2 $(BUILD_DIR)/splitkb_aurora_sofle_$*.uf2

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
