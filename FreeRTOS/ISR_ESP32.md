# ISRs no ESP32

## No way FreeRTOS...

Existem alguns problemas ao aumentar a taxa de *tick* do FreeRTOS acima do padrão de 1000 Hz [[1]](#ref1). 1000Hz já é algo elevado para uma taxa de tick RTOS numa placa ESP32! Além de aumentar a sobrecarga de troca de contexto para tarefas de trabalho, muitos códigos do FreeRTOS usam semântica como **vTaskDelay**(1000 / portTICK_PERIOD_MS) e ==há problemas se portTICK_PERIOD_MS se tornar menor que 1!==

## ISR por overflow de timer

[ESP\_Angus](https://www.esp32.com/memberlist.php?mode=viewprofile&u=1923&sid=5ef6447956402dd9b59d4bd48e8159a3) sugere trabalhar como interrupções controladores por temporizadores (igual ao que já realizamos com placas Arduino Uno).

Idéia:

- Crie um semáforo para distinguir entre a interrupção do temporizador e da tarefa onde você faria o trabalho pesado real da sua rotina rápida.
- Associe um dos cores do processador para a sua tarefa rápida com prioridade máxima no sistema.

Algo como:

```C++
xTaskCreatePinnedToCore(sample_timer_task, "sample_timer", 4096, NULL, configMAX_PRIORITIES - 1, NULL, 1);
```

No código da task, configure o temporizador para 400 Hz e registre uma interrupção do temporizador (isso garante que ele fique na mesma CPU da tarefa, o que não é essencial, mas aumenta a chance de um tempo de preempção mais curto):

```C++
static SemaphoreHandle_t timer_sem;

void sample_timer_task(void *param)
{
   timer_sem = xSemaphoreCreateBinary();
   
   // timer group init and config goes here (timer_group example gives code for doing this)
   
   timer_isr_register(timer_group, timer_idx, timer_isr_handler, NULL, ESP_INTR_FLAG_IRAM, NULL);

  while (1) {
     xSemaphoreTake(timer_sem, portMAX_DELAY);
     
     // sample sensors via i2c here      
     
     // push sensor data to another queue, or send to a socket...
  }
}

void IRAM_ATTR timer_isr_handler(void *param)
{
    static BaseType_t xHigherPriorityTaskWoken = pdFALSE;
    
     TIMERG0.hw_timer[timer_idx].update = 1;
     // any other code required to reset the timer for next timeout event goes here
    
    xSemaphoreGiveFromISR(xSemaphore, &xHigherPriorityTaskWoken);
    if( xHigherPriorityTaskWoken) {
        portYIELD_FROM_ISR(); // this wakes up sample_timer_task immediately
    }
}
```

**Obs.:** Trate o seguinte como pseudocódigo em vez de algo que você pode usar como está.

O código acima funciona assim:

* A tarefa de amostragem do sensor é bloqueada para obter o semáforo. Enquanto estiver bloqueado, outras tarefas podem ser executadas neste núcleo.
* Quando acontece a interrupção do timer (configurado para 400Hz), ele libera ("dá") o semáforo. Isto irá ativar a tarefa de maior prioridade que está bloqueando o semáforo (a tarefa de amostragem). Ao chamar **portYIELD_FROM_ISR **, esta tarefa será executada imediatamente, sem necessidade de esperar que um tick expire.
* A tarefa de amostragem é executada, pois tem a prioridade mais alta no sistema, nada(*) pode antecipá-la na CPU. Pode ser necessário bloquear também a espera por interrupções I2C, mas esse código também ativará a tarefa imediatamente por meio de **portYIELD_FROM_ISR**.
* Quando terminar, a tarefa de amostragem bloqueará o semáforo novamente e permitirá que outras tarefas sejam executadas nesta CPU (ou, se a amostragem for lenta, ela será executada imediatamente, pois o semáforo já foi fornecido - mas obviamente você deseja evitar isso!)

Isso pode parecer muito trabalhoso em comparação com uma abordagem não-RTOS (o que você também poderia fazer, se executasse o RTOS em um núcleo e amostrasse sensores no outro núcleo. Embora eu não aconselhe fazer isso). O que é realmente bom é que o padrão acima para comportamento em tempo real é tudo que você precisa para garantir que esses eventos sejam executados em tempo real. Em qualquer outro lugar você pode fazer o que quiser sem precisar se preocupar com tarefas que atrapalham o tempo da sua seção crítica de tempo (*).

> (*) Isso não é totalmente verdade, pois interrupções e qualquer coisa que desabilite o agendador ainda tirarão esta tarefa da CPU. Mas geralmente são muito rápidos, a única exceção que consigo pensar é qualquer coisa que grave no flash SPI.

A própria Espressif recomanda o uso de [**ESP Timer (High Resolution Timer)**](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/system/esp_timer.html#esp-timer-high-resolution-timer). Desta forma, seria possível executar taskj síncronas a com [taxas de amostragem próximas de 50 $\mu$s ($f_s \cong$ 20 KHz)](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/system/esp_timer.html#timeout-value-limits).

## Temporizadores do ESP



## xTaskCreatePinnedToCore()

Sintaxe: exemplos:

```C++
xTaskCreatePinnedToCore(TaskRunningOnAppCore, 	// 1.
                        "TaskOnApp",			// 2. 
                        2048, 					// 3.
                        NULL, 					// 4.
                        4, 						// 5.
                        NULL,					// 6.
                        APP_CPU_NUM);			// 7.
```

**xTaskCreatePinnedToCore()** é utilizada para criar tasks (as “multiplas mains” da sua aplicação) e adicionalmente assinalar ou não uma afinidade por núcleo, que é o último argumento que a função leva, percebam que foram criadas duas tasks, cada uma com afinidade em um dos núcleos, para quem não lembra vamos refrescar a memória sobre o significado dos demais parâmetros [[2]](#ref2):

1. O primeiro parâmetro é a função principal da sua task, uma função tipicamente em um *loop* infinito, embora ela possa retornar, esses casos não são tão comuns, perceba que o argumento nesse caso são basicamente o nome das funções que estão antes de *setup()* e *loop()*;
2. O segundo parâmetro é um nome para essa task, sendo muito útil para fazer debug, além de ser usado pelo componente de trace do IDF (que podemos falar num próximo artigo);
3. O terceiro parâmetro é destinado ao tamanho de pilha para essa task, toda aplicação seja ela uma task ou bare-metal (sem sistema operacional) possui um espaço de pilha usado para alocação de variáveis locais, portanto quanto mais variáveis locais você alocar dentro task, ou quanto mais neveis de função são chamados, maior esse valor, a unidade é em **bytes** para o caso do ESP32;
4. O quarto parâmetro é o argumento para ser passado a task, toda task aceita um argumento do tipo (void *) sendo ele muito útil quando queremos usar uma mesma task para lidar com diferentes contextos;
5. O parâmetro a seguir(quinto) é a prioridade dessa task, tenha em mente sobre o funcionamento do algoritmo de preempção do FreeRTOS, quanto mais alto esse valor, maior a prioridade da task, o RTOS do ESP32 oferece até 25 níveis de prioridade;
6. O sexto parâmetro é um local para guardar o Identificador único para essa task, raramente usado, pois o RTOS possui API para obter o ID de uma task depois que ela é criada;
7. E o último parâmetro (sétimo) é a afinidade dessa task, podendo ela ter afinidade com a **PRO_CPU**, com a **APP_CPU**, ou passe **tskNO_AFFINITY** caso queira que o RTOS decida em quais núcleos essa task vai rodar, lembrando que outros valores são considerados inválidos e a API vai retornar erro.





Ref.: 

* <a name="ref1">[1]</a> [Espressif / Discussion Forum → Increasing RTOS tick rate > 1000Hz](https://www.esp32.com/viewtopic.php?t=1341) (acessado em 07/06/2024).
* <a name="ref2">[2]</a> [ESP32 – Lidando com Multiprocessamento – Parte II](https://embarcados.com.br/esp32-lidando-com-multiprocessamento-parte-ii/), Felipe Neves, 20/01/202 (acessado em 07/06/2024).

----

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("🌊 Fernando Passold, página criada em 07/06/2024, atualizada em " + LastUpdated); // End Hiding -->
</script>