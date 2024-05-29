# Iniciando no ESP32 (no Terminal)

1. No terminal digitar:

```bash
. $HOME/esp/esp-idf/export.sh
```

Ou:

```bash
. $HOME/esp/esp-idf/export.fish     
```

Deve aparecer algo como:

```bash
fernandopassold@MacBook-Pro-de-Fernando ~/esp [127]>  . $HOME/esp/esp-idf/export.fish         
Setting IDF_PATH to '/Users/fernandopassold/esp/esp-idf'
Detecting the Python interpreter
Checking "python3" ...
Python 3.11.7
python3 has been detected
Checking Python compatibility
Checking other ESP-IDF version.
Adding ESP-IDF tools to PATH...
Checking if Python packages are up to date...
Constraint file: /Users/fernandopassold/.espressif/espidf.constraints.v5.4.txt
Requirement files:
 - /Users/fernandopassold/esp/esp-idf/tools/requirements/requirements.core.txt
Python being checked: /Users/fernandopassold/.espressif/python_env/idf5.4_py3.11_env/bin/python
Python requirements are satisfied.
Added the following directories to PATH:
/Users/fernandopassold/esp/esp-idf/components/espcoredump
/Users/fernandopassold/esp/esp-idf/components/partition_table
/Users/fernandopassold/esp/esp-idf/components/app_update
/Users/fernandopassold/.espressif/tools/xtensa-esp-elf-gdb/14.2_20240403/xtensa-esp-elf-gdb/bin
/Users/fernandopassold/.espressif/tools/riscv32-esp-elf-gdb/14.2_20240403/riscv32-esp-elf-gdb/bin
/Users/fernandopassold/.espressif/tools/xtensa-esp-elf/esp-13.2.0_20240305/xtensa-esp-elf/bin
/Users/fernandopassold/.espressif/tools/riscv32-esp-elf/esp-13.2.0_20240305/riscv32-esp-elf/bin
/Users/fernandopassold/.espressif/tools/esp32ulp-elf/2.38_20240113/esp32ulp-elf/bin
/Users/fernandopassold/.espressif/tools/openocd-esp32/v0.12.0-esp32-20240318/openocd-esp32/bin
/Users/fernandopassold/.espressif/tools/xtensa-esp-elf-gdb/14.2_20240403/xtensa-esp-elf-gdb/bin
/Users/fernandopassold/.espressif/tools/riscv32-esp-elf-gdb/14.2_20240403/riscv32-esp-elf-gdb/bin
/Users/fernandopassold/.espressif/tools/xtensa-esp-elf/esp-13.2.0_20240305/xtensa-esp-elf/bin
/Users/fernandopassold/.espressif/tools/riscv32-esp-elf/esp-13.2.0_20240305/riscv32-esp-elf/bin
/Users/fernandopassold/.espressif/tools/esp32ulp-elf/2.38_20240113/esp32ulp-elf/bin
/Users/fernandopassold/.espressif/tools/openocd-esp32/v0.12.0-esp32-20240318/openocd-esp32/bin
/Users/fernandopassold/.espressif/python_env/idf5.4_py3.11_env/bin
/Users/fernandopassold/esp/esp-idf/tools
Done! You can now compile ESP-IDF projects.
Go to the project directory and run:

  idf.py build

fernandopassold@MacBook-Pro-de-Fernando ~/esp>                                               
```

Podemos lista as bibliotecas de compilação disponíveis na sua instalação:

```bash
fernandopassold@MacBook-Pro-de-Fernando ~/esp> idf.py --list-targets                         
esp32
esp32s2
esp32c3
esp32s3
esp32c2
esp32c6
esp32h2
esp32p4
fernandopassold@MacBook-Pro-de-Fernando ~/esp>
```

2. Compilando projeto para placa ESP32:

Neste caso, vamos usar a biblioteca tradicional "esp32".

Mas antes, devemos navegar até uma pasta contendo algum exemplo válido, por exemplo:

