# Controle Digital usando FreeRTOS

- [Controle Digital usando FreeRTOS](#controle-digital-usando-freertos)
  - [Exemplo de uma rotina de controle digital](#exemplo-de-uma-rotina-de-controle-digital)
    - [Possível solução](#possível-solução)
    - [Passos para Implementação](#passos-para-implementação)
    - [Código de Exemplo](#código-de-exemplo)
      - [Configuração do Hardware](#configuração-do-hardware)
      - [Inicialização do FreeRTOS](#inicialização-do-freertos)
    - [Explicação do Código](#explicação-do-código)
  - [Outras opções](#outras-opções)


## Exemplo de uma rotina de controle digital

Suponha que estamos usando uma placa eletrônica do tipo ESP32 e queremos executar uma rotina de controle proporcional na qual o algoritmo de controle (controle proporcional) deve ser executada obedecendo um período de amostragem de 100 Hz. Esta rotina deve ler dados de um sensor (algum canal de conversor Analógico para Digital (ADC) disponível na placa ESP32), deve calcular a lei de controle e deve enviar o sinal de controle para fora usando alguma canal livre de um conversor de Digital para Analógico (DAC) disponível na placa ESP32. Suponha que no tempo livre, esta placa poderia estar enviando via porta serial, 3 colunas de dados, onde a primeira coluna seria o valor atual da referência ou set-point, a segunda coluna seria o valor atual lido via ADC e a terceira coluna, o valor do sinal de controle gerado e enviado para o DAC.

### Possível solução

Para implementar um controle proporcional em um ESP32 utilizando FreeRTOS, com um período de amostragem de 100 Hz, precisamos configurar uma tarefa periódica que lê os dados de um sensor via ADC, calcula o controle proporcional, envia o sinal de controle para o DAC e, no tempo livre, envia os dados via porta serial. A seguir, descrevo como essa implementação pode ser feita.

### Passos para Implementação

1. **Configuração do Hardware**: Configurar os pinos de ADC e DAC do ESP32.
2. **Inicialização do FreeRTOS**: Criar tarefas e temporizadores no FreeRTOS.
3. **Implementação da Tarefa de Controle Proporcional**: Esta tarefa será executada a cada 10 ms (100 Hz).
4. **Implementação da Comunicação Serial**: Enviar os dados via UART.

### Código de Exemplo

A seguir, um exemplo de código em C/C++ para ser usado no ambiente Arduino IDE ou similar, utilizando a biblioteca do FreeRTOS disponível para o ESP32.

#### Configuração do Hardware

Defina os pinos utilizados para ADC e DAC:

```c
#define ADC_PIN 34  // Exemplo de pino ADC
#define DAC_PIN 25  // Exemplo de pino DAC
```

#### Inicialização do FreeRTOS

Configure o FreeRTOS para criar uma tarefa de controle proporcional e a tarefa de envio de dados via serial:

```c
#include <Arduino.h>

#define ADC_PIN 34
#define DAC_PIN 25

// Protótipos das funções das tarefas
void TaskControl(void *pvParameters);
void TaskSerial(void *pvParameters);

// Variáveis globais
volatile float setPoint = 1.0; // Exemplo de set-point
volatile float adcValue = 0.0;
volatile float controlSignal = 0.0;

// Parâmetro de controle proporcional
const float Kp = 2.0;

void setup() {
  // Configurações iniciais
  Serial.begin(115200);
  analogReadResolution(12);  // Configurar a resolução do ADC
  analogSetPinAttenuation(ADC_PIN, ADC_11db);  // Configurar a atenuação do ADC
  
  // Criação das tarefas
  xTaskCreatePinnedToCore(TaskControl, "TaskControl", 2048, NULL, 1, NULL, 0);
  xTaskCreatePinnedToCore(TaskSerial, "TaskSerial", 2048, NULL, 1, NULL, 1);
}

void loop() {
  // O loop do Arduino fica vazio, pois usamos o FreeRTOS
}

// Tarefa de Controle Proporcional
void TaskControl(void *pvParameters) {
  const TickType_t xFrequency = pdMS_TO_TICKS(10);  // 10 ms (100 Hz)
  TickType_t xLastWakeTime = xTaskGetTickCount();
  
  while (true) {
    // Ler o valor do ADC
    adcValue = analogRead(ADC_PIN) * (3.3 / 4095.0);  // Converter para tensão
    
    // Calcular o sinal de controle (Controle Proporcional)
    controlSignal = Kp * (setPoint - adcValue);
    
    // Enviar o sinal de controle para o DAC
    dacWrite(DAC_PIN, (int)(controlSignal * 255.0 / 3.3));
    
    // Aguardar até a próxima execução
    vTaskDelayUntil(&xLastWakeTime, xFrequency);
  }
}

// Tarefa de Envio Serial
void TaskSerial(void *pvParameters) {
  while (true) {
    // Enviar os dados via porta serial
    Serial.print("Set-Point: ");
    Serial.print(setPoint);
    Serial.print("\tADC Value: ");
    Serial.print(adcValue);
    Serial.print("\tControl Signal: ");
    Serial.println(controlSignal);
    
    // Aguardar 100 ms antes de enviar novamente
    vTaskDelay(pdMS_TO_TICKS(100));
  }
}
```

### Explicação do Código

1. **Configuração do Hardware**:
   - `ADC_PIN` e `DAC_PIN` são definidos para os pinos usados no ADC e DAC, respectivamente.
   - `analogReadResolution(12)` define a resolução do ADC para 12 bits.
   - `analogSetPinAttenuation(ADC_PIN, ADC_11db)` ajusta a atenuação do ADC para o pino especificado, permitindo leituras de até 3.3V.

2. **Inicialização do FreeRTOS**:
   - `xTaskCreatePinnedToCore` cria duas tarefas: `TaskControl` para o controle proporcional e `TaskSerial` para o envio de dados via serial. As tarefas são atribuídas a diferentes núcleos do ESP32 para melhor desempenho.

3. **Tarefa de Controle Proporcional**:
   - `TaskControl` lê o valor do ADC, calcula o sinal de controle proporcional e envia esse sinal para o DAC.
   - `vTaskDelayUntil(&xLastWakeTime, xFrequency)` garante que a tarefa será executada a cada 10 ms, proporcionando uma frequência de 100 Hz.

4. **Tarefa de Envio Serial**:
   - `TaskSerial` envia os dados do set-point, valor do ADC e sinal de controle via UART a cada 100 ms.

Esse exemplo de código demonstra como usar o FreeRTOS para criar tarefas que executam controle em tempo real e comunicação serial no ESP32. As tarefas são executadas de maneira determinística, garantindo que o controle proporcional ocorra com precisão a cada 10 ms.

---

## Outras opções

* Função [**xTaskCreate()**](xTaskCreate.html);
* Função [**vTaskDelayUntil()**](vTaskDelayUntil.html);
* [Definindo prioridades em tarefas](prioridades.html);

---

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("🌊 Fernando Passold, página criada em 05/05/2024 22:03, atualizada em " + LastUpdated); // End Hiding -->
</script>