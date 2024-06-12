# Sobre o FreeRTOS

- [Sobre o FreeRTOS](#sobre-o-freertos)
  - [O que é o FreeRTOS?](#o-que-é-o-freertos)
  - [Idéia Central](#idéia-central)
  - [Características Principais](#características-principais)
  - [Determinismo no FreeRTOS para Aplicações de Tempo Real](#determinismo-no-freertos-para-aplicações-de-tempo-real)
    - [Escalonamento de Tarefas](#escalonamento-de-tarefas)
    - [Tempo de Troca de Contexto](#tempo-de-troca-de-contexto)
    - [Sincronização e Comunicação](#sincronização-e-comunicação)
    - [Temporizadores de Software](#temporizadores-de-software)
    - [Gerenciamento de Memória](#gerenciamento-de-memória)
    - [Práticas de Design](#práticas-de-design)
    - [Priorização](#priorização)
    - [Interrupções](#interrupções)
    - [Exemplo de Determinismo](#exemplo-de-determinismo)
  - [Exemplo de Multitarefa com tasks síncronas](#exemplo-de-multitarefa-com-tasks-síncronas)
    - [Configuração do Hardware](#configuração-do-hardware)
    - [Código de Exemplo](#código-de-exemplo)
    - [Explicação do Código](#explicação-do-código)
    - [Notas Finais](#notas-finais)
  - [Outras Opções](#outras-opções)



## O que é o FreeRTOS?

FreeRTOS é um sistema operacional de tempo real (RTOS - Real-Time Operating System) de código aberto, amplamente utilizado em sistemas embarcados. Ele é projetado para ser pequeno, eficiente e fácil de portar para várias arquiteturas de hardware.

O kernel FreeRTOS foi originalmente desenvolvido por Richard Barry por volta de 2003, e mais tarde foi desenvolvido e mantido pela empresa de Barry, Real Time Engineers Ltd. Em 2017, a empresa passou a administração do projeto FreeRTOS para a [Amazon Web Services ](https://en.wikipedia.org/wiki/Amazon_Web_Services)(AWS). Barry continua trabalhando no FreeRTOS como parte de uma equipe da AWS. Mais detalhes sobre interesse da Amazon sobre o FreeRTOS ver [[aqui]](http://www.openrtos.net/FAQ_Amazon.html).

Site oficial: https://www.freertos.org/index.html

## Idéia Central

A ideia central do FreeRTOS é fornecer um núcleo de sistema operacional leve e eficiente que permita a criação de aplicações de tempo real, onde as tarefas precisam ser executadas dentro de prazos rígidos e previsíveis. Ele facilita a gestão de múltiplas tarefas concorrentes, a sincronização e a comunicação entre essas tarefas.

O objetivo central do FreeRTOS é oferecer um ambiente de execução robusto e determinístico para aplicações de tempo real, garantindo que as tarefas críticas sejam executadas conforme necessário, com tempos de resposta previsíveis. Ele visa atender a requisitos de sistemas embarcados que demandam alta confiabilidade e desempenho.

O kernel do FreeRTOS é desenhado para ser mínimo e modular, permitindo que ele seja executado em microcontroladores com recursos limitados (em termos de memória e poder de processamento). Isso o torna ideal para uma ampla gama de aplicações embarcadas, desde dispositivos simples até sistemas complexos.

## Características Principais

- **Multitarefas**: Permite a execução de múltiplas tarefas com prioridades diferentes.
- **Gerenciamento de Memória**: Oferece várias estratégias de alocação de memória.
- **Sincronização**: Inclui mecanismos como semáforos, mutexes e filas para comunicação e sincronização entre tarefas.
- **Portabilidade**: Suporta diversas arquiteturas de microcontroladores, facilitando a portabilidade do código.

Em resumo, o FreeRTOS é uma ferramenta essencial para desenvolvedores de sistemas embarcados que necessitam de um sistema operacional de tempo real eficiente e confiável para gerenciar múltiplas tarefas e garantir que as operações críticas sejam realizadas dentro de prazos específicos.

## Determinismo no FreeRTOS para Aplicações de Tempo Real

O determinismo é uma característica crucial em sistemas de tempo real, onde é essencial que as operações ocorram em tempos previsíveis e consistentes. No contexto do FreeRTOS, ser determinístico significa que o comportamento do sistema (especialmente no que diz respeito à temporização e execução de tarefas) é previsível e pode ser garantido dentro de limites específicos. Aqui está uma explicação mais detalhada sobre como o FreeRTOS atinge esse determinismo:

### Escalonamento de Tarefas

FreeRTOS utiliza um escalonador preemptivo baseado em prioridades para gerenciar a execução das tarefas. No escalonador preemptivo, a tarefa com a maior prioridade pronta para executar sempre será escolhida para rodar, interrompendo uma tarefa de menor prioridade se necessário. Isso assegura que tarefas críticas sejam atendidas imediatamente quando necessário.

### Tempo de Troca de Contexto

A troca de contexto (o processo de salvar o estado de uma tarefa e carregar o estado de outra) no FreeRTOS é projetada para ser rápida e eficiente. O tempo de troca de contexto é consistente, o que contribui para o comportamento determinístico, já que o tempo para alternar entre tarefas é conhecido e limitado.

### Sincronização e Comunicação

FreeRTOS fornece diversos mecanismos de sincronização e comunicação entre tarefas, como semáforos, mutexes, filas e timers. Estes mecanismos são implementados de forma eficiente para garantir que as operações de bloqueio e desbloqueio, bem como a troca de mensagens, ocorram em tempos previsíveis.

### Temporizadores de Software

FreeRTOS oferece temporizadores de software que permitem que tarefas sejam executadas em momentos específicos no futuro ou periodicamente. Os temporizadores são gerenciados pelo kernel de uma maneira que garante que os tempos de execução especificados sejam respeitados, contribuindo para a previsibilidade do sistema.

### Gerenciamento de Memória

FreeRTOS oferece várias estratégias de gerenciamento de memória, incluindo alocadores de memória determinísticos. Esses alocadores garantem que operações de alocação e liberação de memória ocorram em tempos fixos, evitando surpresas de latência associadas a fragmentação de memória ou algoritmos complexos de gerenciamento de memória.

### Práticas de Design

Para garantir o determinismo, é importante que os desenvolvedores sigam práticas de design que evitem comportamentos indeterminísticos. Por exemplo, evitar tarefas que consomem muito tempo ou que têm latências imprevisíveis, dividir tarefas longas em sub-tarefas menores e garantir que as operações de bloqueio sejam curtas e previsíveis.

### Priorização

A prioridade das tarefas é um aspecto crucial. As tarefas mais críticas recebem as prioridades mais altas, e o escalonador do FreeRTOS assegura que essas tarefas sejam executadas preferencialmente. Esse esquema de prioridade ajuda a manter a previsibilidade e a atender aos prazos rigorosos das tarefas de tempo real.

### Interrupções

O FreeRTOS lida com interrupções de forma que os tempos de resposta a eventos externos sejam minimizados e previsíveis. As rotinas de tratamento de interrupções (**ISRs - *Interrupt Service Routines***) devem ser curtas e rápidas, geralmente apenas sinalizando tarefas para serem executadas pelo escalonador do FreeRTOS.

### Exemplo de Determinismo

Suponha que uma tarefa crítica em um sistema embarcado de controle de motor precisa ser executada a cada 10 ms. No FreeRTOS, você pode configurar essa tarefa com uma alta prioridade e usar um temporizador de software para garantir que ela seja despertada a cada 10 ms. O escalonador do FreeRTOS garantirá que, uma vez que a tarefa esteja pronta para executar (devido ao temporizador), ela interromperá quaisquer tarefas de menor prioridade e será executada imediatamente. Esse comportamento previsível é o que torna o FreeRTOS determinístico para aplicações de tempo real.

## Exemplo de Multitarefa com tasks síncronas

Suponha um programa exemplo para ESP32 na qual uma task síncrona faça piscar um Led na frequência de 1 Hz e outra task síncrona simplesmente alterna o nível lógico de uma saída digital da GPIO da placa na frequência de 2 KHz (acabando por gerar uma onda Quadrada oscilando em 1 KHz). Uma terceira task deve monitorar se o usuário pressionou um botão de pressão, alternando o nível lógico de uma variável booleano que serviria para controlar se a task associada com a onda quadrada deve continuar sendo executada ou se deve ser paralizada. 

Você pode implementar essas tarefas no ESP32 usando o FreeRTOS. Este exemplo poderia conter 3 tarefas:
1. **Task_LED**: Faz o LED piscar com uma frequência de 1 Hz.
2. **Task_SquareWave**: Gera uma onda quadrada de 1 kHz alternando o nível lógico de uma saída digital a 2 kHz.
3. **Task_Button**: Monitora um botão de pressão e controla a execução da tarefa associada à onda quadrada.

### Configuração do Hardware

Vamos supor que:
- O LED está conectado ao pino 2 (GPIO 2).
- A saída digital para a onda quadrada está no pino 4 (GPIO 4).
- O botão está conectado ao pino 15 (GPIO 15) e está configurado para usar um pull-up interno.

### Código de Exemplo

```c
#include <Arduino.h>

// Definindo os pinos
#define LED_PIN 2
#define SQUARE_WAVE_PIN 4
#define BUTTON_PIN 15

// Protótipos das funções das tarefas
void Task_LED(void *pvParameters);
void Task_SquareWave(void *pvParameters);
void Task_Button(void *pvParameters);

// Variável global para controlar a execução da tarefa de onda quadrada
volatile bool squareWaveEnabled = true;

void setup() {
  // Configurações iniciais
  Serial.begin(115200);

  // Configurar os pinos
  pinMode(LED_PIN, OUTPUT);
  pinMode(SQUARE_WAVE_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);

  // Criar tarefas
  xTaskCreate(Task_LED, "Task_LED", 1024, NULL, 1, NULL);
  xTaskCreate(Task_SquareWave, "Task_SquareWave", 1024, NULL, 1, NULL);
  xTaskCreate(Task_Button, "Task_Button", 1024, NULL, 1, NULL);
}

void loop() {
  // O loop do Arduino fica vazio, pois usamos o FreeRTOS
}

// Tarefa para piscar o LED com frequência de 1 Hz
void Task_LED(void *pvParameters) {
  const TickType_t xFrequency = pdMS_TO_TICKS(500);  // 500 ms (1 Hz)
  TickType_t xLastWakeTime = xTaskGetTickCount();

  while (true) {
    // Alternar o estado do LED
    digitalWrite(LED_PIN, !digitalRead(LED_PIN));
    // Aguardar até a próxima execução
    vTaskDelayUntil(&xLastWakeTime, xFrequency);
  }
}

// Tarefa para gerar uma onda quadrada de 1 kHz
void Task_SquareWave(void *pvParameters) {
  const TickType_t xFrequency = pdMS_TO_TICKS(0.5);  // 0.5 ms (2 kHz)
  TickType_t xLastWakeTime = xTaskGetTickCount();

  while (true) {
    if (squareWaveEnabled) {
      // Alternar o estado da saída digital
      digitalWrite(SQUARE_WAVE_PIN, !digitalRead(SQUARE_WAVE_PIN));
    } else {
      // Se a tarefa estiver desabilitada, garantir que o pino esteja em nível baixo
      digitalWrite(SQUARE_WAVE_PIN, LOW);
    }
    // Aguardar até a próxima execução
    vTaskDelayUntil(&xLastWakeTime, xFrequency);
  }
}

// Tarefa para monitorar o botão
void Task_Button(void *pvParameters) {
  bool lastButtonState = HIGH;  // O botão está conectado a um pull-up interno

  while (true) {
    // Ler o estado atual do botão
    bool currentButtonState = digitalRead(BUTTON_PIN);

    // Detectar a borda de descida (botão pressionado)
    if (lastButtonState == HIGH && currentButtonState == LOW) {
      // Alternar o estado da variável global
      squareWaveEnabled = !squareWaveEnabled;
      Serial.print("Square wave ");
      Serial.println(squareWaveEnabled ? "enabled" : "disabled");
    }

    // Atualizar o estado do botão
    lastButtonState = currentButtonState;

    // Aguardar um curto período para debouncing
    vTaskDelay(pdMS_TO_TICKS(50));
  }
}
```

### Explicação do Código

1. **Configuração dos Pinos**:
   - `LED_PIN`, `SQUARE_WAVE_PIN` e `BUTTON_PIN` são definidos para os pinos usados no LED, na saída digital e no botão, respectivamente.

2. **Inicialização do FreeRTOS**:
   - `xTaskCreate` é usado para criar três tarefas: `Task_LED`, `Task_SquareWave` e `Task_Button`.

3. **Tarefa de Piscar o LED (Task_LED)**:
   - Esta tarefa alterna o estado do LED a cada 500 ms, resultando em uma frequência de 1 Hz.

4. **Tarefa de Geração da Onda Quadrada (Task_SquareWave)**:
   - Esta tarefa alterna o estado da saída digital a cada 0.5 ms, gerando uma frequência de 1 kHz.
   - A execução desta tarefa é controlada pela variável global `squareWaveEnabled`.

5. **Tarefa de Monitoramento do Botão (Task_Button)**:
   - Esta tarefa monitora o estado do botão e alterna a variável `squareWaveEnabled` quando o botão é pressionado.
   - Utiliza um pequeno atraso para debouncing do botão (50 ms).

### Notas Finais

- Certifique-se de que o botão esteja corretamente configurado com um pull-up interno para evitar leituras flutuantes.
- A frequência de 1 kHz para a onda quadrada é alcançada alternando a saída digital a 2 kHz.
- Este exemplo utiliza o FreeRTOS para criar um sistema multitarefa simples que demonstra controle de hardware básico no ESP32.

Este código pode ser facilmente carregado no ESP32 usando o Arduino IDE ou outro ambiente de desenvolvimento compatível.

### ERRATA

O código anterior faz atuar o watchdog, implicando em constantes reboots da placa. É gerado uma "task exception" em relação à "Task_SquareWave":

```
ELF file SHA256: Guru Meditation Error: Core  1 panic'ed (Unhandled debug exception). 
Debug exception reason: Stack canary watchpoint triggered (Task_SquareWave) 
Core  1 register dump:
PC      : 0x400811bb  PS      : 0x00060736  A0      : 0x800d7e07  A1      : 0x3ffb8ef0  
A2      : 0x3ffb8f2b  A3      : 0x00000010  A4      : 0x3ffc1514  A5      : 0x00000001  
A6      : 0x00000000  A7      : 0x00000000  A8      : 0x3ffb8f3b  A9      : 0x0000000d  
A10     : 0x3ffc1480  A11     : 0x0000000f  A12     : 0x00000009  A13     : 0x00000066  
A14     : 0xffdfffff  A15     : 0x00000000  SAR     : 0x0000000a  EXCCAUSE: 0x00000001  
EXCVADDR: 0x00000000  LBEG    : 0x40085b8c  LEND    : 0x40085ba2  LCOUNT  : 0x00000000  
```

Significa que o tamanho alocado para a pilha da tarefa "Task_SquareWave" é pequeno. Revisando a função "[xTaskCreate()](xTaskCreate.html)" tomamos:

```c++
xTaskCreate(Task_SquareWave, "Task_SquareWave", 1024, NULL, 1, NULL);
```

Aumentar um pouco o tamanho da pilha para:

```c++
xTaskCreate(Task_SquareWave, "Task_SquareWave", 1224, NULL, 1, NULL);
```

Com isto, este erro desaparece, mas ainda temos a placa rebootando:

```
Rebooting...
ets Jul 29 2019 12:21:46

rst:0xc (SW_CPU_RESET),boot:0x13 (SPI_FAST_FLASH_BOOT)
configsip: 0, SPIWP:0xee
clk_drv:0x00,q_drv:0x00,d_drv:0x00,cs0_drv:0x00,hd_drv:0x00,wp_drv:0x00
mode:DIO, clock div:1
load:0x3fff0030,len:1448
load:0x40078000,len:14844
ho 0 tail 12 room 4
load:0x40080400,len:4
load:0x40080404,len:3356
entry 0x4008059c


assert failed: xTaskDelayUntil tasks.c:1570 (( xTimeIncrement > 0U ))


Backtrace: 0x400d96da:0x3ffb8f30 0x400d7b5d:0x3ffb8f60 0x400d7b78:0x3ffb8fa0 0x400d7b88:0x3ffb8fc0 0x400d7cbe:0x3ffb8fe0 0x400d2094:0x3ffb9060 0x400d8742:0x3ffb9080 0x400824e8:0x3ffb90d0 0x40083830:0x3ffb90f0 0x40082131:0x3ffb91b0 0x40088011:0x3ffb91d0 0x4008d016:0x3ffb91f0 0x40089916:0x3ffb9320 0x400d14a9:0x3ffb9340




ELF file SHA256: d20271629ccfebb1

Rebooting...
ets Jul 29 2019 12:21:46
```

Este problema de "assert" associado com uma task está relacionado com as configurações de períodos de tempo escolhidos para as tasks síncronas.

O FreeRTOS não “gostou” do intervalo de tempo adotado. Observe que o FreeRTOS e seus temporizadores operam com base em *ticks*.

Com a taxa de *tick* padrão de 100 Hz, 1 *tick* = 10ms = portTICK_PERIOD_MS.

Para referência, o ESP32 rodando a 240 MHz e usando o método Task Dispatch tem os valores de tempo limite mínimo aproximados [como segue](https://docs.espressif.com/projects/esp-idf/en/latest/esp32s3/api-reference/system/esp_timer.html#timeout-value-limits):

* Temporizadores de disparo único: $\cong$ 20 $\mu$s ($f_s\vert_{\text{one_shoot}}>$ 50 KHz)
  Se esp_timer_start_once() for chamado, este será o primeiro momento após o qual o sistema poderá despachar a execução de uma nova tarefa.

* Temporizadores periódicos: $\cong$ 50 $\mu$s ($f_s>$ 20 KHz)
  Os temporizadores de software periódicos com um valor de tempo limite menor simplesmente consumiriam a maior parte do tempo da CPU, o que é impraticável. 

<!--Então const TickType_t vPeriodicTaskPreiod = 1/portTICK_PERIOD_MS; produz 0. Ref.: https://esp32.com/viewtopic.php?t=34128 -->

Uma solução pode ser uar  [High Resolution Timer (ESP timer)](https://docs.espressif.com/projects/esp-idf/en/latest/esp32s3/api-reference/system/esp_timer.html). 

Ou alternativamente, pode-se alterar a taxa de *tick* do FreeRTOS para 1000 Hz por meio do menuconfig. No entanto, é provável que isso aumente a carga da CPU devido a 10x mais interrupções de ticks e potencial troca de tarefas.

Este problema deve ser solucionado dentro da declaração das tarefas. Como o led parece estar piscando na frequência correta de 1 Hz, vamos supor que o problema esteja associado com a task que deve ser executada de maneira mais rápida: "Task_SquareWave":

```C++
void Task_SquareWave(void *pvParameters) {
  const TickType_t xFrequency = pdMS_TO_TICKS(0.5);  // 0.5 ms (2 kHz)
  // Inicializar o último tempo de despertar com o tick atual
  TickType_t xLastWakeTime = xTaskGetTickCount();

  while (true) {
    if (squareWaveEnabled) {
      // Alternar o estado da saída digital
      digitalWrite(SQUARE_WAVE_PIN, !digitalRead(SQUARE_WAVE_PIN));
    } else {
      // Se a tarefa estiver desabilitada, garantir que o pino esteja em nível baixo
      digitalWrite(SQUARE_WAVE_PIN, LOW);
    }
    // Aguardar até a próxima execução
    vTaskDelayUntil(&xLastWakeTime, xFrequency);
  }
}
```

Aqui, devemos conferir se as informações para a função "[vTaskDelayUntil()](vTaskDelayUntil.html)" estão chegando da forma correta.

E realmente, temos um problema com a definição da constante "TickType_t" que faz com que o valor de "xLastWakeTime" fique incorreto. A variável do tipo "TickType_t" parece ser do tipo "uint64_t", então 0.5 será interpretado como zero (nulo).

Note que:

```c++
uint64t	TickTypet;
define pdMSTOTICKS( xTimeInMs ) ( ( TickTypet ) ( ( ( TickTypet ) ( xTimeInMs ) * ( TickTypet ) configTICKRATEHZ ) / ( TickTypet ) 1000 ) )
```

Assim sendo "pdMSTOTICKS" só funciona com taxas de tick iguais ou inferiores a 1KHz, pois os resultados são armazenados em **números inteiros** que não podem armazenar frações de milissegundo.



|                                                              | **Atenção:**                                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![spongebob-spongebob-squarepants](figs/spongebob-spongebob-squarepants.gif) | As funções **vTaskDelay()** ou **vTaskDelayUntil()** só funcionam para períodos de amostragem $\ge$ 1 ms. |

A **solução** é aumentar a taxa do *tick rate* do FreeRTOS para valores acima de 1000 Hz ou fazer uso de rotinas ISR usando [**ESP Timer (High Resolution Timer)**](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/system/esp_timer.html#esp-timer-high-resolution-timer). Desta forma, seria possível executar taskj síncronas a com [taxas de amostragem próximas de 50 $\mu$s ($f_s \cong$ 20 KHz)](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/system/esp_timer.html#timeout-value-limits).





---

## Outras Opções

* Função [**xTaskCreate()**](xTaskCreate.html);
* Função [**vTaskDelayUntil()**](vTaskDelayUntil.html);
* [Definindo prioridades em tarefas](prioridades.html);
* Ferramentas ["htop" para FreeRTOS](htop_FreeRTOS.html);
* [Exemplo de rotina de controle digital](controle_digital_ex1.html).

---

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("🌊 Fernando Passold, página crida em 05/06/2024 21:3, atualizada em " + LastUpdated); // End Hiding -->
</script>