```bash
fernandopassold@MacBook-Pro-de-Fernando ~/esp [2]> cd /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world         (base) 
fernandopassold@MacBook-Pro-de-Fernando ~/e/e/e/g/hello_world (master)>
```

Momento de conectar a placa ESP32 no seu computador.

3. Agora sim podemos indicar como devem ser compilados os códigos referentes à este projeto:

```bash
idf.py set-target esp32
```

Neste caso:

```bash
fernandopassold@MacBook-Pro-de-Fernando ~/e/e/e/g/hello_world (master)> idf.py set-target esp32
Adding "set-target"'s dependency "fullclean" to list of commands with default set of options.
Executing action: fullclean
Build directory '/Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world/build' not found. Nothing to clean.
Executing action: set-target
Set Target to: esp32, new sdkconfig will be created.
Running cmake in directory /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world/build
Executing "cmake -G Ninja -DPYTHON_DEPS_CHECKED=1 -DPYTHON=/Users/fernandopassold/.espressif/python_env/idf5.4_py3.11_env/bin/python -DESP_PLATFORM=1 -DIDF_TARGET=esp32 -DCCACHE_ENABLE=0 /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world"...
-- Found Git: /usr/bin/git (found version "2.39.3 (Apple Git-145)")
-- The C compiler identification is GNU 13.2.0
-- The CXX compiler identification is GNU 13.2.0
-- The ASM compiler identification is GNU
-- Found assembler: /Users/fernandopassold/.espressif/tools/xtensa-esp-elf/esp-13.2.0_20240305/xtensa-esp-elf/bin/xtensa-esp32-elf-gcc
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /Users/fernandopassold/.espressif/tools/xtensa-esp-elf/esp-13.2.0_20240305/xtensa-esp-elf/bin/xtensa-esp32-elf-gcc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /Users/fernandopassold/.espressif/tools/xtensa-esp-elf/esp-13.2.0_20240305/xtensa-esp-elf/bin/xtensa-esp32-elf-g++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Building ESP-IDF components for target esp32
-- Project sdkconfig file /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world/sdkconfig
-- Compiler supported targets: xtensa-esp-elf
-- Found Python3: /Users/fernandopassold/.espressif/python_env/idf5.4_py3.11_env/bin/python (found version "3.11.7") found components: Interpreter
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD - Success
-- Found Threads: TRUE
-- Performing Test C_COMPILER_SUPPORTS_WFORMAT_SIGNEDNESS
-- Performing Test C_COMPILER_SUPPORTS_WFORMAT_SIGNEDNESS - Success
-- App "hello_world" version: v5.4-dev-610-g003f3bb5dc
-- Adding linker script /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world/build/esp-idf/esp_system/ld/memory.ld
-- Adding linker script /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world/build/esp-idf/esp_system/ld/sections.ld.in
-- Adding linker script /Users/fernandopassold/esp/esp-idf/components/esp_rom/esp32/ld/esp32.rom.ld
-- Adding linker script /Users/fernandopassold/esp/esp-idf/components/esp_rom/esp32/ld/esp32.rom.api.ld
-- Adding linker script /Users/fernandopassold/esp/esp-idf/components/esp_rom/esp32/ld/esp32.rom.libgcc.ld
-- Adding linker script /Users/fernandopassold/esp/esp-idf/components/esp_rom/esp32/ld/esp32.rom.newlib-data.ld
-- Adding linker script /Users/fernandopassold/esp/esp-idf/components/esp_rom/esp32/ld/esp32.rom.syscalls.ld
-- Adding linker script /Users/fernandopassold/esp/esp-idf/components/esp_rom/esp32/ld/esp32.rom.newlib-funcs.ld
-- Adding linker script /Users/fernandopassold/esp/esp-idf/components/soc/esp32/ld/esp32.peripherals.ld
-- Components: app_trace app_update bootloader bootloader_support bt cmock console cxx driver efuse esp-tls esp_adc esp_app_format esp_bootloader_format esp_coex esp_common esp_driver_ana_cmpr esp_driver_cam esp_driver_dac esp_driver_gpio esp_driver_gptimer esp_driver_i2c esp_driver_i2s esp_driver_isp esp_driver_jpeg esp_driver_ledc esp_driver_mcpwm esp_driver_parlio esp_driver_pcnt esp_driver_ppa esp_driver_rmt esp_driver_sdio esp_driver_sdm esp_driver_sdmmc esp_driver_sdspi esp_driver_spi esp_driver_tsens esp_driver_uart esp_driver_usb_serial_jtag esp_eth esp_event esp_gdbstub esp_hid esp_http_client esp_http_server esp_https_ota esp_https_server esp_hw_support esp_lcd esp_local_ctrl esp_mm esp_netif esp_netif_stack esp_partition esp_phy esp_pm esp_psram esp_ringbuf esp_rom esp_system esp_timer esp_vfs_console esp_wifi espcoredump esptool_py fatfs freertos hal heap http_parser idf_test ieee802154 json log lwip main mbedtls mqtt newlib nvs_flash nvs_sec_provider openthread partition_table perfmon protobuf-c protocomm pthread sdmmc soc spi_flash spiffs tcp_transport ulp unity usb vfs wear_levelling wifi_provisioning wpa_supplicant xtensa
-- Component paths: /Users/fernandopassold/esp/esp-idf/components/app_trace /Users/fernandopassold/esp/esp-idf/components/app_update /Users/fernandopassold/esp/esp-idf/components/bootloader /Users/fernandopassold/esp/esp-idf/components/bootloader_support /Users/fernandopassold/esp/esp-idf/components/bt /Users/fernandopassold/esp/esp-idf/components/cmock /Users/fernandopassold/esp/esp-idf/components/console /Users/fernandopassold/esp/esp-idf/components/cxx /Users/fernandopassold/esp/esp-idf/components/driver /Users/fernandopassold/esp/esp-idf/components/efuse /Users/fernandopassold/esp/esp-idf/components/esp-tls /Users/fernandopassold/esp/esp-idf/components/esp_adc /Users/fernandopassold/esp/esp-idf/components/esp_app_format /Users/fernandopassold/esp/esp-idf/components/esp_bootloader_format /Users/fernandopassold/esp/esp-idf/components/esp_coex /Users/fernandopassold/esp/esp-idf/components/esp_common /Users/fernandopassold/esp/esp-idf/components/esp_driver_ana_cmpr /Users/fernandopassold/esp/esp-idf/components/esp_driver_cam /Users/fernandopassold/esp/esp-idf/components/esp_driver_dac /Users/fernandopassold/esp/esp-idf/components/esp_driver_gpio /Users/fernandopassold/esp/esp-idf/components/esp_driver_gptimer /Users/fernandopassold/esp/esp-idf/components/esp_driver_i2c /Users/fernandopassold/esp/esp-idf/components/esp_driver_i2s /Users/fernandopassold/esp/esp-idf/components/esp_driver_isp /Users/fernandopassold/esp/esp-idf/components/esp_driver_jpeg /Users/fernandopassold/esp/esp-idf/components/esp_driver_ledc /Users/fernandopassold/esp/esp-idf/components/esp_driver_mcpwm /Users/fernandopassold/esp/esp-idf/components/esp_driver_parlio /Users/fernandopassold/esp/esp-idf/components/esp_driver_pcnt /Users/fernandopassold/esp/esp-idf/components/esp_driver_ppa /Users/fernandopassold/esp/esp-idf/components/esp_driver_rmt /Users/fernandopassold/esp/esp-idf/components/esp_driver_sdio /Users/fernandopassold/esp/esp-idf/components/esp_driver_sdm /Users/fernandopassold/esp/esp-idf/components/esp_driver_sdmmc /Users/fernandopassold/esp/esp-idf/components/esp_driver_sdspi /Users/fernandopassold/esp/esp-idf/components/esp_driver_spi /Users/fernandopassold/esp/esp-idf/components/esp_driver_tsens /Users/fernandopassold/esp/esp-idf/components/esp_driver_uart /Users/fernandopassold/esp/esp-idf/components/esp_driver_usb_serial_jtag /Users/fernandopassold/esp/esp-idf/components/esp_eth /Users/fernandopassold/esp/esp-idf/components/esp_event /Users/fernandopassold/esp/esp-idf/components/esp_gdbstub /Users/fernandopassold/esp/esp-idf/components/esp_hid /Users/fernandopassold/esp/esp-idf/components/esp_http_client /Users/fernandopassold/esp/esp-idf/components/esp_http_server /Users/fernandopassold/esp/esp-idf/components/esp_https_ota /Users/fernandopassold/esp/esp-idf/components/esp_https_server /Users/fernandopassold/esp/esp-idf/components/esp_hw_support /Users/fernandopassold/esp/esp-idf/components/esp_lcd /Users/fernandopassold/esp/esp-idf/components/esp_local_ctrl /Users/fernandopassold/esp/esp-idf/components/esp_mm /Users/fernandopassold/esp/esp-idf/components/esp_netif /Users/fernandopassold/esp/esp-idf/components/esp_netif_stack /Users/fernandopassold/esp/esp-idf/components/esp_partition /Users/fernandopassold/esp/esp-idf/components/esp_phy /Users/fernandopassold/esp/esp-idf/components/esp_pm /Users/fernandopassold/esp/esp-idf/components/esp_psram /Users/fernandopassold/esp/esp-idf/components/esp_ringbuf /Users/fernandopassold/esp/esp-idf/components/esp_rom /Users/fernandopassold/esp/esp-idf/components/esp_system /Users/fernandopassold/esp/esp-idf/components/esp_timer /Users/fernandopassold/esp/esp-idf/components/esp_vfs_console /Users/fernandopassold/esp/esp-idf/components/esp_wifi /Users/fernandopassold/esp/esp-idf/components/espcoredump /Users/fernandopassold/esp/esp-idf/components/esptool_py /Users/fernandopassold/esp/esp-idf/components/fatfs /Users/fernandopassold/esp/esp-idf/components/freertos /Users/fernandopassold/esp/esp-idf/components/hal /Users/fernandopassold/esp/esp-idf/components/heap /Users/fernandopassold/esp/esp-idf/components/http_parser /Users/fernandopassold/esp/esp-idf/components/idf_test /Users/fernandopassold/esp/esp-idf/components/ieee802154 /Users/fernandopassold/esp/esp-idf/components/json /Users/fernandopassold/esp/esp-idf/components/log /Users/fernandopassold/esp/esp-idf/components/lwip /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world/main /Users/fernandopassold/esp/esp-idf/components/mbedtls /Users/fernandopassold/esp/esp-idf/components/mqtt /Users/fernandopassold/esp/esp-idf/components/newlib /Users/fernandopassold/esp/esp-idf/components/nvs_flash /Users/fernandopassold/esp/esp-idf/components/nvs_sec_provider /Users/fernandopassold/esp/esp-idf/components/openthread /Users/fernandopassold/esp/esp-idf/components/partition_table /Users/fernandopassold/esp/esp-idf/components/perfmon /Users/fernandopassold/esp/esp-idf/components/protobuf-c /Users/fernandopassold/esp/esp-idf/components/protocomm /Users/fernandopassold/esp/esp-idf/components/pthread /Users/fernandopassold/esp/esp-idf/components/sdmmc /Users/fernandopassold/esp/esp-idf/components/soc /Users/fernandopassold/esp/esp-idf/components/spi_flash /Users/fernandopassold/esp/esp-idf/components/spiffs /Users/fernandopassold/esp/esp-idf/components/tcp_transport /Users/fernandopassold/esp/esp-idf/components/ulp /Users/fernandopassold/esp/esp-idf/components/unity /Users/fernandopassold/esp/esp-idf/components/usb /Users/fernandopassold/esp/esp-idf/components/vfs /Users/fernandopassold/esp/esp-idf/components/wear_levelling /Users/fernandopassold/esp/esp-idf/components/wifi_provisioning /Users/fernandopassold/esp/esp-idf/components/wpa_supplicant /Users/fernandopassold/esp/esp-idf/components/xtensa
-- Configuring done (7.9s)
-- Generating done (0.9s)
-- Build files have been written to: /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world/build
fernandopassold@MacBook-Pro-de-Fernando ~/e/e/e/g/hello_world (master)>
```

