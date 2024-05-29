# Placa ESP32 DEV KIT V1

Pinagem: https://mischianti.org/wp-content/uploads/2020/11/ESP32-DOIT-DEV-KIT-v1-pinout-mischianti.png

![ESP32-DOIT-DEV-KIT-v1-pinout-mischianti](ESP32-DOIT-DEV-KIT-v1-pinout-mischianti.png)

Introdução sobre esta placa (ID:2AC7Z) no site do fabricante [Espressif](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/hw-reference/esp32/user-guide-devkitm-1.html) ou [aqui](https://fcc.report/FCC-ID/2AC7Z-ESP32).

Este fabricante disponibiliza várias versões diferentes de "ESP32":

* Ver: https://products.espressif.com/#/product-comparison

👉 Esta versão parece ser a "id:2AC7Z-ESPWROOM32": https://fcc.report/FCC-ID/2AC7Z-ESPWROOM32/3212970 (de 2016), também chamada de "[**ESP-WROVER-KIT**](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/hw-reference/esp32/get-started-wrover-kit.html)" pelo fabricante Espressif, apesar da versão atual (versão 4.1 ser totalmente diferente e contar com leitor de cartões microSD). Mas também não se trata da versão "[ESP32-DevKitM-1](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/hw-reference/esp32/user-guide-devkitm-1.html)". Não corresponde à nenhuma placa oficial e atual do fabricante, mas é algo similar à **[ESP32-DevKitC](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/hw-reference/esp32/get-started-devkitc.html)** 🤔.

Segue figura com diagrama de blocos funcional:

![ESP32_Function_Block_Diagram](ESP32/ESP32_Function_Block_Diagram.svg)

Alguma **características principais**:

* 2 $\times \; \mu C$ low-power Tensilica 32-bits LX6 (2 cores), clock até 240 MHz, até 600 DMIPS.
* 448 KBytes ROM for boot;
* 530 KBytes on-chip SRAM: data & instructions;
* 8 KBytes SRAM in RTC ("RTC SLOW Memory");
* 8 KBytes SRAM in RTC ("RTC FAST Memory");
* 1 Kbytes EFUSE (256-bits para sistema: MAC address + chip configuration; 768-bits para consumidor).
* Suporta $4 \times 16$ MBytes external QSPI flash SRAM (8 MBytes da SRAM externa mapeados no espaço de dados da CPU, suportando acesso em 8, 16 e 32-bits).
* Consumo máximo (com RF ativo) $\le 260$ mA.
* ⚡ **Atenção**: internamente a placa (e periféricos nela conectados) devem trabalhar à 3,3 Volts ( $2,2 \le VDD \le 3,6$ Volts).

Notamos:

**Conversores D/A** ($2 \times 8-$bits) nos pinos:

* DAC1: pin D25 ou GPIO25.
* DAC2: pin D26 ou GPIO26.

**Conversores A/D** (2 $\times$ 12-bits SAR) nos pinos:

* Com pré-amplificador (ultra baixo ruído), ganho de até 60 dB (para uso com sensores):
  * ADC1_CH0: pin GPIO36 (SENSOR\_VP);	
  * ADC1_CH3: pin GPIO39 (SENSOR\_VN).
* Sem pré:
  * ADC1_outros e ADC2_CH0 ~ ADC2_CH9. 

Possui ainda:

* 1 $\times$ Led 3,3 Volts: mas este led parece que apenas se ativa para indicar que a porta USB está conectada.
* 1 $\times$ botão de Reset;
* 1 $\times$ botão de "Enable" ou "Boot".

Mais características introdutórias ver: http://esp32.net

## Programação

Guia de programação da Espressif: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/

## Software

Ref.: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html

Para começar a usar o ESP-IDF no **ESP32**, instale o seguinte software:

* **Toolchain** (ou *Cadeia de ferramentas*) para compilar código para ESP32;
* **Build tools** (ou *Ferramentas de construção*): CMake e Ninja para criar um **aplicativo** completo para ESP32;
* **ESP-IDF** que contém essencialmente API's (bibliotecas de software e código-fonte) para ESP32 e scripts para operar o **Toolchain**

### Instalação

Para instalar todo o software necessário, oferecemos algumas maneiras diferentes de facilitar essa tarefa. Escolha entre uma das opções disponíveis.

#### IDE

* [Plugin Eclipse](https://github.com/espressif/idf-eclipse-plugin/blob/master/README.md);

* [Extensão VSCode](https://github.com/espressif/vscode-esp-idf-extension/blob/master/docs/tutorial/install.md)  👈  Explorada neste caso. 
  Informações sobre o "ESP-IDF" VSCode Extesion [aqui](https://marketplace.visualstudio.com/items?itemName=espressif.esp-idf-extension).
  Eventualmente será necessário [instalar o Tutorial para exemplos](https://github.com/espressif/vscode-esp-idf-extension/blob/master/docs/tutorial/install.md) na extensão ESP-IDF do VSCode. 
  
  Mas este "tutorial" mau explica como compilar, transferir e rodar códigos na placa ESP32. E a instalação dos exemplos citados acima não pareceu se cumprir. 😠



Obs.: Falta um "curso" sobre uso de "cmake" para iniciantes... Nada documentado à respeito!



#### Instalação Manual

Para o procedimento manual, selecione de acordo com o seu sistema operacional.

- [Instalador do Windows](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/windows-setup.html)
- [Linux e macOS](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/linux-macos-setup.html)

Obs.: No MacOS, a instalação da biblioteca completa para placas ESP32 consumiu 1,77 Gbytes de espaço no disco ⚠️.
Depois dos pacotes instalados e conectando-se a placa ESP32 no MacOS, aparece:

```bash
~/esp> ls /dev/cu*.*                                                                   
/dev/cu.pci-serial22    /dev/cu.usbserial-0001
~/esp> screen /dev/cu.usbserial-0001 115200
I (46) boot: Partition Table:
I (49) boot: ## Label            Usage          Type ST Offset   Length
I (57) boot:  0 phy_init         RF data          01 01 0000f000 00001000
I (64) boot:  1 otadata          OTA data         01 00 00010000 00002000
I (72) boot:  2 nvs              WiFi data        01 02 00012000 0000e000
I (79) boot:  3 at_customize     unknown          40 00 00020000 000e0000
I (87) boot:  4 ota_0            OTA app          00 10 00100000 00180000
I (94) boot:  5 ota_1            OTA app          00 11 00280000 00180000
I (102) boot: End of partition table
E (106) boot: ota data partition invalid and no factory, will try all partitions
I (114) esp_image: segment 0: paddr=0x00100020 vaddr=0x3f400020 size=0x1fdfc (130556) map
I (169) esp_image: segment 1: paddr=0x0011fe24 vaddr=0x3ffc0000 size=0x001ec (   492) load
I (169) esp_image: segment 2: paddr=0x00120018 vaddr=0x400d0018 size=0xddc74 (908404) map
I (493) esp_image: segment 3: paddr=0x001fdc94 vaddr=0x3ffc01ec size=0x0300c ( 12300) load
I (498) esp_image: segment 4: paddr=0x00200ca8 vaddr=0x40080000 size=0x00400 (  1024) load
I (500) esp_image: segment 5: paddr=0x002010b0 vaddr=0x40080400 size=0x0eba0 ( 60320) load
I (534) esp_image: segment 6: paddr=0x0020fc58 vaddr=0x400c0000 size=0x00064 (   100) load
I (543) boot: Loaded app from partition at offset 0x100000
I (543) boot: Disabling RNG early entropy source...
Bin version(Wrover32):1.1.1
I (581) wifi: wifi firmware version: bffcf7f
I (581) wifi: config NVS flash: enabled
I (581) wifi: config nano formating: disabled
I (591) wifi: Init dynamic tx buffer num: 32
I (591) wifi: Init data frame dynamic rx buffer num: 32
I (591) wifi: Init management frame dynamic rx buffer num: 32
I (597) wifi: wifi driver task: 3ffdf604, prio:23, stack:4096
I (602) wifi: Init static rx buffer num: 10
I (606) wifi: Init dynamic rx buffer num: 32
I (610) wifi: wifi power manager task: 0x3ffe3ce4 prio: 21 stack: 2560
I (642) wifi: mode : sta (48:e7:29:b6:cd:b4)
I (645) wifi: mode : sta (48:e7:29:b6:cd:b4) + softAP (48:e7:29:b6:cd:b5)
I (652) wifi: mode : sta (48:e7:29:b6:cd:b4)
```

Obs.: para sair do "screen" aperte a combinação de teclas: `CTRL-A`+ `K`.
Eventualmente será necessário pressionar o botão "EN" ou "BOOT" na placa para que seja estabelecida a comunicação com a placa ESP32.

👋 E **antes** de tentar programar a placa usando o Terminal, não esquecer de dar o comando:

* ` . $HOME/esp/esp-idf/export.sh` $\longleftarrow$ se estiver usando bash ou zsh;
* ` . $HOME/esp/esp-idf/export.fish` $\longleftarrow$ se estiver usando o fish.

Exemplo:

```bash
fernandopassold@MacBook-Pro-de-Fernando ~/e/esp-idf (master)> . $HOME/esp/esp-idf/export.fish                                                                                (base) 
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

fernandopassold@MacBook-Pro-de-Fernando ~/e/esp-idf (master)> idf.py --version                                                                                               (base) 
ESP-IDF v5.4-dev-610-g003f3bb5dc
fernandopassold@MacBook-Pro-de-Fernando ~/e/esp-idf (master)>  
```



**Atenção**: usuários Windows (e Linux), provavelmente será necessário instalar o  [PuTTY SSH Client](https://www.putty.org/) para estabelecer a comunicação com a placa. E depois será necessário configurar a comunicação serial para:

* Speed (baud): 115200;
* Data bits: 8;
* Stop bits: 1;
* Parity: None;
* Row control: XON/XOFF.

---

## ✏️ Primeiro Projeto

Se você já tiver o ESP-IDF instalado e não estiver usando uma IDE, poderá criar seu primeiro projeto a partir da linha de comando após [Iniciar um Projeto no Windows ](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/windows-setup.html#get-started-windows-first-steps)ou [Iniciar um Projeto no Linux e macOS](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/linux-macos-setup.html#get-started-linux-macos-first-steps).

Uma vez compilado o projeto "Hello world!", a seguinte execução do código pode ser visualizada na janela de terminal:

```bash
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
```

Note que esta aplicação teste fica repetidamente exibindo a mensagem "Hello world!" e rebootando o dispositivo à cada 10 segundos.

Para interromper a monitoramento, pressionar a combinação de teclas `CTRL+]`.

Mais info sobre compilar este projeto (no Terminal!) continuar [aqui](iniciando_ESP32.html).

<!-- Falta instalar o VSCode extension: https://github.com/espressif/vscode-esp-idf-extension/blob/master/docs/tutorial/install.md e eventualmente rever: http://esp32.net -->

---

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("🌊 Fernando Passold, atualizado em " + LastUpdated); // End Hiding -->
</script>