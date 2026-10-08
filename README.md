# Codium Zephyr SDK

## Building and programming

Sample commands to build and flash opener samples on NR+ gateway / NR+ node, to be executed from opener-samples clone folder.

```bash
# NR+ gateway
west build -b cod_nrp_gw/nrf9151/ns samples/dectnrp-driver -p -- -DEXTRA_DTC_OVERLAY_FILE=boards/nrf9151dk_nrf9151_ns.overlay -DEXTRA_CONF_FILE=boards/nrf9151dk_nrf9151_ns.conf

nrfutil device recover
nrfutil device program --firmware <nr+-modem-firmware.zip>
west flash -d build/cod_nrp_gw/nrf9151/ns/dectnrp-driver

# NR+ node
west build -b cod_nrp_node/nrf9151/ns samples/dectnrp-driver -p -- -DEXTRA_DTC_OVERLAY_FILE=boards/nrf9151dk_nrf9151_ns.overlay -DEXTRA_CONF_FILE=boards/nrf9151dk_nrf9151_ns.conf

nrfutil device recover
nrfutil device program --firmware <nr+-modem-firmware.zip>
west flash -d build/cod_nrp_node/nrf9151/ns/dectnrp-driver
```

## Debug configurations

Debug configs for vscode cortex-debug extension, one is for direct JLink use, second one is when using the openocd server on a Codium Gateway dev board (needs to be adapted for your app / build settings)

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "<app> (launch)",
            "type": "cortex-debug",
            "device": "NRF9151_xxca",
            "executable": "${config:build-folder}/<app>/zephyr/zephyr.elf",
            "loadFiles": [
                "${config:build-folder}/<app>/zephyr/tfm_merged.hex"
            ],
            "cwd": "${workspaceFolder}",
            "rtos": "Zephyr",
            "request": "launch",
            "runToEntryPoint": "main",
            "servertype": "jlink",
            "interface": "swd",
            "serverArgs": [
                "-jlinkscriptfile",
                "${workspaceFolder}/deps/codz-sdk/boards/codium/cod_nrp_gw/support/nrf9151_connect_under_reset.JLinkScript"
            ],
            "gdbPath": "${config:zephyrSdkPath}/arm-zephyr-eabi/bin/arm-zephyr-eabi-gdb",
            "svdPath": "${workspaceFolder}/deps/modules/hal/nordic/nrfx/mdk/nrf9120.svd",
            "showDevDebugOutput": "parsed",
            "rttConfig": {
                "enabled": true,
                "address": "auto",
                "decoders": [
                    {
                        "port": 0,
                        "timestamp": true,
                        "type": "console"
                    }
                ]
            },
        },
        {
            "name": "<app> (remote launch)",
            "type": "cortex-debug",
            "device": "NRF9151_xxca",
            "executable": "${config:build-folder}/cod_nrp_gw/nrf9151/ns/<app>/zephyr/zephyr.elf",
            "loadFiles": [
                "${config:build-folder}/cod_nrp_gw/nrf9151/ns/<app>/zephyr/tfm_merged.hex"
            ],
            "cwd": "${workspaceFolder}",
            "rtos": "Zephyr",
            "request": "launch",
            "runToEntryPoint": "main",
            "servertype": "external",
            "gdbTarget": "<gatewayIp>:3333",
            "gdbPath": "${config:zephyrSdkPath}/arm-zephyr-eabi/bin/arm-zephyr-eabi-gdb",
            "svdPath": "${workspaceFolder}/deps/modules/hal/nordic/nrfx/mdk/nrf9120.svd",
            "preLaunchCommands": [
                "set remotetimeout 1"
            ],
            "showDevDebugOutput": "parsed",
            "rttConfig": { // this automatically opens a rtt viewer terminal
                "enabled": true,
                "address": "auto",
                "decoders": [
                    {
                        "port": 0,
                        "timestamp": true,
                        "type": "console"
                    }
                ]
            },
        },
    ],
}
```