Este projeto fazia parte dos exemplos vinculados com a instalação padrão das bibliotecas para uso de placas ESP32.

Mas eventualmente se faz necessário **configurar o projeto**. Para tanto ver: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/kconfig.html

4. Para **compilar e transferir** o código, faça:

```bash
idf.py build flash monitor
```

ou simplesmente:

```bash
idf.py flash monitor
```

Neste último caso, um monitor serial já é ativado. Para sair do mesmo, usar a combinação de teclas: `CTRL`+ `]`.

Neste caso:

```bash
fernandopassold@MacBook-Pro-de-Fernando ~/e/e/e/g/hello_world (master)> idf.py build flash   
Executing action: all (aliases: build)
Running ninja in directory /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world/build
Executing "ninja all"...
[4/972] Generating ../../partition_table/partition-table.bin
Partition table binary generated. Contents:
*******************************************************************************
# ESP-IDF Partition Table
# Name, Type, SubType, Offset, Size, Flags
nvs,data,nvs,0x9000,24K,
phy_init,data,phy,0xf000,4K,
factory,app,factory,0x10000,1M,
*******************************************************************************
[863/972] Building CXX object esp-idf ...
...
Executing "ninja flash"...
[1/5] cd /Users/fernandopassold/esp/esp-idf/examples/get-started/he.../esp/esp-idf/examples/get-started/hello_world/build/hello_world.bi
hello_world.bin binary size 0x2b0f0 bytes. Smallest app partition is 0x100000 bytes. 0xd4f10 bytes (83%) free.
[1/1] cd /Users/fernandopassold/esp/esp-idf/examples/get-started/he...df/examples/get-started/hello_world/build/bootloader/bootloader.bi
Bootloader binary size 0x6880 bytes. 0x780 bytes (7%) free.
[4/5] cd /Users/fernandopassold/esp/esp-idf/components/esptool_py &...andopassold/esp/esp-idf/components/esptool_py/run_serial_tool.cmak
esptool.py --chip esp32 -p /dev/cu.usbserial-0001 -b 460800 --before=default_reset --after=hard_reset write_flash --flash_mode dio --flash_freq 40m --flash_size 2MB 0x1000 bootloader/bootloader.bin 0x10000 hello_world.bin 0x8000 partition_table/partition-table.bin
esptool.py v4.8.dev3
Serial port /dev/cu.usbserial-0001
Connecting....
Chip is ESP32-D0WD-V3 (revision v3.1)
Features: WiFi, BT, Dual Core, 240MHz, VRef calibration in efuse, Coding Scheme None
Crystal is 40MHz
MAC: 48:e7:29:b6:cd:b4
Uploading stub...
Running stub...
Stub running...
Changing baud rate to 460800
Changed.
Configuring flash size...
Flash will be erased from 0x00001000 to 0x00007fff...
Flash will be erased from 0x00010000 to 0x0003bfff...
Flash will be erased from 0x00008000 to 0x00008fff...
SHA digest in image updated
Compressed 26752 bytes to 16377...
Writing at 0x00001000... (100 %)
Wrote 26752 bytes (16377 compressed) at 0x00001000 in 0.8 seconds (effective 261.8 kbit/s)...
Hash of data verified.
Compressed 176368 bytes to 94294...
Writing at 0x000361c3... (100 %)
Wrote 176368 bytes (94294 compressed) at 0x00010000 in 2.8 seconds (effective 512.8 kbit/s)...
Hash of data verified.
Compressed 3072 bytes to 103...
Writing at 0x00008000... (100 %)
Wrote 3072 bytes (103 compressed) at 0x00008000 in 0.1 seconds (effective 359.4 kbit/s)...
Hash of data verified.

Leaving...
Hard resetting via RTS pin...
Done
fernandopassold@MacBook-Pro-de-Fernando ~/e/e/e/g/hello_world (master)>       
```

