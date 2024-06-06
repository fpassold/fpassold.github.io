# Função **vTaskDelayUntil()**

A função `vTaskDelayUntil()` é usada no FreeRTOS para criar **tarefas síncronas** que precisam ser executadas em intervalos regulares e precisos. Esta função permite que uma tarefa seja suspensa até que um período específico tenha decorrido desde a última vez que a tarefa foi executada. É especialmente útil para tarefas que precisam ser executadas periodicamente, como as que monitoram sensores ou controlam atuadores.

## Sintaxe:

**vTaskDelayUntil(** \<pxPreviousWakeTime>, \<xTimeIncrement> **);**

#### Parâmetros da Função

1. **`pxPreviousWakeTime`**: Um ponteiro para uma variável do tipo `TickType_t` que armazena o último instante em que a tarefa foi executada. Esta variável deve ser inicializada com o valor retornado por `xTaskGetTickCount()` antes da primeira chamada para `vTaskDelayUntil()`. Nas chamadas subsequentes, o FreeRTOS atualiza automaticamente essa variável.
2. **`xTimeIncrement`**: O intervalo de tempo em ticks do sistema que a tarefa deve esperar. Este valor especifica o período de repetição da tarefa.

#### Como Funciona

- **Inicialização**: Antes da primeira chamada para `vTaskDelayUntil()`, você deve inicializar a variável `xLastWakeTime` com o valor atual do tick count do sistema, obtido através de `xTaskGetTickCount()`.
- **Primeira Chamada**: Na primeira chamada, a tarefa é suspensa por `xTimeIncrement` ticks a partir do momento em que `xLastWakeTime` foi inicializada.
- **Chamadas Subsequentess**: Em cada chamada subsequente, a função calcula o próximo instante de execução com base em `xLastWakeTime` e `xTimeIncrement`. A tarefa é suspensa até que este instante seja atingido, garantindo que a periodicidade da tarefa seja mantida independentemente do tempo de execução da tarefa.

### Exemplo de Uso

Vamos revisar o exemplo de uma tarefa que faz um LED piscar a 1 Hz usando `vTaskDelayUntil()`:

```c
void Task_LED(void *pvParameters) {
  // Inicializar o último tempo de despertar com o tick atual
  TickType_t xLastWakeTime = xTaskGetTickCount();
  // Definir o intervalo de tempo (500 ms para 1 Hz)
  const TickType_t xFrequency = pdMS_TO_TICKS(500);

  while (true) {
    // Alternar o estado do LED
    digitalWrite(LED_PIN, !digitalRead(LED_PIN));
    // Aguardar até o próximo ciclo
    vTaskDelayUntil(&xLastWakeTime, xFrequency);
  }
}
```

### Detalhamento do Funcionamento

1. **Inicialização**:
   - `TickType_t xLastWakeTime = xTaskGetTickCount();`
     - `xLastWakeTime` é inicializado com o tick count atual do sistema.
   
2. **Primeira Execução**:
   - `vTaskDelayUntil(&xLastWakeTime, xFrequency);`
     - Na primeira chamada, a tarefa será suspensa até que `xFrequency` ticks (500 ms) tenham passado desde a inicialização de `xLastWakeTime`.
   
3. **Chamadas Subsequentess**:
   - `vTaskDelayUntil(&xLastWakeTime, xFrequency);`
     - Em cada chamada subsequente, `vTaskDelayUntil()` calcula o próximo tempo de execução desejado como `xLastWakeTime + xFrequency`.
     - Se o próximo tempo de execução for menor ou igual ao tick count atual, a função retorna imediatamente.
     - Se não, a tarefa é suspensa até que o tick count atinja o próximo tempo de execução.
     - `xLastWakeTime` é atualizado automaticamente com o tempo de despertar atual para a próxima iteração.

### Efeito no Escalonador de Tarefas

- **Determinismo**: `vTaskDelayUntil()` ajuda a criar um comportamento determinístico nas tarefas periódicas. A função garante que as tarefas sejam executadas em intervalos precisos, mantendo a periodicidade mesmo se a tarefa anterior demorar mais do que o esperado.
- **Eficiência**: Ao suspender a tarefa, o escalonador pode atribuir tempo de CPU a outras tarefas, melhorando a eficiência do sistema.
- **Prioridade**: A função não afeta diretamente a prioridade das tarefas, mas ajuda a coordenar a execução de tarefas de alta prioridade que precisam ser executadas em intervalos regulares.

### Comparação com `vTaskDelay()`

- **`vTaskDelay()`**: Suspende a tarefa por um número especificado de ticks do sistema a partir do momento em que a função é chamada. Isso pode introduzir variação no período se a tarefa anterior demorar mais do que o esperado.
- **`vTaskDelayUntil()`**: Suspende a tarefa até um tempo absoluto, garantindo que a periodicidade seja mantida independentemente do tempo de execução da tarefa anterior.

### Conclusão

`vTaskDelayUntil()` é uma função poderosa para criar tarefas periódicas síncronas no FreeRTOS, garantindo que as tarefas sejam executadas em intervalos precisos. Isso é crucial em sistemas de tempo real onde a precisão e a previsibilidade são essenciais.

## Outras Opções:

* Função [**xTaskCreate()**](xTaskCreate.html);
* [Definindo prioridades em tarefas](prioridades.html);
* [Exemplo de rotina de controle digital](controle_digital_ex1.html).

---

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("🌊 Fernando Passold, página criada em 05/06/2024 22:03, atualizada em " + LastUpdated); // End Hiding -->
</script>