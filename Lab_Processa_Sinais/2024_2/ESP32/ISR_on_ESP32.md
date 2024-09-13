# ISR on ESP32

Fonte: https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-reference/system/intr_alloc.html

O ESP32 tem dois núcleos, com 32 interrupções cada. Cada interrupção tem uma prioridade fixa, a maioria (mas não todas) interrupções estão conectadas à matriz de interrupções.

Os periféricos que podem gerar interrupções podem ser divididos em dois tipos:

> - Periféricos externos, dentro do ESP32, mas fora dos próprios núcleos Xtensa. A maioria dos periféricos ESP32 são desse tipo.
> - Periféricos internos, parte dos próprios núcleos de CPU Xtensa.

O manuseio de interrupções difere ligeiramente entre esses dois tipos de periféricos.

### Interrupções Periféricas Internas[](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-reference/system/intr_alloc.html#internal-peripheral-interrupts)

Cada núcleo de CPU Xtensa tem seu próprio conjunto de seis periféricos internos:

> - Comparadores de três temporizadores
> - Um monitor de desempenho
> - Duas interrupções de software

O alocador de interrupção apresenta dois tipos diferentes de interrupções, a saber, interrupções compartilhadas e interrupções não compartilhadas, ambas exigindo um manuseio diferente. As interrupções não compartilhadas alocarão uma interrupção separada para cada chamada [`esp_intr_alloc()`](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-reference/system/intr_alloc.html#_CPPv414esp_intr_allocii14intr_handler_tPvP13intr_handle_t), e essa interrupção é usada apenas para o periférico anexado a ela, com apenas um ISR que será chamado. As interrupções compartilhadas podem ter vários periféricos acionando-as, com vários ISRs sendo chamados quando um dos periféricos conectados sinaliza uma interrupção. Assim, os ISRs destinados a interrupções compartilhadas devem verificar o status de interrupção do periférico que atendem para verificar se alguma ação é necessária.

## Exemplo de ISR

Suponha que se queira programar uma placa ESP32 usando Sketch do Arduino, para gerar um Interrupt Service Routine que deve ser baseada em algum temporizador. Neste caso, esta ISR deve ser executada na frequêncida de 10 KHz. Mostre como a interrupção deve ser ajustada, que registradores devem ser programados, como calcular os valores corretos para garantir a taxa de 10 KHz baseado na frequencia de clock do ESP32. Suponha que esta ISR tenha como único objetivo alternar o nível lógico de alguma saída digital da GPIO do ESP32. Acrescente no código ainda uma rotina baseada em FreeRTOS para ler um botão. Este botão permite controlar quando o usuário quer que a rotina ISR alterne o nível lógico de certo pino ou quando prefere manter o nível lógico deste pino em 0 (LOW).

**Solução possível**:

Para programar uma ISR (Interrupt Service Routine) no ESP32 com uma frequência de 10 kHz e controlar essa interrupção usando FreeRTOS para leitura de um botão, você pode seguir os passos abaixo:

### 1. Configuração da Interrupção com Temporizador

O ESP32 possui temporizadores de hardware que podem ser configurados para gerar interrupções em frequências específicas. O código abaixo configura o Timer 0 do grupo 0 para gerar uma interrupção a cada 100 microsegundos, resultando em uma frequência de 10 kHz.

### 2. Alternância do Nível Lógico da GPIO na ISR

Na ISR, o pino de saída digital é alternado entre HIGH e LOW. 

### 3. Controle do Comportamento da ISR com FreeRTOS

O FreeRTOS é utilizado para criar uma tarefa que verifica o estado de um botão. Se o botão estiver pressionado, a ISR alterna o nível lógico do pino. Caso contrário, o pino é mantido em LOW.

### Código Completo

```cpp
#include "driver/timer.h" // Biblioteca para o uso do temporizador do ESP32
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <freertos/semphr.h>

#define TIMER_DIVIDER         80           // Divisor para o clock base de 1 MHz
#define TIMER_SCALE           (TIMER_BASE_CLK / TIMER_DIVIDER)  // 1 MHz base de clock
#define TIMER_INTERVAL_10KHZ  (100)        // 100 microsegundos para 10kHz
#define OUTPUT_PIN            2            // Pino de saída para alternar (GPIO2)
#define BUTTON_PIN            4            // Pino do botão (GPIO4)

// Variáveis globais
volatile bool toggleOutput = false;
SemaphoreHandle_t xSemaphore = NULL;

// Função de configuração do Timer
void IRAM_ATTR onTimer(){
    if (toggleOutput) {
        digitalWrite(OUTPUT_PIN, !digitalRead(OUTPUT_PIN));
    } else {
        digitalWrite(OUTPUT_PIN, LOW);
    }
    TIMERG0.int_clr_timers.t0 = 1;  // Limpa a interrupção do timer
}

// Configuração do Timer
void setupTimer() {
    timer_config_t config = {
        .divider = TIMER_DIVIDER,             // Clock base de 1 MHz
        .counter_dir = TIMER_COUNT_UP,        // Contagem crescente
        .counter_en = TIMER_PAUSE,            // Iniciar em pausa
        .alarm_en = TIMER_ALARM_EN,           // Habilitar alarme
        .auto_reload = TIMER_AUTORELOAD_EN,   // Auto recarregar o valor
    };

    timer_init(TIMER_GROUP_0, TIMER_0, &config);
    timer_set_counter_value(TIMER_GROUP_0, TIMER_0, 0x00000000ULL);
    timer_set_alarm_value(TIMER_GROUP_0, TIMER_0, TIMER_INTERVAL_10KHZ * TIMER_SCALE);
    timer_enable_intr(TIMER_GROUP_0, TIMER_0);
    timer_isr_register(TIMER_GROUP_0, TIMER_0, onTimer, NULL, ESP_INTR_FLAG_IRAM, NULL);
    timer_start(TIMER_GROUP_0, TIMER_0);
}

// Função da tarefa do botão
void buttonTask(void *pvParameter) {
    pinMode(BUTTON_PIN, INPUT_PULLUP);
    while (1) {
        if (digitalRead(BUTTON_PIN) == LOW) {  // Botão pressionado
            xSemaphoreTake(xSemaphore, portMAX_DELAY);
            toggleOutput = true;
            xSemaphoreGive(xSemaphore);
        } else {  // Botão não pressionado
            xSemaphoreTake(xSemaphore, portMAX_DELAY);
            toggleOutput = false;
            xSemaphoreGive(xSemaphore);
        }
        vTaskDelay(pdMS_TO_TICKS(10));  // Pequeno delay para debouncing
    }
}

void setup() {
    pinMode(OUTPUT_PIN, OUTPUT);
    digitalWrite(OUTPUT_PIN, LOW);

    // Inicializa o semáforo
    xSemaphore = xSemaphoreCreateMutex();

    // Configura o Timer
    setupTimer();

    // Cria a tarefa do botão
    xTaskCreate(buttonTask, "Button Task", 2048, NULL, 1, NULL);
}

void loop() {
    // O loop fica vazio, tudo é tratado na ISR e na tarefa
}
```

### Explicação do Código

1. **Configuração do Temporizador:**
   - O temporizador é configurado com um divisor de 80, o que resulta em um clock base de 1 MHz (80 MHz / 80).
   - O alarme é definido para disparar a cada 100 microsegundos, o que corresponde a uma frequência de 10 kHz.

2. **ISR (`onTimer`):**
   - A ISR alterna o nível lógico do pino de saída (`OUTPUT_PIN`) apenas se `toggleOutput` for verdadeiro. Caso contrário, o pino é mantido em LOW.

3. **Tarefa do Botão (`buttonTask`):**
   - Verifica o estado do botão a cada 10 ms. Se o botão estiver pressionado, a ISR é ativada para alternar o nível lógico. Se não estiver, o pino é mantido em LOW.

Este código deve ser carregado no ESP32 usando o Arduino IDE, e permite que a ISR seja controlada pelo estado de um botão, tudo rodando de forma eficiente graças ao FreeRTOS.

----

<font size="2">🌊 [Fernando Passold](https://fpassold.github.io/)[ 📬 ](mailto:fpassold@gmail.com), <script language="JavaScript"><!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("página criada em dd/mm/2024; atualizada em " + LastUpdated); // End Hiding -->
</script></font>