5. E para executar:

```bash
fernandopassold@MacBook-Pro-de-Fernando ~/e/e/e/g/hello_world (master)> idf.py monitor 
Executing action: monitor
Serial port /dev/cu.usbserial-0001
Connecting...............
Detecting chip type... Unsupported detection protocol, switching and trying again...
Connecting.....
Detecting chip type... ESP32
Running idf_monitor in directory /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world
Executing "/Users/fernandopassold/.espressif/python_env/idf5.4_py3.11_env/bin/python /Users/fernandopassold/esp/esp-idf/tools/idf_monitor.py -p /dev/cu.usbserial-0001 -b 115200 --toolchain-prefix xtensa-esp32-elf- --target esp32 --revision 0 /Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world/build/hello_world.elf -m '/Users/fernandopassold/.espressif/python_env/idf5.4_py3.11_env/bin/python' '/Users/fernandopassold/esp/esp-idf/tools/idf.py'"...
--- esp-idf-monitor 1.4.0 on /dev/cu.usbserial-0001 115200 ---
--- Quit: Ctrl+] | Menu: Ctrl+T | Help: Ctrl+T followed by Ctrl+H ---
ets Jul 29 2019 12:21:46

rst:0x1 (POWERON_RESET),boot:0x13 (SPI_FAST_FLASH_BOOT)
configsip: 0, SPIWP:0xee
clk_drv:0x00,q_drv:0x00,d_drv:0x00,cs0_drv:0x00,hd_drv:0x00,wp_drv:0x00
mode:DIO, clock div:2
load:0x3fff0030,len:7176
load:0x40078000,len:15564
ho 0 tail 12 room 4
load:0x40080400,len:4
0x40080400: _init at ??:?

load:0x40080404,len:3904
entry 0x40080640
I (31) boot: ESP-IDF v5.4-dev-610-g003f3bb5dc-dirty 2nd stage bootloader
I (31) boot: compile time May 29 2024 18:05:57
I (33) boot: Multicore bootloader
I (37) boot: chip revision: v3.1
I (41) boot.esp32: SPI Speed      : 40MHz
I (46) boot.esp32: SPI Mode       : DIO
I (50) boot.esp32: SPI Flash Size : 2MB
I (55) boot: Enabling RNG early entropy source...
I (60) boot: Partition Table:
I (64) boot: ## Label            Usage          Type ST Offset   Length
I (71) boot:  0 nvs              WiFi data        01 02 00009000 00006000
I (79) boot:  1 phy_init         RF data          01 01 0000f000 00001000
I (86) boot:  2 factory          factory app      00 00 00010000 00100000
I (94) boot: End of partition table
I (98) esp_image: segment 0: paddr=00010020 vaddr=3f400020 size=093d0h ( 37840) map
I (119) esp_image: segment 1: paddr=000193f8 vaddr=3ffb0000 size=02200h (  8704) load
I (123) esp_image: segment 2: paddr=0001b600 vaddr=40080000 size=04a18h ( 18968) load
I (133) esp_image: segment 3: paddr=00020020 vaddr=400d0020 size=138c8h ( 80072) map
I (161) esp_image: segment 4: paddr=000338f0 vaddr=40084a18 size=077dch ( 30684) load
I (180) boot: Loaded app from partition at offset 0x10000
I (180) boot: Disabling RNG early entropy source...
I (192) cpu_start: Multicore app
I (200) cpu_start: Pro cpu start user code
I (200) cpu_start: cpu freq: 160000000 Hz
I (200) app_init: Application information:
I (203) app_init: Project name:     hello_world
I (208) app_init: App version:      v5.4-dev-610-g003f3bb5dc
I (215) app_init: Compile time:     May 29 2024 18:05:36
I (221) app_init: ELF file SHA256:  e153100e4...
I (226) app_init: ESP-IDF:          v5.4-dev-610-g003f3bb5dc
I (232) efuse_init: Min chip rev:     v0.0
I (237) efuse_init: Max chip rev:     v3.99 
I (242) efuse_init: Chip rev:         v3.1
I (247) heap_init: Initializing. RAM available for dynamic allocation:
I (254) heap_init: At 3FFAE6E0 len 00001920 (6 KiB): DRAM
I (260) heap_init: At 3FFB2AC8 len 0002D538 (181 KiB): DRAM
I (266) heap_init: At 3FFE0440 len 00003AE0 (14 KiB): D/IRAM
I (273) heap_init: At 3FFE4350 len 0001BCB0 (111 KiB): D/IRAM
I (279) heap_init: At 4008C1F4 len 00013E0C (79 KiB): IRAM
I (287) spi_flash: detected chip: generic
I (290) spi_flash: flash io: dio
W (294) spi_flash: Detected size(4096k) larger than the size in the binary image header(2048k). Using the size in the binary image header.
I (308) main_task: Started on CPU0
I (318) main_task: Calling app_main()
Hello world!
This is esp32 chip with 2 CPU core(s), WiFi/BTBLE, silicon revision v3.1, 2MB external flash
Minimum free heap size: 305360 bytes
Restarting in 10 seconds...
Restarting in 9 seconds...
Restarting in 8 seconds...
Restarting in 7 seconds...
Restarting in 6 seconds...
Restarting in 5 seconds...
Restarting in 4 seconds...
Restarting in 3 seconds...
Restarting in 2 seconds...

fernandopassold@MacBook-Pro-de-Fernando ~/e/e/e/g/hello_world (master)> 
```

