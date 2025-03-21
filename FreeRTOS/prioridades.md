# Prioridades na Criação da Tarefa

- [Prioridades na Criação da Tarefa](#prioridades-na-criação-da-tarefa)
  - [Intro](#intro)
  - [Criando Tarefas com Prioridades](#criando-tarefas-com-prioridades)
  - [Alterando a Prioridade de uma Tarefa Existente](#alterando-a-prioridade-de-uma-tarefa-existente)
  - [Obtendo a Prioridade Atual de uma Tarefa](#obtendo-a-prioridade-atual-de-uma-tarefa)
  - [Obtendo o *Handler* de uma Tarefa](#obtendo-o-handler-de-uma-tarefa)
  - [Exemplo Completo](#exemplo-completo)
    - [Explicação do Exemplo](#explicação-do-exemplo)
    - [Considerações](#considerações)
    - [Prática Recomendada](#prática-recomendada)
  - [Outras Opções](#outras-opções)

## Intro

No FreeRTOS, a prioridade de uma tarefa determina a ordem em que as tarefas são escalonadas. Tarefas com prioridades mais altas são escalonadas antes das tarefas com prioridades mais baixas. 

a prioridade de uma tarefa é estabelecida no momento de sua criação através da função `xTaskCreate` ou `xTaskCreatePinnedToCore`. 

A prioridade de uma tarefa é um valor inteiro, onde ==números maiores indicam prioridades mais altas==. 

Além disso, você pode ajustar a prioridade de uma tarefa existente usando a função `vTaskPrioritySet`.

## Criando Tarefas com Prioridades

Ao criar uma tarefa com `xTaskCreate` ou `xTaskCreatePinnedToCore`, você especifica a prioridade com o 5$^o$ dos parâmetros. Por exemplo:

```c
// Criação de uma tarefa com prioridade 1
xTaskCreate(
    TaskFunction,      // 1. Função da tarefa
    "TaskName",        // 2. Nome da tarefa (para fins de depuração)
    stackSize,         // 3. Tamanho da pilha da tarefa
    NULL,              // 4. Parâmetro passado para a função da tarefa
    1,                 // 5. Prioridade da tarefa
    &taskHandle        // 6. Handler da tarefa (opcional)
);
```

Para criar uma tarefa com uma prioridade mais alta, basta usar um valor maior para o parâmetro de prioridade:

```c
// Criação de uma tarefa com prioridade 2 (mais alta)
xTaskCreate(
    TaskFunction,      // Função da tarefa
    "TaskName",        // Nome da tarefa (para fins de depuração)
    stackSize,         // Tamanho da pilha da tarefa
    NULL,              // Parâmetro passado para a função da tarefa
    2,                 // Prioridade da tarefa
    &taskHandle        // Handle da tarefa (opcional)
);
```

## Alterando a Prioridade de uma Tarefa Existente

Para alterar a prioridade de uma tarefa existente, use a função `vTaskPrioritySet`. 

Sintaxe de `vTaskPrioritySet`:

```c
void vTaskPrioritySet(
  TaskHandle_t xTask,
  UBaseType_t uxNewPriority
);
```

- **`xTask`**: Handlre da tarefa cuja prioridade você deseja ajustar. Se `xTask` for `NULL`, a prioridade da tarefa chamadora será ajustada.
- **`uxNewPriority`**: Nova prioridade da tarefa.

Aqui está um exemplo:

```c
// Suponha que taskHandle é o handle da tarefa que queremos alterar a prioridade
vTaskPrioritySet(taskHandle, 3);  // Define a prioridade da tarefa para 3
```

## Obtendo a Prioridade Atual de uma Tarefa

Você pode obter a prioridade atual de uma tarefa usando a função `uxTaskPriorityGet`:

```c
UBaseType_t uxPriority;

// Obtém a prioridade da tarefa
uxPriority = uxTaskPriorityGet(taskHandle);

// Se quiser obter a prioridade da própria tarefa que está executando
uxPriority = uxTaskPriorityGet(NULL);
```

## Obtendo o *Handler* de uma Tarefa

Para ajustar a prioridade de uma tarefa específica, você precisa do *handler* dessa tarefa. Você pode obter o *handler* no momento da criação da tarefa ou posteriormente usando `xTaskGetHandle`.

**Exemplo de obtenção do handle na criação da tarefa:**

```c
TaskHandle_t xHandleTask_LED;

xTaskCreate(Task_LED, "Task_LED", 1024, NULL, 1, &xHandleTask_LED);
```



## Exemplo Completo

Aqui está um exemplo completo que demonstra a criação de três tarefas com diferentes prioridades e como alterar a prioridade de uma tarefa durante a execução.

```c
#include <Arduino.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>

// Protótipos das funções das tarefas
void TaskLowPriority(void *pvParameters);
void TaskMediumPriority(void *pvParameters);
void TaskHighPriority(void *pvParameters);

// Handles das tarefas
TaskHandle_t lowPriorityHandle = NULL;
TaskHandle_t mediumPriorityHandle = NULL;
TaskHandle_t highPriorityHandle = NULL;

void setup() {
  Serial.begin(115200);

  // Criação das tarefas com diferentes prioridades
  xTaskCreate(TaskLowPriority, "LowPriorityTask", 1024, NULL, 1, &lowPriorityHandle);
  xTaskCreate(TaskMediumPriority, "MediumPriorityTask", 1024, NULL, 2, &mediumPriorityHandle);
  xTaskCreate(TaskHighPriority, "HighPriorityTask", 1024, NULL, 3, &highPriorityHandle);
}

void loop() {
  // Loop vazio
}

// Tarefa de baixa prioridade
void TaskLowPriority(void *pvParameters) {
  while (true) {
    Serial.println("Low Priority Task is running");
    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}

// Tarefa de prioridade média
void TaskMediumPriority(void *pvParameters) {
  while (true) {
    Serial.println("Medium Priority Task is running");
    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}

// Tarefa de alta prioridade
void TaskHighPriority(void *pvParameters) {
  while (true) {
    Serial.println("High Priority Task is running");
    // Alterar a prioridade da tarefa de baixa prioridade
    vTaskPrioritySet(lowPriorityHandle, 4);
    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}
```

### Explicação do Exemplo

1. **Criação de Tarefas com Diferentes Prioridades**:
   - `TaskLowPriority` é criada com prioridade 1.
   - `TaskMediumPriority` é criada com prioridade 2.
   - `TaskHighPriority` é criada com prioridade 3.

2. **Execução das Tarefas**:
   - Cada tarefa imprime uma mensagem na porta serial a cada segundo.

3. **Alteração da Prioridade**:
   - A tarefa `TaskHighPriority` altera a prioridade da tarefa `TaskLowPriority` para 4, tornando-a a tarefa de mais alta prioridade no sistema.

### Considerações

- **Prioridade de Tarefas**: Tarefas de maior prioridade "*preemptam*" (interrompem) tarefas de menor prioridade se estiverem prontas para executar.
- **Utilização Responsável**: Use a mudança de prioridades com cuidado para evitar problemas de inversão de prioridade e para garantir que tarefas críticas sejam executadas conforme esperado.
- **Tempo Real**: A configuração de prioridades deve refletir a importância relativa e os requisitos de tempo real de cada tarefa no sistema.

### Prática Recomendada

É recomendado definir prioridades de maneira cuidadosa para evitar problemas de inversão de prioridade, onde tarefas de alta prioridade são indiretamente bloqueadas por tarefas de baixa prioridade. Além disso, evite definir todas as tarefas com a mesma prioridade, a menos que você tenha um motivo específico para isso.

Esse conjunto de exemplos e explicações permite entender como configurar e manipular prioridades de tarefas no FreeRTOS para ESP32.

## Outras Opções

* Função [**xTaskCreate()**](xTaskCreate.html);
* Função [**vTaskDelayUntil()**](vTaskDelayUntil.html);
* [Exemplo de rotina de controle digital](controle_digital_ex1.html).

---

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("🌊 Fernando Passold, página criada em 05/06/2024 23:21, atualizada em " + LastUpdated); // End Hiding -->
</script>

