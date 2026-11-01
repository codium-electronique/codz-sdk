# Copyright (c) 2026 Codium Electronique
# SPDX-License-Identifier: Apache-2.0

if(CONFIG_TFM_FLASH_MERGED_BINARY)
  set_property(TARGET runners_yaml_props_target PROPERTY hex_file tfm_merged.hex)
endif()

set(JLINKSCRIPTFILE ${CMAKE_CURRENT_LIST_DIR}/support/nrf9151_connect_under_reset.JLinkScript)
board_runner_args(jlink "--device=nRF9151_xxCA" "--speed=4000" "--tool-opt=-jlinkscriptfile ${JLINKSCRIPTFILE}")

# Runs on the NR+Gate itself: the gateway's own openocd (libgpiod adapter, not
# in the Zephyr SDK's build) with its site folder, where cod-nrp-gw.cfg drives
# the nRF9151 SWD. No RTT config, the runner only flashes. The two paths are
# those of the NR+Gate image: on another host override them with
# `west flash -r openocd --openocd=<path> --openocd-search=<dir>`.
board_runner_args(openocd --openocd=/usr/bin/openocd --openocd-search=/usr/share/openocd/site --config cod-nrp-gw.cfg)

include(${ZEPHYR_BASE}/boards/common/nrfutil.board.cmake)
include(${ZEPHYR_BASE}/boards/common/nrfjprog.board.cmake)
include(${ZEPHYR_BASE}/boards/common/jlink.board.cmake)
include(${ZEPHYR_BASE}/boards/common/openocd.board.cmake)
