# Exp 1) Síntese de Senóide usando Arduino

### Objetivos

1. Aprender a lidar com uma rotina ISR para gerar um simples sinal senoidal analógico usando placa [Arduino Uno Rev3](https://store.arduino.cc/products/arduino-uno-rev3/?_gl=1%2A3if67k%2A_ga%2AMzE1MzQ1ODI0LjE3MjQzNzk2OTA.%2A_ga_NEXN8H46L5%2AMTcyNDM3OTY4OS4xLjEuMTcyNDM3OTkwMi4wLjAuMTYxODUxODU0Ng..%2A_fplc%2Ab3hjbWdNQ1lubkFQMERaVCUyQmFjV2glMkZsSVV4elJVeHJPUUJUajRtZUJUSjZhMldEejdkNXVucExabW40WVU3bk9sd3MwaiUyQlZTaUNBOWFZeVNyNnpPeUxzQVpRR3k1eUxsVGpDV0RVYVhkVFFGSEhCWlMzek03Qmx0bzNSak13JTNEJTNE%2A_gcl_au%2AMTgyMTgzMzkzNy4xNzI0Mzc5Njk5%2AFPAU%2AMTgyMTgzMzkzNy4xNzI0Mzc5Njk5), inicialmente usando sua saída PWM e depois usando um módulo externo conversor de Analógico para Digital, ou simplesmente "DAC".
2. Notar como a taxa de amostragem e pontos usados para síntetizar um sinal podem afetar o sinal analógico sendo sintetizado.

### Base Teórica

A princípio o estudante deverá aprender a codificar uma rotina "ISR", ou ***Interrupt Service Routine***. 

Uma ISR é uma rotina de software que se apoia em recursos de hardware para responder à interrupções. No caso, a idéia é programar o *overflow* de um temporizador livre da placa Arduíno Uno para ativar a rotina ISR (o *overflow* gera a interrupção) obdecendo certo intervalo de tempo, a taxa de amostragem desejada. Então inicialmente devemos selecionar um *timer* disponível no Arduino Uno e programar os registradores associados para realizar o que se chama de "CTC" (***Clear Timer on Compare Match***). 

Note que uma rotina ISR se assemelha a uma *function* tradicional de um programa em C, com a diferença de que não existe uma chamada no código explícita para a mesma. Quando o hardware do microcontrolador atingir o final da contagem (*overflow*) programado de acordo com a taxa de amostragem desejada, o próprio hardware gera a interrupção e executa a rotina ISR associada com este tipo de interrupção. O microcontrolador executa o código dentro desta rotina (tratamento da interrupção) e quando termina de executar estar rotina, volta automaticamente para o ponto do código que estava sendo executado instantes antes da interrupção. Para tanto, usa uma pilha de memória interna para estocar o endereço de retorno no momento em que ocorreu a interrupção. Isto significa que um microcontrolador pode atender até certo número de interrupções sem terminar de execugtar o código de nenhuma delas até o limite da sua pilha. Note que normalmente se pode definir o nível de prioridade para cada interrupção. Assim, caso ocorram mais de uma interrupção, o microcontrolador opta por tratá-las seguindo a ordem de prioridade estabelida na programação do código completo. Dependendo da aplicação, no código de tratamento de uma interrupção pode constar um comando para inibir temporariamente novas interrupções. Mas isto implica que qualquer outra interrupção ocorrendo depois disto, será simplesmente ignorada. 

Note que uma rotina de tratamento de interrupção realiza um mínimo de processamento possível à fim de liberar o mais rapidamente possível o microcontrolador para a sequência de execução do seu código tradiconal. Isto significa que **nunca** esta rotina deve ser usada para atualizar um display ou enviar dados para um periférico lento. Um display LCD comum exige que certo para ser gravado no mesmo, seja apresentado no seu barramento de comunicação durante um intervalo de tempo mínimo para que possa ser reconhido (corresponde a taxa de transferência de dados para sua memória RAM). Ocorre que se o usuário pretende enviar muitos dados para um display, muito possivelmente o período de tempo total exigido para completar a escrita de todos estes dados num display, supere o próprio período de amostragem definido para a rotina ISR. Neste caso, ou vai ocorrer uma quebra na sua pilha de *Stack Pointer* e possivelmente a ativação do *watchdog* (com reboot automático do soft no microcontrlador) ou algumas chamadas ISR deixarão de ser executadas compromentendo a execução da tarefa para a qual o microcontrolador foi planejado. Então a rotina ISR neste caso, basicamente só faz algo como (segue pseudo-código):

```c
ISR(TIMERx_COMPA_vect){
    valor = analogRead(analogPin);
    // analogWrite(pino_PWM, y);
    DAC_found = dac.setVoltage(valor, false);
}
```

Como o código um sistema que trabalha com ISR nunca realiza chamada explícita à esta função, a mesma começa à ser executada assim que o tratamento de interupções for liberado no código do microcontrolador, função `interrupts();`. No caso do Arduino Uno ficaria algo como:

```c++
/***
Comentários iniciais... blá...blá...blá...
***/

// Normalmente associação de variáveis ou constantes com pinos do microcontrolador e hardware externo
const byte PWM = 5;		// saída PWM porta 5 à 980 Hz.
const LED = 10;			// led ativo alto ligado ao pino 10

// Declarações (e inicializações) de variáveis globais

// Protótipo das funções ou funções previstas 
void Init(){
    // inicializa variáveis importantes !?
}

// Outras rotinas/funções -- assumindo programação modular

// Tratamento de interrupção do tipo CTC associado com certo timer
ISR(TIMERx_COMPA_vect){
    // o código da rotina de tratamento de interrupção
    ...
}

void setup() {
  // put your setup code here, to run once:
  // coloque seu código de configuração aqui, será executado apenas esta vez:
  // Definições de uso dos pinos da placa (entrada/saída):
  pinMode(LED, OUTPUT);
  digitalWrite(LED, HIGH);
  // inicializa porta PWM de saída (se usado):
  analogWrite(PWM, 0);
    
    
  // Programa timer x para uso com ISR:
  // initialize timer x
  noInterrupts();  // disable all interrupts
  TCCRxA = 0;      // set entire TCCRxA register to 0
  TCCRxB = 0;      // same for TCCRxB
  TCNTx = 0;       // initialize counter value to 0
  // set compare match register for 100 Hz increments
  OCRxA = 155;             // set counter up to 155
  TCCRxA |= (1 << WGMx1);  // turn on CTC mode
  // setting prescaler with 1024
  TCCRxB |= (1 << CSx2) | (1 << CSx1) | (1 << CSx0);
  TIMSKx |= (1 << OCIExA);  // enable timer2 compare interrupt
  interrupts();             // enable all interrupts
    
    
  // Eventualmente inicializa porta serial:
  Serial.begin(115200);     //  porta serial à 115 Kbps
  while (!Serial) {
    ;  // Aguarda até que a porta serial esteja pronta - normalmente 10 ms
  }
  // Mensagens iniciais num display ou via porta serial
}

void loop() {
  // put your main code here, to run repeatedly:
  // coloque seu código principal aqui, a parte que é executada repetidamente:
  // Eventualmente esta seção pode ficar vazia, já que a ISR já está sendo executada.  
}
```

A página ["Arduino & Interrupções"](https://fpassold.github.io/Lab_Controle_2/Arduino_Int/Arduino_Int.html) explica como se trabalha com ISRs do tipo CTC no Arduino Uno. Recomenda-se sua leitura. O estudante pode implementar o código presente no final desta página para comprovar o funcionamento de rotinas ISR.

A página ["Gerador de Onda Senoidal de 40 Hz"](https://fpassold.github.io/Lab_Controle_2/Projeto_Final/gerador_senoidal.html) traz um exemplo de como implementar uma rotina ISR para gerar uma onda senóidal de 40 Hz. Sugere-se que o código disponibilizado nesta página seja testado pelo estudante. **Mas...** a onda senoidal de saída é gerada através de saída PWM padrão do Arduíno, usando a função `analogWrite(pino_PWM, y)`. Isto significa que a saída digital no formato PWM exige filtragem para tentar ser semelhante ao sinal que seria gerado um verdadeiro conversor de sinal de digital para analógico. 

A placa Arduino Uno incorpora conversor de sinal analógico para digital ("***ADC***"), de 10-bits, **mas** não traz consigo nenhum conversor de digital para analógico (""***DAC***"), motivo pelo qual vamos usar o módulo externo **MPC 4725**, um DAC de 12-bits originalmente disponibilizado pela Adafruit. Este módulo "conversa" com o Arduino (ou outras placas) usando padrão I2C. Então será necessário incluir bibliotecas da Adafruit para poder trabalhar com este módulo. 

A página ["Trabalhar com o Módulo DAC"](https://fpassold.github.io/Lab_Controle_2/PID_Digital/modulo_DAC.html) explica como baixar, instalar e usar a biblioteca de software da Adafruit para poder acessar este módulo. Note que recomenda-se usar a rotina padrão `void setup()`para tentar identificar de forma automática o endereço I2C deste módulo.

**Atenção**: reparece que o módulo DAC MPC 4725 é de 12-bits, isto significa que trabalha apenas com argumento de entrada variando entre $[0, 4025]$ ($2^{12}=4096$), então você deve "enquadrar" a onda senoidal nesta faixa para serem gerados sinais de saída entre $[0, 5]$ Volts. Note que não é possível geral tensão negativa com este módulo. Para isto seria necessário acomplar na saída Analógica deste módulo um filtro passa-baixas (para evitar geração de sinais de altas frequências ocasionadas por replicação do espectro do sinal original em frequências múltiplas da usada para síntese/amostragem) $+$ amplificar operacional para dar ganho e definir o *offset* desejado para a tensão de saída variar entre $[-5, +5]$ Volts por exemplo.

## Parte Prática

### 1. Primeira Tarefa sugerida:

Implemente o código final presente na página página ["Arduino & Interrupções"](https://fpassold.github.io/Lab_Controle_2/Arduino_Int/Arduino_Int.html) para entender como funciona uma rotina ISR. Este código implementa 3 rotinas ISR para:

* Fazer **piscar um led à 2 Hz**, isto é, ele fica aceso durante 1 segundo e apagado outro tanto 1 segundo.
  Uso de iterrupção associado com o *Timer1*, operando na frequência de 1 Hz; é realizado um "*toggle*" no pino 13 (do Led).
* Geração de uma **onda quadrada de 1 KHz** (tensão de saída entre 0 e 5V).
  Foi usada uma interrupção associada com o *Timer0*, operando na frequencia de 2 KHz; é realizado um "*toggle*" no pino 8, portanto a frequência de saída corresponde à metade da programada via interrupção.
* Geração de **outra onda quadrada vibrando à 4 KHz**.
  Neste caso, foi adotada interrupção associada com o *Timer2* operando à 8 KHz; um "*toggle*" foi realizado no pino 9, onde será verificada então uma onda quadrada gerada à 4 KHz.

### 2. Segunda Tarefa Sugerida:

Implemente o código final presente na página ["Gerador de Onda Senoidal de 40 Hz"](https://fpassold.github.io/Lab_Controle_2/Projeto_Final/gerador_senoidal.html) para entender uma forma de implementar um gerador de onda senoídal de 40 Hz usando rotina ISR e taxa de amostragem de 400 Hz. Note que apenas 10 pontos de cada ciclo da senóide são sintetizados. 

Sugere-se que o estudante modifique o código para fazer ativar o nível lógico de uma saída digital para ALTO no momento em que o microcontrolador entre no código da ISR e que ao final desta rotina, o nível lógico desta saída seja alterado para nível lógico BAIXO. Acompanhe num osciloscópio a onda quadrada gerada nesta saída digital, note que seu "*duty-cycle*" vai corresponder ao tempo de processamento exigido pela placa Arduino Uno para executar esta rotina ou a **taxa de ocupação da CPU** do Arduino para execução da ISR.  Deve ser percebido que para baixas taxas de amostragem, sobra um bom tempo de processamento para execução de rotindas tradicionais no Arduino, mas conforme a frequência de amostragem sobe, deve ser percebida a  falta de "tempo livre" para o Arduino executar as rotinas comuns. No caso exemplo da geração da onda Senoidal de 40 Hz, usando frequência de amostragem de 400 Hz, ou período de amostragem de $T=1/400=0,0025$ segundos, ou seja, a ISR foi executada à cada 2,5 mili-segundos, ocupando um tempo de processamento baixíssimo para mesma, em torno de 6,68% do tempo de processamento livre.

O estudante deveria ober um gráfico como o mostrado abaixo:

![figura_osciloscópio](https://fpassold.github.io/Lab_Controle_2/Projeto_Final/figuras/TEK0043_ed.JPG)

**Alguns cálculos interessantes**:

Freq. obtida na prática: 403,0 Hz (medida através do osciloscóipio);
O pino associado com a execução da tarefa ISR pemaneceu em nível lógico alto por: 167 $\mu$s (medido com osciloscópuo).
Como $T=1/400=2,3$ ms, então pode-se concluir que a ISR ocupou:
$\dfrac{167 \times 10^{-6}}{2500 \times 10^{-6}}\times 100\%=6,68\%$ do período da frequência selecionada para execuçao da ISR.
Ou podemos dizer que o Arduino "gastou" 167 $\mu$s para executar 2 adições *float* + 2 multiplicações *float* + 1 cálculo de *sin* em *float* quando operado à 16 MHZ (clock do Arduíno Uno), em outras palavras, o Arduino gastou aproximadamente:
$\dfrac{167.000\times 10^{-9}}{\left( \frac{1}{16 \times 10^{6}} \right)}=2.672$ ciclos de clock para executar a ISR ou $2672/4=668$ ciclos de máquina.

Note que como este código ainda não está usando o módulo externo MPC 4725, e sim a saída PWM tradicional do Aruíno, que trabalha no máximo à 980 Hz, assim, sinais que não sejam ondas quadradas (facilmente sintetizadas apenas alternando o nível lógico de um pino) com frequências superiores à no máximo $980/2=490$ Hz, dificialmente poderão ser sintetizadas sem uso de um DAC externo.

### 3. Terceira Tarefa Sugerida

Instale o módulo externo DAC **MPC 4725**, incluindo suas bibliotecas com base na página  ["Trabalhar com o Módulo DAC"](https://fpassold.github.io/Lab_Controle_2/PID_Digital/modulo_DAC.html) para gerar diferentes ondas senoidais.

#### 3.1 Gerar onda de 40 Hz à 400 Hz

Adapte parte do código final apresentado na página ["Gerador de Onda Senoidal de 40 Hz"](https://fpassold.github.io/Lab_Controle_2/Projeto_Final/gerador_senoidal.html) para geração de sinal verdadeiramente analógico usando o módulo externo DAC **MPC 4725**. Comprove mostrando capturas de tela do osciloscópio, a **taxa de ocupação** da CPU do Arduino para tratamento da ISR (canal 2) enquanto mostra no canal 1, o sinal sendo gerado.

#### 3.2 Gerar onda de 500 Hz à 1 KHz

A idéia agora é modificar o código anterior para gerar uma onda senoidal de 500 Hz usando taxa de amostragem de 1 KHz. Justifique o *timer* adotado, mostre o cáculos necessário para definição dos valores do registrador de *prescaler* e CMR (*Compare Match Register*) e explique rapidamente como sintetizou os pontos da onda senoidal.

Deve ser percebido que esta taxa de amostragem é muito baixa para sintetizar uma onda senoídal. O Sinal de saída gerado deve estar mais parecido com uma onda triangular que com uma onda senoidal. Faça acompanhar as telas capturadas no osciloscópio.

#### 3.3 Gerar onda de 500 Hz usando 20 pontos por ciclo

A idéia agora é aumentar a resolução de síntese da nossa senoide. aumentando a quantidade de pontos sintetizados para 20 pontos por ciclo da senoide. Isto significa que agora teremos que implementar uma ISR para ser executada na frequência de $20 \times 500=$ 10 KHz ou à cada $1/(20 \times 500)=0,0001$ segundos (0,1 mili-segundos). Verifique se é possível atingir esta taxa de amostragem usando a placa Arduino Uno.

Faça acompanhar num relatório os cáculos necessários para definição dos valores do registrador de *prescaler* e CMR (*Compare Match Register*) do *timer* escolhido, explique rapidamente como sintetizou os pontos da onda senoidal e faça acompanhar capturas de telas de osciloscópio mostrando 2 sinais: a taxa de ocupação da CPU do Arduíno e sinal analógico sendo gerado.

#### 3.4 Gerar onda Senoidal de 2 KHz.

A idéia agora é com base nos resultados obtidos no item anteior, tentar executar uma notina que gere uma onda senoidal na frequeência de 2 KHz, sintetizada usando pelo menos 10 pontos.

Tente descobrir a frequência máxima que poderia ser sintetizada reduzindo o período de amostragem e fazendo a ISR ocupar até 90% do tempo de processamento da sua CPU. Note que se provavelmente na seção `void loop(){ ...}` do Arduino estiver contido algum código para efetuar a leitura de um botão e executar debouncing, o programa passará a impressão de ser pouco "responsivo" para o usuário, já que o a CPU do Arduino estará bastante ocupada sintetizando a onda senoidal e não efetuando leitura de um "teclado".

#### 3.5 Gerar onda Senoidal de 8 KHz.

Seria possível gerar uma onda senoidal na frequênica de 8 KHz usando Arduino Uno?

Justifique com cálculos, explicações e código se possível.

----

## Anexo: Eventual uso do FreeRTOS para Arduino

Eventualmente, dependendo da familiaridade do estudate, o mesmo pode usar a biblioteca de código live e aberto para sintetizar *tasks* de *soft-real-time* como o [FreeRTOS](https://www.freertos.org). Uma breve introdução ao FreeRTOS pode ser vista  [[aqui]](FreeRTOS/intro_FreeRTOS.html) .

Placas Arduino Uno permitem uso de funçoes do FreeRTOS. para instalar esta biblioteca ver: ["Installing Librarues"](https://docs.arduino.cc/software/ide-v1/tutorials/installing-libraries/), neste caso, baixando a biblioteca [FreeRTOS-11.1.0-1](https://downloads.arduino.cc/libraries/github.com/feilipu/FreeRTOS-11.1.0-1.zip?_gl=1*zv059c*_ga*MzE1MzQ1ODI0LjE3MjQzNzk2OTA.*_ga_NEXN8H46L5*MTcyNDM3OTY4OS4xLjEuMTcyNDM3OTkwMi4wLjAuMTYxODUxODU0Ng..*_fplc*b3hjbWdNQ1lubkFQMERaVCUyQmFjV2glMkZsSVV4elJVeHJPUUJUajRtZUJUSjZhMldEejdkNXVucExabW40WVU3bk9sd3MwaiUyQlZTaUNBOWFZeVNyNnpPeUxzQVpRR3k1eUxsVGpDV0RVYVhkVFFGSEhCWlMzek03Qmx0bzNSak13JTNEJTNE*_gcl_au*MTgyMTgzMzkzNy4xNzI0Mzc5Njk5*FPAU*MTgyMTgzMzkzNy4xNzI0Mzc5Njk5) ou outra versão mais atual à partir de [Arduino.cc > Reference > Libraries > Freertos](https://www.arduino.cc/reference/en/libraries/freertos/).

Funções contidas nesta biblioteca podem simplificar a codificação de rotinas assíncronas (ou mesmo síncronas: que dependem de certo período de amostragem), sem a necessidade do programar ter que selecionar e programar o *timer* desejado e a rotina de ISR para execução de determinada tarefa

### Exemplo

Segue exemplo de código em C++ para a placa Arduino que utiliza o FreeRTOS para alternar o estado de um LED conforme o usuário aperta um botão. O código inclui uma rotina para debouncing do botão e altera o nível lógico de uma variável booleana associada ao LED.

Usando FreeRTOS numa placa Arduino Uno, este código ficaria semelhante à:

```c++
#include <Arduino_FreeRTOS.h>

// Definições dos pinos
const int ledPin = 13;      // Pino onde o LED está conectado
const int buttonPin = 7;    // Pino onde o botão está conectado

// Variável global booleana para armazenar e inicializar o estado do LED
volatile bool ledState = false;

// variáveis globais
volatile bool outputEnabled = true;  // variável booleana que alterna estado conforme botão

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT);
  // Criar as tarefas FreeRTOS
  xTaskCreate(TaskButtonCheck, "ButtonCheck", 128, NULL, 2, NULL);
}

void loop() {
  // Eventualmente fica vazio quando apenas FreeRTOS gerencia as tarefas
  // mas neste caso:
  // Atualiza o estado do LED baseado na variável ledState
  digitalWrite(ledPin, ledState ? HIGH : LOW);

  // Pequeno delay no loop principal - opcional, para facilitar
  // que usuário perceba que está com dedo no botão ainda...
  vTaskDelay(100 / portTICK_PERIOD_MS);
}

// Tarefa para verificar o estado do botão
void TaskButtonCheck(void *pvParameters) {
  bool lastButtonState = HIGH;
  for (;;) {
    bool currentButtonState = digitalRead(BUTTON_PIN);

    if (currentButtonState == LOW && lastButtonState == HIGH) {
      ledState = !ledState; // Alternar entre 0/1 (false/true)
    }

    lastButtonState = currentButtonState;
    vTaskDelay(pdMS_TO_TICKS(50)); // Debounce simples, 50 ms
  }
}
```

### Explicação

1. **Pinos**: O LED está conectado ao pino 13 e o botão ao pino 7.
2. **Variável `ledState`**: Essa variável booleana controla o estado do LED. Ela é alterada toda vez que o botão é pressionado.
3. **TaskButtonCheck**: Verifica o estado do botão a cada 50 ms. Se detectar uma transição de alto para baixo, alterna o estado da variável `ledState`.
4. **Loop Principal (`loop()`)**: O loop principal apenas escreve o estado do LED baseado no valor da variável `ledState`, que é alterado pela tarefa `TaskButtonCheck`.

Este código é um exemplo básico que pode ser expandido para incluir mais funcionalidades ou otimizações, como adicionar mais tarefas ou definir prioridades (neste caso, nenhuma).

Abaixo documentação resumida sobre certas funções do FreeRTOS:

*  [Introdução ao_FreeRTOS](FreeRTOS/intro_FreeRTOS.html) ;
*  [xTaskCreate](FreeRTOS/xTaskCreate.html) ;
*  [vTaskDelayUntil](FreeRTOS/vTaskDelayUntil.html) ;
*  [Definição de Prioridades](FreeRTOS/prioridades.html) ;
*  [Exemplo de rotina de controle digital](FreeRTOS/controle_digital_ex1.html) ;

### Limitações do FreeRTOS

**Mas...** há limitações para uso desta biblioteca em qualquer placa microcontrolado. Normalmente o *tisk* (período de amostragem usado pelo "gerenciador de tarefas" do FreeRTOS), não trabalha acima de 1 KHz, o que pode limitar bastante a frequência com que um sinal deve ser amostrado ou sintetizado tentando usar *tasks* síncronas do FreeRTOS. Nestes casos, a única soluçao disponível é implementar rotinas ISR da forma tradicional como mostrado neste documento. Entretanto, rotinas FreeRTOS podem ser mescladas no código com rotinas ISR, mas neste caso, usando rotinas FreeRTOS para as tasks que não precisam ser executadas tão rapidamente, como por exemplo, a leitura e tratamento de *debouncig* de um botão/teclado.

No caso particular da implementação das bibliotecas do FreeRTOS em placas Arduino, o *tisk* mínimo parece ter sido limitado à 15 mili-segundos, o que corresponderia a uma taxa de amostragem máxima de 66,67 Hz.

----

<font size="2">🌊 [Fernando Passold](https://fpassold.github.io/)[ 📬 ](mailto:fpassold@gmail.com), <script language="JavaScript"><!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("página criada em 22/08/2024; atualizada em " + LastUpdated); // End Hiding -->
</script></font>

