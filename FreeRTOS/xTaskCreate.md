# Função **xTaskCreate()**

- [Função **xTaskCreate()**](#função-xtaskcreate)
  - [Intro](#intro)
  - [Protótipo da Função](#protótipo-da-função)
    - [Parâmetros](#parâmetros)
    - [Valor de Retorno](#valor-de-retorno)
  - [Pilha da Tarefa](#pilha-da-tarefa)
    - [Sugestões para Definir o Tamanho da Pilha](#sugestões-para-definir-o-tamanho-da-pilha)
  - [Parâmetro Passado para a Função da Tarefa](#parâmetro-passado-para-a-função-da-tarefa)
  - [Exemplo Completo](#exemplo-completo)
    - [Explicação do Exemplo](#explicação-do-exemplo)
    - [Conclusão](#conclusão)
  - [Outras opções](#outras-opções)

[🤘](https://www.youtube.com/watch?v=avISxwo8-Ao)

## Intro

A função `xTaskCreate()` é usada para criar uma nova tarefa no FreeRTOS. Essa função inicializa a tarefa, aloca memória para sua pilha e adiciona a tarefa à lista de tarefas prontas para serem executadas pelo escalonador.

## Protótipo da Função

```c
BaseType_t xTaskCreate(
    TaskFunction_t pvTaskCode,
    const char * const pcName,
    const uint16_t usStackDepth,
    void *pvParameters,
    UBaseType_t uxPriority,
    TaskHandle_t *pxCreatedTask
);
```

### Parâmetros

1. **`pvTaskCode`**: Um ponteiro para a função que implementa a tarefa. Esta função deve seguir o seguinte protótipo:
   
   ```c
   void TaskFunction(void *pvParameters);
   ```
```
   
2. **`pcName`**: Um nome descritivo para a tarefa. Este nome é usado apenas para fins de depuração.

3. **`usStackDepth`**: O tamanho da pilha da tarefa, em palavras (não bytes). Por exemplo, se `configSTACK_DEPTH_TYPE` for definido como `uint16_t` e o tamanho da palavra for 4 bytes, um `usStackDepth` de 100 significa que a pilha pode armazenar 100 palavras, ou seja, 400 bytes.

4. **`pvParameters`**: Um ponteiro para os parâmetros que serão passados para a tarefa. Este valor é passado como argumento para a função da tarefa quando ela é executada.

5. **`uxPriority`**: A prioridade da tarefa. Tarefas com prioridades mais altas preemptam tarefas com prioridades mais baixas.

6. **`pxCreatedTask`**: Um ponteiro para o handle da tarefa criada. Este handle pode ser usado para referenciar a tarefa em outras chamadas do FreeRTOS. Este parâmetro é opcional e pode ser `NULL`.

### Valor de Retorno

`xTaskCreate()` retorna `pdPASS` (1) se a tarefa foi criada com sucesso. Caso contrário, retorna `errCOULD_NOT_ALLOCATE_REQUIRED_MEMORY` (0) se não houver memória suficiente disponível.

## Pilha da Tarefa

A pilha da tarefa é uma área de memória alocada especificamente para armazenar dados locais, variáveis automáticas e contextos de função durante a execução da tarefa. Cada tarefa no FreeRTOS tem sua própria pilha separada, que é usada para:

- Armazenar variáveis locais da tarefa.
- Armazenar o contexto da tarefa (registradores da CPU) quando a tarefa é interrompida ou trocada pelo escalonador.
- Armazenar os parâmetros passados para funções chamadas pela tarefa.

### Sugestões para Definir o Tamanho da Pilha

O tamanho da pilha é crítico para a estabilidade do sistema. Uma pilha muito pequena pode causar estouro de pilha, enquanto uma pilha muito grande pode desperdiçar memória. Algumas sugestões para definir o tamanho da pilha são:

1. **Analisar o Código da Tarefa**:
   - Verifique as variáveis locais e o tamanho dos arrays alocados na pilha.
   - Considere o número e a profundidade das chamadas de função.

2. **Uso de Ferramentas de Análise**:
   - Utilize funções do FreeRTOS como `uxTaskGetStackHighWaterMark()` para monitorar o uso da pilha durante a execução e ajustar o tamanho conforme necessário.

3. **Teste de Estresse**:
   - Execute a tarefa sob condições de carga máxima para garantir que a pilha é suficiente.

4. **Referência a Exemplos**:
   - Use exemplos de configuração de tarefas similares como referência para o tamanho da pilha.

## Parâmetro Passado para a Função da Tarefa

O parâmetro `pvParameters` permite que você passe dados para a tarefa quando ela é criada. Este parâmetro pode ser usado para:

- Passar configurações iniciais para a tarefa.
- Diferenciar comportamentos de múltiplas instâncias da mesma tarefa.
- Compartilhar estruturas de dados ou informações entre a tarefa e outras partes do programa.

## Exemplo Completo

Aqui está um exemplo que demonstra a criação de duas tarefas com diferentes prioridades e uso do parâmetro `pvParameters`.

​```c
#include <Arduino.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>

// Protótipos das funções das tarefas
void TaskFunction1(void *pvParameters);
void TaskFunction2(void *pvParameters);

// Estrutura de dados para passar como parâmetro para a tarefa
typedef struct {
  int taskId;
  const char *taskMessage;
} TaskParameters;

void setup() {
  Serial.begin(115200);

  // Definir os parâmetros para as tarefas
  TaskParameters task1Params = {1, "Task 1 is running"};
  TaskParameters task2Params = {2, "Task 2 is running"};

  // Criação das tarefas com diferentes prioridades e parâmetros
  xTaskCreate(TaskFunction1, "Task1", 1024, &task1Params, 1, NULL);
  xTaskCreate(TaskFunction2, "Task2", 1024, &task2Params, 2, NULL);
}

void loop() {
  // Loop vazio
}

// Implementação da TaskFunction1
void TaskFunction1(void *pvParameters) {
  TaskParameters *params = (TaskParameters *) pvParameters;

  while (true) {
    Serial.print("Task ID: ");
    Serial.print(params->taskId);
    Serial.print(", Message: ");
    Serial.println(params->taskMessage);
    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}

// Implementação da TaskFunction2
void TaskFunction2(void *pvParameters) {
  TaskParameters *params = (TaskParameters *) pvParameters;

  while (true) {
    Serial.print("Task ID: ");
    Serial.print(params->taskId);
    Serial.print(", Message: ");
    Serial.println(params->taskMessage);
    vTaskDelay(pdMS_TO_TICKS(500));
  }
}
```

### Explicação do Exemplo

1. **Definição de Parâmetros**:
   - `TaskParameters` é uma estrutura usada para passar múltiplos parâmetros para as tarefas.

2. **Criação de Tarefas**:
   - `xTaskCreate(TaskFunction1, "Task1", 1024, &task1Params, 1, NULL);`
   - `xTaskCreate(TaskFunction2, "Task2", 1024, &task2Params, 2, NULL);`
   - As tarefas `TaskFunction1` e `TaskFunction2` são criadas com diferentes prioridades e recebem seus respectivos parâmetros.

3. **Implementação das Funções das Tarefas**:
   - Cada tarefa lê seus parâmetros, imprime uma mensagem na porta serial e depois se suspende por um período de tempo.

### Conclusão

A função `xTaskCreate()` é fundamental para a criação de tarefas no FreeRTOS. A pilha da tarefa é crucial para o armazenamento de variáveis locais e contextos de função. O parâmetro passado para a função da tarefa permite a passagem de dados personalizados para cada instância da tarefa, proporcionando flexibilidade e modularidade ao design do sistema. Ao definir o tamanho da pilha, é importante considerar o uso real da pilha pela tarefa para evitar problemas de estouro e otimizar o uso da memória do sistema.

## Outras opções

* Função [**vTaskDelayUntil()**](vTaskDelayUntil.html);
* [Definindo prioridades em tarefas](prioridades.html);
* [Exemplo de rotina de controle digital](controle_digital_ex1.html).

---

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("🌊 Fernando Passold, página criada em 05/06/2024 23:44, atualizada em " + LastUpdated); // End Hiding -->
</script>