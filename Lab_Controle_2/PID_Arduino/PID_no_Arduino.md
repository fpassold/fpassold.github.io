# Teste de PID Digital em Arduíno Uno

**Breve descrição**:

Este algoritmo foi desenvolvido para placa Arduino Uno, juntamente com um pequeno "shield" desenvolvido especialmente para testes ([outras placas de interfaceamento](setup_arduino_PID.html) com o sistema físico real estão atualmente em desenvolvimento/construção, 15/04/2024). 

A placa usada para este teste inclui:

* LDR conectado ao A/D 0 do Arduíno usando usando resistor série de 10 K$\Omega$;
* Leds conectados aos pinos 5 e 6 do Arduíno Uno (saídas PWM na frequência de 980 Hz, usando timer0); Estes leds "simulam" o resultado do algoritmo de controle (modo manual/automático);
* Led conecado ao pino 10 do Arduíno Uno para atuar como "monitor" do algoritmo de controle (led pisca na frequencia de 1 Hz, indicando execução da ISR associada com o algoritmo de controle);
* ISR associada ao timer2 programado para executar o **algoritmo de controle** (lei de controle: até PID paralelo com filtro derivativo) na **frequência de 100 Hz**.
* **Interface com usuário: Comunicação serial/USB** com placa Arduino Uno (via **terminal**), repassando comandos como:
  * `s`= pedido de "status" do sistema, indicando dados atuais capturados e parâmetros atuais do PID;
  * `a`= realiza um "toggle" entre modo manual/automático do sistema; (`a 1` = ativa modo automático);
  * `p 100` = indica "setar" ganho proporcional do PID com valor 100 (aceita valores float);
  * `d 0.5` = indica "setar" ganho derivativo do PID com valor 0,5; (`d 0` = implica "desligar" ação derivativa');
  * `i 1.2`= indica "setar" ganho integral com valor 1,2; (`i 0` = implica "desligar" ação integral);
  * `r 200` = modifica "set-point" (SP ou referência) para o valor 200. Necessário antes de ativar algoritmo de controle (caso contrário $r[k]=0$).
  * `u 200` = permite modificar a variável manipulada (MV) para um valor no intervalo $[0 .. 255]$ que corresponde ao valor aceito nativamente pela rotina de controle do duty-cycle do Arduino (instrução `analogWrite()`). Note que o este comando permite alterar potência do sistema sendo controlado pela placa quando o sistema está no modo "manual".
  * `v`= realiza "toggle" entre modo "verbouse" ou não. Caso o modo "verbouse" esteja desativado, o sistema não dá retorno à respeito dos comandos anterior (apesar de interpretá-los) e pela porta serial, este sistema envia continuamente linhas de dados com 3 colunas: SP: $r[k]$,	PV: $y[k]$,	MV: $u[k]$, com cada dado numérico (float com 4 casas decimais) separados por vírgula, espaço em branco e caracter TAB. Se o modo "verbouse" está ativado, o sistema para de enviar esta informação e passa a dar retorno sobre os comandos repassados para a placa via porta serial.

Segue código implementando ( teste_algo5.ino ):

```c++
/*************************
Teste de algoritmo de controle, ISR executando à 100Hz atrelado ao timer2
+ leitura da porta serial e interpretação de comandos
= para comando de PWM associado com led no pino 5 ou 6 (980 Hz; timer0)
Fernando Passold, em 18/04/2004

"Dicionário" de comandos interpretados pela porta serial:
p 100.5 = define ganho Proporcional em 100.5
i 50 = define ganho Integral em 50
d 0.005 = define ganho derivativo em 0.005
a = toggle entre modo manual e modo automático
a0 - a 0 = "desliga" modo automático
a 1 = "liga" modo automático
v = toggle no modo verboouse (debug)
v 0 = desliga modo verbouse
v 1 = liga modo verbouse
r 50 = define Referencia em 50
u 50 = define sinal de controle (se automático desligado) em 50
u = faz PWM = 0 ("desliga")
s = “status”: publica valores atuais de sp, Kp, Ki e Kd

Detalhes da montagem:
- led para "testar" algoritmo de controle conectado no pino 5 ou 6
- led que pisca indicando execução do algoritmo de controle, no pino 10
- todos os leds em config ativo alto
*********************************/

// declaração variáveis globais:
bool ledState = 0;            // para fazer variar nível lógico led monitor
const byte LED_MONITOR = 10;  // toglles a cada 0,5 segundos monitorando algo controle (ISR)
const byte LED_PWM = 5;       // Led à ser "controlado", no pino 5 (ou 6)
int ledCounter = 0;           // conta até 50 para então picar Led monitor

// variável associada com "debug" --> "verbouse": retorna info via porta serial
bool verbouse = true;
/****
Obs.: se verbouse desativado, o que deve ser visto na porta serial é algo como:
sp: r[k],	pv: y[k],	mv: u[k]
340.0000, 	328.0000, 	12.0000
340.0000, 	328.0000, 	12.0000
Isto preve interação com Matlab para captura de dados
*****/

// variáveis associadas com algoritmo de controle
bool control = false;       // comuta entre modo automático (-1) e manual (=0)
const byte analogPin = A0;  // pino (A/D) que recebe sinal analógico
float sp = 0;               // set-point, referência, r[k]
float pv = 0;               // process-variable, saída do processo, y[k]
float mv = 0;               // manipulated-variable, saída do controlador, u[k]
float u, u1, u2;            // u[k], u[k-1], u[k-2]
float y, y1, y2;            // y[k], y[k-1], y[k-2]
float e, e1, e2;            // e[k], e[k-1], e[k-2]
float f, f1, f2;            // f[k], f[k-1], f[k-2]: sinal filtrado do erro
float sum_i;                // soma da ação integral;
float Kp, Ki, Kd;           // ganhos parte proporcional, integral, derivativa
float alpha = 0.1;          // associado com filtro derivativo
float T = 0.01;             // período de amostragem adotado (em segundos)

// variáveis associadas com dados (string) capturada via porta serial
String inputString;
char option;
float value;

void Init_Control() {
  // inicializa variáveis associadas com lei de controle
  u = 0; u1 = 0; u2 = 0;
  y = 0; y1 = 0; y2 = 0;
  e = 0; e1 = 0; e2 = 0;
  f = 0; f1 = 0; f2 = 0;
  mv = 0;
  sum_i = 0;
}

void publica_modo(void) {
  if (!verbouse) Serial.println(" ");  // pula linha em branco
  if (control) Serial.println("Modo automático ativado!");
  if (!control) Serial.println("Modo manual ativado");
  Serial.println(" ");
}

void publica_MV(float duty) {
  float percent;
  Serial.print("MV: u[k] = ");
  Serial.print(duty);                     // Imprime o valor com duas casas decimais
  percent = ((int)duty) * 100.0 / 255.0;  // PWM só aceita [0..255]
  Serial.print(" (");
  Serial.print(percent, 2);
  Serial.println("%)");
}

void publica_sp(void) {
  Serial.print("SP: r[k] = ");
  Serial.println(sp, 4);
}

void publica_parametro(char const msg[], float valor) {
  /****
  Obs.: a declaração const antes de msg[] é para tornas esta declaração válida em C ou C++,
  senão: warning: ISO C++ forbids converting a string constant to 'char*'
  Ref.: https://stackoverflow.com/questions/20944784/why-is-conversion-from-string-literal-to-char-valid-in-c-but-invalid-in-c
  ******/
  Serial.print(msg);
  Serial.print(" = ");
  Serial.println(valor, 4);
}

void publica_status(void) {
  float aux;  // copia de algumas variáveis atualizadas muito rapidamente, à cada 100 Hz...
  Serial.println("Status do sistema:");
  aux = pv;
  Serial.print("PV: y[k] = ");
  Serial.print(aux, 2);
  aux = mv;
  Serial.print(", MV: u[k] = ");
  Serial.print(aux, 2);
  Serial.print(", SP: r[k] = ");
  Serial.println(sp, 2);
  Serial.print(" Modo = ");
  if (control)
    Serial.println("AUTO");
  else
    Serial.println("Manual");
  publica_parametro("   Kp", Kp);
  publica_parametro("   Ki", Ki);
  publica_parametro("   Kd", Kd);
  publica_parametro("alpha", alpha);
}

void setup() {
  // inicializa pinos dos leds e começa com eles desligados
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
  pinMode(LED_MONITOR, OUTPUT);
  digitalWrite(LED_MONITOR, LOW);
  pinMode(LED_PWM, OUTPUT);
  digitalWrite(LED_PWM, LOW);
  analogWrite(LED_PWM, 0);  // garante que este led inicia apagado
  // inicializa saída de controle, mv
  Init_Control();
  Kp = 1.0;
  Ki = 0;
  Kd = 0;
  control = false;  // controle automático desligado
  verbouse = true;  // ativado debug
  // initialize timer2
  noInterrupts();  // disable all interrupts
  TCCR2A = 0;      // set entire TCCR2A register to 0
  TCCR2B = 0;      // same for TCCR2B
  TCNT2 = 0;       // initialize counter value to 0
  // set compare match register for 100 Hz increments
  OCR2A = 155;             // set counter up to 155
  TCCR2A |= (1 << WGM21);  // turn on CTC mode
  // setting prescaler with 1024
  TCCR2B |= (1 << CS22) | (1 << CS21) | (1 << CS20);
  TIMSK2 |= (1 << OCIE2A);  // enable timer2 compare interrupt
  interrupts();             // enable all interrupts
  Serial.begin(115200);     //  setup serial
  while (!Serial) {
    ;  // Aguarda até que a porta serial esteja pronta - normalmente 10 ms
  }
  publica_status();
  Serial.println("Modo \"verbouse\" ativado.");
  Serial.println("Aguardando comandos...");
  Serial.println(" ");
}

void limita(int *valor) {
  // Bloco "Saturador", trabalha com variáveis int
  // altera diretamente conteúdo da variável valor;
  // passagem de parâmetros, sem cópia, por referência
  // uso: limita(&duty);
  if (*valor > 255) *valor = 255;
  if (*valor < 0) *valor = 0;
}

// tratamento de interrupção - algoritmo de controle (timer2)
ISR(TIMER2_COMPA_vect) {  //timer2 interrupt @ 100 Hz
  // atualiza seção do led monitor (o que pisca)
  ledCounter++;
  if (ledCounter >= 50) {
    ledState = !ledState;
    digitalWrite(LED_MONITOR, ledState);
    digitalWrite(LED_BUILTIN, ledState);  // faz piscar led da placa do Arduino
    ledCounter = 0;
  }
  // inicia seção da lei de controle
  pv = analogRead(analogPin);  // y[k] = info do sensor (A/D de 12-bits: [0..4095])
  y = pv;
  // note que variável pv é atualizada sempre
  // e que saída PWM é sempre re-programada
  if (control) {
    // processa lei de controle
    e = sp - pv;  // e[k] = r[k] - y[k]
    // ação proporcional - sempre ativada!
    u = Kp * e;
    if (Ki > 0) {
      // ação integral
      sum_i = sum_i + (T * (e + e1)) / 2;  // integração trapezoidal
      // prever saturação ação integral?
      //
      u = u + Ki * sum_i;
    }
    if (Kd > 0) {
      // ação derivativa:
      // filtrando sinal de erro, filtro passa-baixas exponencial 1a-ordem
      f = alpha * e + (1 - alpha) * f1;  // filtragem sinal do erro
      u = u + Kd * ((f - f1) / T);       // derivada sinal filtrado do erro
    }
    // saída do sinal para processo
    // passa por "bloco saturador": no caso PWM do Arduino: [0 255]
    if (u < 0) u = 0;
    if (u > 255) u = 255;
    // Note que variável u preserva casas decimais..
    mv = u;  // transforma u[k] para int
  }
  analogWrite(LED_PWM, (int)mv);  // valores entre 0 ~ 255 (0 ~ 100%) de dutty-cycle
  // atualiza variáveis associados com atrasos, deixa preparadas para próxima chamada
  f2 = f1;
  f1 = f;
  e2 = e1;
  e1 = e;
  u2 = u1;
  if (control)
    u1 = u;
  else
    u1 = mv;  // necessáriuo para evitar um "bump" qdo sai de manual --> automático
  y2 = y1;
  y1 = y;
}

void publica_verbouse(void) {
  Serial.print("Modo verbouse: ");
  if (verbouse)
    Serial.println("ATIVADO");
  else
    Serial.println("desativado");
}

void init_auto(void) {
  // sai do modo manual para automático, mas para evitar "lixo" em variáveis de amostras
  // atrasadas, melhor zerar certas amostras atradas.
  e = 0; e1 = 0; e2 = 0;
  f = 0; f1 = 0; f2 = 0;
  sum_i = 0;
  control = true;
  verbouse = false;  // automaticamente desativa modo verbouse; passa a publicar dados do sistema
  publica_verbouse();
  Serial.println(" ");
  Serial.println("Ativando Modo AUTOmático:");
  Serial.println("sp: r[k],\tpv: y[k],\tmv: u[k]");
  Serial.println(" ");
}

void process_instruction(char option, float value) {
  // Realizar a ação com base na opção repassada
  int duty;
  switch ((int)option) {
    case 'v':  // toggle no modo verbouse
      if (!verbouse) {
        Serial.println(" ");  // garante que pula uma linha em branco antes de cortar publicação de dados
        Serial.println("Entrando em modo \"verbouse\".");
        verbouse = true;
      } else {
        Serial.println(" ");
        Serial.println("Modo \"verbouse\" sendo desativado.");
        Serial.println(" ");
        verbouse = false;
      }
      break;
    case 'a':
      if (value > 0) {
        init_auto();	// control = true;
      } else {
        if (!control) {
          init_auto(); // control = true;
        } else {
          control = false;
          Serial.println(" ");  // pula linha em branco
          Serial.println("Entrando em modo Manual");
          verbouse = true; publica_verbouse();
        }
      }
      break;
    case 'u':                                        // ajustar diretamente u[k] ou MV
      duty = (int)value;                             // transforma para int
      limita(&duty);                                 // bloco "saturador"
      mv = duty;                                     // atualiza valor para algo de controle
      if (control) publica_MV(duty);				 // publica_parametro("duty", duty);
      break;
    case 'r':  // ajusta r[k] = set point, sp
      sp = value;
      if (verbouse) publica_sp();
      break;
    case 's':            // publica "status" (alguns valores atuais)
      publica_status();  // independente do verbouse ativado ou não
      break;
    case 'p':  // ajustar ganho proporcional
      Kp = value;
      if (verbouse) publica_parametro("Kp", Kp);  // publica_Kp();
      break;
    case 'd':
      Kd = value;
      if (verbouse) publica_parametro("Kd", Kd);  // publica_Kd();
      break;
    case 'i':
      Ki = value;
      if (verbouse) publica_parametro("Ki", Ki);
      break;
    // Adicione mais casos conforme necessário
    default:
      if (verbouse) {
        Serial.println(" <-- Comando não reconhecido");
      }
      break;
  }
}

void process_token(String inputString) {
  //***** Lida com string de entrada via serial
  if (verbouse) {
    Serial.print("> String recebida = [");
    Serial.print(inputString);
    Serial.print("], ");
    // Remove espaços em branco da string
    inputString.trim();
    Serial.print("trim String = [");
    Serial.print(inputString);
    Serial.print("], ");
  }
  // Encontra o índice do primeiro caractere numérico
  int numericIndex = 0;
  for (int i = 0; i < inputString.length(); i++) {
    if (isdigit(inputString[i]) || inputString[i] == '.') {
      numericIndex = i;
      break;
    }
  }
  if (verbouse) {
    Serial.print("numericIndex=");
    Serial.print(numericIndex);
    Serial.print(", ");
  }
  // Extrai a parte inicial da string
  String initialPart = inputString.substring(0, numericIndex);
  // Separa o primeiro caractere da parte inicial (letra ou palavra)
  // option = initialPart[0]; <-- algum bug em inputString.substring(0, numericIndex); se
  // se numericIndex = 0
  option = inputString[0];
  // Converte a parte numérica da string para float
  value = inputString.substring(numericIndex).toFloat();
  if (verbouse) {
    Serial.print("option = [");
    Serial.print(option);
    Serial.print("], ");
    Serial.print("value = ");
    Serial.println(value, 4);
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  float aux;
  if (Serial.available() > 0) {  // Verifica se há dados disponíveis para leitura
    // String inputString = Serial.readStringUntil('\n');
    inputString = Serial.readStringUntil('\n');
    process_token(inputString);
    process_instruction(option, value);
    inputString = '\0';
  }  // fim tratamento buffer porta serial (se cheio)
  if (!verbouse) {
    // atualiza porta serial com dados do proceso:
    // colunas: r[k] y[k] u[k]
    // Notar que algumas detas variáveis são atualizadas mais rapidamente que a USART
    aux = sp;
    Serial.print(aux, 4);
    Serial.print(", \t");
    aux = pv;
    Serial.print(aux, 4);
    Serial.print(", \t");
    aux = mv;
    Serial.println(aux, 4);
  }
}
```

**Exemplo de uso**:

Este algoritmo quando executado, gera (na porta serial ou "**Monitor Serial**" da IDE do Arduíno), algo como:

```
Status do sistema:
PV: y[k] = 0.00, MV: u[k] = 0.00, SP: r[k] = 0.00
 Modo = Manual
   Kp = 1.0000
   Ki = 0.0000
   Kd = 0.0000
alpha = 0.1000
Modo "verbouse" ativado.
Aguardando comandos...
 
> String recebida = [s], trim String = [s], numericIndex=0, option = [s], value = 0.0000
Status do sistema:
PV: y[k] = 334.00, MV: u[k] = 0.00, SP: r[k] = 0.00
 Modo = Manual
   Kp = 1.0000
   Ki = 0.0000
   Kd = 0.0000
alpha = 0.1000
> String recebida = [r 340], trim String = [r 340], numericIndex=2, option = [r], value = 340.0000
SP: r[k] = 340.0000
> String recebida = [a], trim String = [a], numericIndex=0, option = [a], value = 0.0000
Modo verbouse: desativado
 
Ativando Modo AUTOmático:
sp: r[k],	pv: y[k],	mv: u[k]
 
340.0000, 	328.0000, 	12.0000
340.0000, 	328.0000, 	12.0000
340.0000, 	345.0000, 	0.0000
340.0000, 	345.0000, 	0.0000
...
340.0000, 	335.0000, 	5.0000
340.0000, 	335.0000, 	5.0000
340.0000, 	335.0000, 	0.0000
340.0000, 	352.0000, 	0.0000
340.0000, 	352.0000, 	0.0000
340.0000, 	352.0000, 	0.0000
340.0000, 	352.0000, 	0.0000
340.0000, 	355.0000, 	0.0000
340.0000, 	355.0000, 	0.0000
340.0000, 	355.0000, 	0.0000
340.0000, 	355.0000, 	1.0000
340.0000, 	339.0000, 	1.0000
340.0000, 	339.0000, 	1.0000
340.0000, 	339.0000, 	1.0000
 
Entrando em modo Manual
Modo verbouse: ATIVADO

```

Se for ativado o "**Serial Plotter**" obtemos algo como:

![teste_algo5](teste_algo5.gif)

Obs.: No caso acima, o modo automático foi ativado e o LDR foi "bloqueado" (tampado para não receber nenhuma informação luminosa). E inicialmente o **Serial plotter** fica "parado" enquanto a placa está sendo "setada" (comando `r 200` para estabelecer a referência, $r(t)=200$) e posteriormente a placa foi colocada no modo automático (enviado comando`a`) e depois retirada do modo automático (enviado `a` novamente). Quando esta placa entra e saí do modo automático, o "modo verbouse" é automaticamente comutado.

<iframe width="640" height="360" src="https://www.youtube.com/embed/s9fz2Yxb7VI" title="Teste PID Digital em Arduino Uno." frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

[teste algoritmo PID em Arduíno Uno - YouTube](https://www.youtube.com/watch?v=s9fz2Yxb7VI) (8 segundos). 

Fim. [:musical_note:](https://youtu.be/sLXBnT2fJ1o?si=ZLXCkT8u5R9iONTI)

---

Fernando Passold, em 18/04/2024

