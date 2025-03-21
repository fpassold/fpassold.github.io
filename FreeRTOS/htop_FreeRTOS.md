# <font color="blue">"**htop**"</font> no FreeRTOS

- ["**htop**" no FreeRTOS](#htop-no-freertos)
  - [Intro](#intro)
  - [1. **Funções de Monitoramento do FreeRTOS**](#1-funções-de-monitoramento-do-freertos)
      - [`uxTaskGetSystemState()`](#uxtaskgetsystemstate)
      - [`vTaskGetRunTimeStats()`](#vtaskgetruntimestats)
  - [2. **Integrando com o Tracealyzer**](#2-integrando-com-o-tracealyzer)
  - [3. **Utilização do SystemView**](#3-utilização-do-systemview)
    - [Exemplo de Implementação Básica](#exemplo-de-implementação-básica)
  - [Conclusão](#conclusão)


## Intro

No FreeRTOS, não há uma ferramenta integrada diretamente comparável ao `htop` do Linux, que monitora a execução de tarefas e a carga do sistema em tempo real. No entanto, existem várias abordagens e ferramentas que você pode usar para monitorar a execução das tarefas e a carga do sistema em um ambiente FreeRTOS. Algumas dessas ferramentas são fornecidas pela própria biblioteca do FreeRTOS, enquanto outras são utilitários de terceiros.

## 1. **Funções de Monitoramento do FreeRTOS**

#### `uxTaskGetSystemState()`

Essa função permite obter informações sobre todas as tarefas do sistema, como seu estado, prioridade, e uso da pilha. Pode ser usada para criar seu próprio monitor de tarefas.

Exemplo de uso:

```c
void vTaskList(char *pcWriteBuffer);
```

Você pode usar `vTaskList()` para obter uma lista das tarefas e suas informações em um buffer de saída.

```c
void printTaskList() {
    char buffer[1024];
    vTaskList(buffer);
    Serial.print(buffer);
}
```

Chame `printTaskList()` em algum ponto do seu código (por exemplo, no loop principal) para imprimir a lista de tarefas.

#### `vTaskGetRunTimeStats()`

Essa função fornece estatísticas de tempo de execução para todas as tarefas do sistema, mostrando o tempo de CPU utilizado por cada tarefa.

Exemplo de uso:

```c
void vTaskGetRunTimeStats(char *pcWriteBuffer);
```

Assim como `vTaskList()`, `vTaskGetRunTimeStats()` preenche um buffer de saída com informações sobre o tempo de execução das tarefas.

```c
void printRunTimeStats() {
    char buffer[1024];
    vTaskGetRunTimeStats(buffer);
    Serial.print(buffer);
}
```

Chame `printRunTimeStats()` periodicamente para monitorar a carga do sistema.

## 2. **Integrando com o Tracealyzer**

[Tracealyzer](https://percepio.com/tracealyzer) é uma ferramenta poderosa de rastreamento e análise para FreeRTOS que fornece uma visão detalhada do comportamento do sistema em tempo real. Com o Tracealyzer, você pode visualizar:

- Diagrama de tempo de execução das tarefas.
- Uso da CPU por tarefa.
- Diagrama de chamadas de funções.
- Interações entre tarefas e interrupções.

Para usar o Tracealyzer, você precisa integrar a biblioteca de rastreamento com o seu projeto FreeRTOS e capturar os dados de rastreamento. A Percepio fornece documentação detalhada sobre como fazer isso.

## 3. **Utilização do SystemView**

[SEGGER SystemView](https://www.segger.com/products/development-tools/systemview/) é outra ferramenta de rastreamento e análise que pode ser usada com FreeRTOS. SystemView captura e analisa eventos do sistema em tempo real, oferecendo insights detalhados sobre o comportamento das tarefas e a utilização da CPU.

### Exemplo de Implementação Básica

Aqui está um exemplo básico de como configurar a coleta de estatísticas de tempo de execução usando as funções do FreeRTOS:

```c
#include <Arduino.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>

// Funções das tarefas
void Task1(void *pvParameters);
void Task2(void *pvParameters);

void setup() {
    Serial.begin(115200);

    // Criação das tarefas
    xTaskCreate(Task1, "Task1", 1024, NULL, 1, NULL);
    xTaskCreate(Task2, "Task2", 1024, NULL, 2, NULL);

    // Configuração do temporizador de tempo de execução
    vConfigureTimerForRunTimeStats();
}

void loop() {
    // Imprimir estatísticas de tempo de execução a cada 5 segundos
    printRunTimeStats();
    delay(5000);
}

// Função da Tarefa 1
void Task1(void *pvParameters) {
    while (true) {
        // Código da tarefa
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

// Função da Tarefa 2
void Task2(void *pvParameters) {
    while (true) {
        // Código da tarefa
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

void printRunTimeStats() {
    char buffer[1024];
    vTaskGetRunTimeStats(buffer);
    Serial.print(buffer);
}

// Configuração do temporizador de tempo de execução
void vConfigureTimerForRunTimeStats() {
    // Configurar um temporizador de hardware para incrementar a contagem de ticks
    // Pode variar dependendo do hardware específico
}
```

## Conclusão

Embora o FreeRTOS não forneça uma ferramenta integrada semelhante ao `htop`, ele oferece várias funções para monitorar tarefas e a utilização da CPU. Ferramentas de terceiros, como Tracealyzer e SystemView, podem proporcionar uma análise ainda mais detalhada e visual do comportamento do sistema. Utilizando essas ferramentas, você pode obter uma visão abrangente da execução das tarefas e da carga do sistema em um ambiente FreeRTOS.

----

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("🌊 Fernando Passold, página criada em 06/06/2024 01:06, atualizada em " + LastUpdated); // End Hiding -->
</script>