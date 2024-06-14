# Onda Quadrada à 10 KHz no ESP32

> Sugira uma task síncrona usando FreeRTOS para esp32, programada usando IDE Eclipse, para gerar uma onda quadrada na frequência de 10 KHz simplesmente alternando o nível lógico de um pino da GPIO. Esta task deve usar o timer de alta-resolução das placas ESP32. Implementar outra task que roda a cada 100 ms mostrando o nível lógico da onda. A rotina ainda deve ler o botão built-in da placa ESP para permitir pausar o sinal (nível lógico vai à zero) ou executar novamente a onda, cada vez que é pressionado.

**Solução possível**:

Para implementar uma task síncrona usando FreeRTOS para gerar uma onda quadrada na frequência de 10 KHz e outra task que roda a cada 100 ms mostrando o nível lógico da onda, vamos usar a IDE Eclipse e programar para a placa ESP32. Além disso, vamos usar o botão built-in para pausar e retomar o sinal.

### Passo 1: Configurar o ambiente de desenvolvimento
Certifique-se de ter a ESP-IDF (Espressif IoT Development Framework) instalada e configurada com Eclipse IDE. Este guia assume que você já tem o ambiente configurado.

### Passo 2: Código para gerar a onda quadrada e monitorar o botão
A seguir está o código completo em C:

```c
#include <stdio.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <freertos/queue.h>
#include <driver/gpio.h>
#include <driver/periph_ctrl.h>
#include <driver/timer.h>

// Definindo o GPIO do LED e do botão
#define GPIO_OUTPUT_IO 2        // Pino para gerar a onda quadrada
#define GPIO_INPUT_IO 0         // Botão built-in

#define ESP_INTR_FLAG_DEFAULT 0
#define TIMER_DIVIDER         16   // Divisor do timer (80 MHz / 16 = 5 MHz)
#define TIMER_SCALE           (TIMER_BASE_CLK / TIMER_DIVIDER)  // Frequência do timer
#define TIMER_INTERVAL0_SEC   (0.00005) // 50 microsegundos para 10kHz

static xQueueHandle gpio_evt_queue = NULL;
static volatile int is_running = 1; // Flag para controlar o estado do sinal

// ISR do botão
static void IRAM_ATTR gpio_isr_handler(void* arg) {
    uint32_t gpio_num = (uint32_t) arg;
    xQueueSendFromISR(gpio_evt_queue, &gpio_num, NULL);
}

// Task para tratar a interrupção do botão
static void button_task(void* arg) {
    uint32_t io_num;
    for(;;) {
        if(xQueueReceive(gpio_evt_queue, &io_num, portMAX_DELAY)) {
            is_running = !is_running; // Alterna o estado do sinal
            gpio_set_level(GPIO_OUTPUT_IO, 0); // Garante que o sinal seja zero quando pausado
        }
    }
}

// Task para gerar a onda quadrada
static void square_wave_task(void* arg) {
    // Configuração do timer
    timer_config_t config = {
        .divider = TIMER_DIVIDER,
        .counter_dir = TIMER_COUNT_UP,
        .counter_en = TIMER_PAUSE,
        .alarm_en = TIMER_ALARM_EN,
        .auto_reload = TIMER_AUTORELOAD_EN,
    };
    timer_init(TIMER_GROUP_0, TIMER_0, &config);
    timer_set_counter_value(TIMER_GROUP_0, TIMER_0, 0x00000000ULL);
    timer_set_alarm_value(TIMER_GROUP_0, TIMER_0, TIMER_INTERVAL0_SEC * TIMER_SCALE);
    timer_enable_intr(TIMER_GROUP_0, TIMER_0);
    timer_start(TIMER_GROUP_0, TIMER_0);

    int level = 0;

    for(;;) {
        if (is_running) {
            timer_get_counter_value(TIMER_GROUP_0, TIMER_0, NULL);
            timer_pause(TIMER_GROUP_0, TIMER_0);
            timer_set_counter_value(TIMER_GROUP_0, TIMER_0, 0x00000000ULL);
            timer_start(TIMER_GROUP_0, TIMER_0);

            level = !level;
            gpio_set_level(GPIO_OUTPUT_IO, level);

            // Aguarda até o próximo alarme
            timer_wait_for_intr(TIMER_GROUP_0, TIMER_0);
        } else {
            vTaskDelay(pdMS_TO_TICKS(10)); // Aguarda um pouco quando pausado
        }
    }
}

// Task para monitorar o estado do sinal
static void monitor_task(void* arg) {
    for(;;) {
        int level = gpio_get_level(GPIO_OUTPUT_IO);
        printf("Nível lógico da onda: %d\n", level);
        vTaskDelay(pdMS_TO_TICKS(100));
    }
}

void app_main() {
    // Configura os pinos GPIO
    gpio_config_t io_conf;
    io_conf.intr_type = GPIO_INTR_NEGEDGE; // Interrupção na borda de descida
    io_conf.pin_bit_mask = (1ULL << GPIO_INPUT_IO);
    io_conf.mode = GPIO_MODE_INPUT;
    io_conf.pull_up_en = 1;
    gpio_config(&io_conf);

    io_conf.intr_type = GPIO_INTR_DISABLE;
    io_conf.pin_bit_mask = (1ULL << GPIO_OUTPUT_IO);
    io_conf.mode = GPIO_MODE_OUTPUT;
    io_conf.pull_down_en = 0;
    io_conf.pull_up_en = 0;
    gpio_config(&io_conf);

    // Cria a fila de eventos GPIO
    gpio_evt_queue = xQueueCreate(10, sizeof(uint32_t));
    gpio_install_isr_service(ESP_INTR_FLAG_DEFAULT);
    gpio_isr_handler_add(GPIO_INPUT_IO, gpio_isr_handler, (void*) GPIO_INPUT_IO);

    // Cria as tasks
    xTaskCreate(button_task, "button_task", 2048, NULL, 10, NULL);
    xTaskCreate(square_wave_task, "square_wave_task", 2048, NULL, 10, NULL);
    xTaskCreate(monitor_task, "monitor_task", 2048, NULL, 10, NULL);
}
```