6. Para sair do modo monitor você pode digitar a seguinte combinação de teclas:

* **Quit**: `Ctrl`+ `]` 
* **Menu**: `Ctrl`+ `T` 
* **Help**: `Ctrl`+ `T` seguido de: `Ctrl`+ `H`.

---

## Código exemplo:

Verificando o código de : `/Users/fernandopassold/esp/esp-idf/examples/get-started/hello_world/main/hello_world_main.c:`

```c++
/*
 * SPDX-FileCopyrightText: 2010-2022 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: CC0-1.0
 */

#include <stdio.h>
#include <inttypes.h>
#include "sdkconfig.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_chip_info.h"
#include "esp_flash.h"
#include "esp_system.h"

void app_main(void)
{
    printf("Hello world!\n");

    /* Print chip information */
    esp_chip_info_t chip_info;
    uint32_t flash_size;
    esp_chip_info(&chip_info);
    printf("This is %s chip with %d CPU core(s), %s%s%s%s, ",
           CONFIG_IDF_TARGET,
           chip_info.cores,
           (chip_info.features & CHIP_FEATURE_WIFI_BGN) ? "WiFi/" : "",
           (chip_info.features & CHIP_FEATURE_BT) ? "BT" : "",
           (chip_info.features & CHIP_FEATURE_BLE) ? "BLE" : "",
           (chip_info.features & CHIP_FEATURE_IEEE802154) ? ", 802.15.4 (Zigbee/Thread)" : "");

    unsigned major_rev = chip_info.revision / 100;
    unsigned minor_rev = chip_info.revision % 100;
    printf("silicon revision v%d.%d, ", major_rev, minor_rev);
    if(esp_flash_get_size(NULL, &flash_size) != ESP_OK) {
        printf("Get flash size failed");
        return;
    }

    printf("%" PRIu32 "MB %s flash\n", flash_size / (uint32_t)(1024 * 1024),
           (chip_info.features & CHIP_FEATURE_EMB_FLASH) ? "embedded" : "external");

    printf("Minimum free heap size: %" PRIu32 " bytes\n", esp_get_minimum_free_heap_size());

    for (int i = 10; i >= 0; i--) {
        printf("Restarting in %d seconds...\n", i);
        vTaskDelay(1000 / portTICK_PERIOD_MS);
    }
    printf("Restarting now.\n");
    fflush(stdout);
    esp_restart();
}

```

Notamos que este código já usa facilidades do **FreeRTOS**.

Fim

---



<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("Fernando Passold, atualizado em " + LastUpdated); // End Hiding -->
</script>