### Explicação do Código

1. **Configuração do GPIO**:
    - `GPIO_OUTPUT_IO` é configurado como saída para gerar a onda quadrada.
    - `GPIO_INPUT_IO` é configurado como entrada para o botão built-in com uma interrupção configurada na borda de descida.

2. **Task `button_task`**:
    - Trata a interrupção do botão e alterna o estado da flag `is_running`.

3. **Task `square_wave_task`**:
    - Configura o timer de alta-resolução para gerar a onda quadrada com a frequência desejada.
    - Alterna o nível lógico do pino de saída em cada interrupção do timer.

4. **Task `monitor_task`**:
    - Monitora e imprime o nível lógico da onda quadrada a cada 100 ms.

### Notas Adicionais

- Este código usa a função `timer_wait_for_intr` que espera a próxima interrupção do timer. Certifique-se de adaptar a função de acordo com a API de timers do ESP-IDF.
- O botão built-in é usado para pausar e retomar a geração da onda quadrada, alternando o estado do sinal.

### Considerações Finais

- Certifique-se de que a ESP32 esteja configurada corretamente para exibir as mensagens de `printf` no monitor serial.
- O botão built-in é usado para pausar e retomar a geração da onda quadrada. A flag `is_running` controla este comportamento.
- Compile e carregue o código na ESP32 usando a IDE Eclipse configurada para ESP-IDF. Abra o monitor serial para ver as mensagens enviadas pela `monitor_task`.

Compile e carregue este código na sua ESP32 usando a IDE Eclipse configurada para ESP-IDF. A task `button_task` controlará o estado do sinal e a task `monitor_task` exibirá o nível lógico da onda.

---

**Modificação** para ativar o builtin led para indicar se onda quadrada está sendo gerada ou não:

Para modificar a task `button_task` para ativar o LED built-in da placa ESP32 quando a onda quadrada estiver sendo gerada, podemos fazer o seguinte:

1. **Identificar o pino do LED built-in**. Na maioria das placas ESP32, o LED built-in está no pino GPIO 2.
2. **Modificar a task `button_task` para alternar o estado do LED conforme o estado da flag `is_running`**.

A seguir está o código atualizado:

```c
#include <stdio.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <freertos/queue.h>
#include <driver/gpio.h>
#include <driver/periph_ctrl.h>
#include <driver/timer.h>

// Definindo o GPIO do LED, do LED built-in e do botão
#define GPIO_OUTPUT_IO 2        // Pino para gerar a onda quadrada
#define GPIO_INPUT_IO 0         // Botão built-in
#define GPIO_BUILTIN_LED 2      // LED built-in

#define ESP_INTR_FLAG_DEFAULT 0
#define TIMER_DIVIDER         16   // Divisor do timer (80 MHz / 16 = 5 MHz)
#define TIMER_SCALE           (TIMER_BASE_CLK / TIMER_DIVIDER)  // Frequência do timer
#define TIMER_INTERVAL0_SEC   (0.00005) // 50 microsegundos para 10kHz

static xQueueHandle gpio_evt_queue = NULL;
static volatile int is_running = 1; // Flag para controlar o estado do sinal

// ISR do botão
static void IRAM_ATTR gpio_isr_handler(void* arg) {
    uint32_t gpio_num = (uint32_t) arg;
    xQueueSendFromISR(gpio_evt_queue, &gpio_num, NULL);
}

// Task para tratar a interrupção do botão
static void button_task(void* arg) {
    uint32_t io_num;
    for(;;) {
        if(xQueueReceive(gpio_evt_queue, &io_num, portMAX_DELAY)) {
            is_running = !is_running; // Alterna o estado do sinal
            gpio_set_level(GPIO_OUTPUT_IO, 0); // Garante que o sinal seja zero quando pausado
            gpio_set_level(GPIO_BUILTIN_LED, is_running); // Define o estado do LED built-in
        }
    }
}

// Task para gerar a onda quadrada
static void square_wave_task(void* arg) {
    // Configuração do timer
    timer_config_t config = {
        .divider = TIMER_DIVIDER,
        .counter_dir = TIMER_COUNT_UP,
        .counter_en = TIMER_PAUSE,
        .alarm_en = TIMER_ALARM_EN,
        .auto_reload = TIMER_AUTORELOAD_EN,
    };
    timer_init(TIMER_GROUP_0, TIMER_0, &config);
    timer_set_counter_value(TIMER_GROUP_0, TIMER_0, 0x00000000ULL);
    timer_set_alarm_value(TIMER_GROUP_0, TIMER_0, TIMER_INTERVAL0_SEC * TIMER_SCALE);
    timer_enable_intr(TIMER_GROUP_0, TIMER_0);
    timer_start(TIMER_GROUP_0, TIMER_0);

    int level = 0;

    for(;;) {
        if (is_running) {
            timer_get_counter_value(TIMER_GROUP_0, TIMER_0, NULL);
            timer_pause(TIMER_GROUP_0, TIMER_0);
            timer_set_counter_value(TIMER_GROUP_0, TIMER_0, 0x00000000ULL);
            timer_start(TIMER_GROUP_0, TIMER_0);

            level = !level;
            gpio_set_level(GPIO_OUTPUT_IO, level);

            // Aguarda até o próximo alarme
            timer_wait_for_intr(TIMER_GROUP_0, TIMER_0);
        } else {
            vTaskDelay(pdMS_TO_TICKS(10)); // Aguarda um pouco quando pausado
        }
    }
}

// Task para monitorar o estado do sinal
static void monitor_task(void* arg) {
    for(;;) {
        int level = gpio_get_level(GPIO_OUTPUT_IO);
        printf("Nível lógico da onda: %d\n", level);
        vTaskDelay(pdMS_TO_TICKS(100));
    }
}

void app_main() {
    // Configura os pinos GPIO
    gpio_config_t io_conf;
    io_conf.intr_type = GPIO_INTR_NEGEDGE; // Interrupção na borda de descida
    io_conf.pin_bit_mask = (1ULL << GPIO_INPUT_IO);
    io_conf.mode = GPIO_MODE_INPUT;
    io_conf.pull_up_en = 1;
    gpio_config(&io_conf);

    io_conf.intr_type = GPIO_INTR_DISABLE;
    io_conf.pin_bit_mask = (1ULL << GPIO_OUTPUT_IO);
    io_conf.mode = GPIO_MODE_OUTPUT;
    io_conf.pull_down_en = 0;
    io_conf.pull_up_en = 0;
    gpio_config(&io_conf);

    // Configura o LED built-in como saída
    io_conf.pin_bit_mask = (1ULL << GPIO_BUILTIN_LED);
    io_conf.mode = GPIO_MODE_OUTPUT;
    io_conf.pull_down_en = 0;
    io_conf.pull_up_en = 0;
    gpio_config(&io_conf);

    // Cria a fila de eventos GPIO
    gpio_evt_queue = xQueueCreate(10, sizeof(uint32_t));
    gpio_install_isr_service(ESP_INTR_FLAG_DEFAULT);
    gpio_isr_handler_add(GPIO_INPUT_IO, gpio_isr_handler, (void*) GPIO_INPUT_IO);

    // Cria as tasks
    xTaskCreate(button_task, "button_task", 2048, NULL, 10, NULL);
    xTaskCreate(square_wave_task, "square_wave_task", 2048, NULL, 10, NULL);
    xTaskCreate(monitor_task, "monitor_task", 2048, NULL, 10, NULL);
}
```

### Explicação das Modificações

1. **Definição do LED Built-in**:
    - `#define GPIO_BUILTIN_LED 2`: Adicionada definição do pino do LED built-in.

2. **Configuração do LED Built-in**:
    - Adicionada a configuração do pino `GPIO_BUILTIN_LED` como saída no `app_main`.

3. **Modificação na `button_task`**:
    - Adicionada linha `gpio_set_level(GPIO_BUILTIN_LED, is_running)` para definir o estado do LED built-in conforme o estado de `is_running`.

Agora, quando a onda quadrada estiver sendo gerada (`is_running` for verdadeiro), o LED built-in estará aceso. Quando a geração da onda estiver pausada (`is_running` for falso), o LED built-in estará apagado.

**Código anterior levemente alterado para interface IDE do Arduino**:

Claro! A seguir, vou adaptar o código anterior para ser usado na interface IDE do Arduino com a placa ESP32. O código irá gerar uma onda quadrada com frequência de 10 kHz, monitorar o botão built-in para pausar ou retomar a geração da onda e ativar o LED built-in quando a onda estiver sendo gerada.

### Código para IDE Arduino

```cpp
#include <Arduino.h>

// Definindo o GPIO do LED, do LED built-in e do botão
#define GPIO_OUTPUT_IO 2        // Pino para gerar a onda quadrada (LED built-in)
#define GPIO_INPUT_IO 0         // Botão built-in

volatile int is_running = 1; // Flag para controlar o estado do sinal
volatile int level = 0;      // Nível lógico da onda

hw_timer_t *timer = NULL;    // Ponteiro para o timer

// ISR do botão
void IRAM_ATTR button_isr() {
    is_running = !is_running; // Alterna o estado do sinal
    digitalWrite(GPIO_OUTPUT_IO, LOW); // Garante que o sinal seja zero quando pausado
    digitalWrite(LED_BUILTIN, is_running); // Define o estado do LED built-in
}

// ISR do timer
void IRAM_ATTR onTimer() {
    if (is_running) {
        level = !level;
        digitalWrite(GPIO_OUTPUT_IO, level);
    }
}

void setup() {
    // Configura os pinos GPIO
    pinMode(GPIO_OUTPUT_IO, OUTPUT);    // Configura o pino de saída
    pinMode(GPIO_INPUT_IO, INPUT_PULLUP); // Configura o botão com pull-up interno
    pinMode(LED_BUILTIN, OUTPUT);       // Configura o LED built-in como saída

    // Configura a interrupção do botão
    attachInterrupt(digitalPinToInterrupt(GPIO_INPUT_IO), button_isr, FALLING);

    // Configura o timer
    timer = timerBegin(0, 80, true); // Timer 0, prescaler de 80 para 1 MHz
    timerAttachInterrupt(timer, &onTimer, true);
    timerAlarmWrite(timer, 50, true); // 50 microsegundos para 10 kHz
    timerAlarmEnable(timer);          // Ativa o alarme do timer

    // Inicializa o serial para monitorar o nível lógico da onda
    Serial.begin(115200);
}

void loop() {
    static unsigned long lastMillis = 0;

    // Monitoramento do estado do sinal a cada 100 ms
    if (millis() - lastMillis >= 100) {
        lastMillis = millis();
        int current_level = digitalRead(GPIO_OUTPUT_IO);
        Serial.printf("Nível lógico da onda: %d\n", current_level);
    }
}
```

### Explicação do Código

1. **Configuração dos Pinos GPIO**:
    - `GPIO_OUTPUT_IO` é configurado como saída para gerar a onda quadrada.
    - `GPIO_INPUT_IO` é configurado como entrada para o botão built-in com pull-up interno.
    - `LED_BUILTIN` (pino 2) é configurado como saída para indicar o estado da geração da onda.

2. **Interrupção do Botão**:
    - A ISR `button_isr` alterna a flag `is_running`, define o sinal para baixo (LOW) e ajusta o estado do LED built-in.

3. **Interrupção do Timer**:
    - A ISR `onTimer` alterna o nível lógico do pino de saída a cada interrupção do timer se `is_running` estiver verdadeiro.

4. **Setup**:
    - Configura os pinos, a interrupção do botão e o timer.
    - Inicializa o monitor serial para enviar o nível lógico atual da onda.

5. **Loop Principal**:
    - Monitora o estado do sinal a cada 100 ms e envia o nível lógico atual para o monitor serial.

### Notas Adicionais

- Certifique-se de selecionar a placa ESP32 correta e a porta serial na IDE do Arduino antes de carregar o código.
- Abra o Monitor Serial na IDE do Arduino para visualizar os níveis lógicos da onda quadrada.

Essa adaptação deve funcionar de maneira semelhante ao código original, agora dentro da interface do Arduino, tornando o desenvolvimento e a depuração mais acessíveis para quem está acostumado com esse ambiente.