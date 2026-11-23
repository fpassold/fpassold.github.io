
/*
  teste_algo5_ESP32_ISR_PID_v2.ino

  Adaptacao de teste_algo5-ver1_5.ino para ESP32-32U / DevKit V4.

  Temporizador de hardware:
    Frequencia da ISR = 100 Hz
    Periodo T = 10 ms

  Organizacao:
    - O loop() realiza a leitura do ADC.
    - A ISR executa o algoritmo PID a cada 10 ms.
    - O loop() atualiza a saida PWM por meio do periferico LEDC.
    - GPIO27: pulso de diagnostico para medir a duracao da ISR.
    - GPIO14: LED indicador, alternado a cada 50 execucoes da ISR.
    - GPIO25: saida PWM REAL para o processo externo.

  ATENCAO:
    GPIO27 e GPIO14 NAO sao a saida de controle.
    A saida PWM do processo e exclusivamente GPIO25.

  Comandos seriais:
    p 100.5  - ganho proporcional
    i 50     - ganho integral
    d 0.005  - ganho derivativo
    l 0.1    - coeficiente do filtro derivativo
    r 340    - referencia (setpoint)
    u 120    - comando manual
    u        - comando manual zero
    a        - alterna Manual/Automatico
    a 0      - modo Manual
    a 1      - modo Automatico
    v        - alterna modo verbose
    v 0      - desativa verbose
    v 1      - ativa verbose
    s        - publica status

  Plataforma:
    ESP32 classico, Arduino-ESP32 Core 3.x
*/

#include <Arduino.h>
#include <ctype.h>
#include "soc/gpio_struct.h"

// --------------------------------------------------
// Pinos
// --------------------------------------------------

static const uint8_t PIN_ADC       = 34;
static const uint8_t PIN_PWM       = 25;
static const uint8_t PIN_ISR_TEST  = 27;
static const uint8_t PIN_LED_MON   = 14;

// PWM de processo: frequencia e resolucao independentes
// da frequencia da ISR.
static const uint32_t PWM_FREQ = 980;
static const uint8_t PWM_BITS = 8;

// --------------------------------------------------
// Temporizacao
// --------------------------------------------------

static const uint32_t CONTROL_HZ = 100;
static const uint32_t TIMER_HZ = 1000000; // 1 MHz
static const uint64_t TIMER_PERIOD = 10000; // 10 ms

static const float T = 0.01f;

hw_timer_t *controlTimer = nullptr;

// --------------------------------------------------
// Variaveis compartilhadas entre loop() e ISR
// --------------------------------------------------

portMUX_TYPE dataMux = portMUX_INITIALIZER_UNLOCKED;

volatile float sp = 0.0f;
volatile float Kp = 1.0f;
volatile float Ki = 0.0f;
volatile float Kd = 0.0f;
volatile float alpha = 0.1f;

volatile bool control = false;
volatile bool verbose = true;

volatile float manualCommand = 0.0f;

// Ultima amostra ADC, disponibilizada pelo loop()
volatile float adcSample = 0.0f;

// Resultado calculado pela ISR
volatile int pwmCommand = 0;
volatile float pv = 0.0f;
volatile float mv = 0.0f;

// Contador de execucoes da ISR
volatile uint32_t isrCount = 0;

// --------------------------------------------------
// Estados internos do controlador
// Acessados exclusivamente pela ISR
// --------------------------------------------------

static float u = 0.0f;
static float u1 = 0.0f;

static float e = 0.0f;
static float e1 = 0.0f;

static float f = 0.0f;
static float f1 = 0.0f;

static float sum_i = 0.0f;

// --------------------------------------------------
// Diagnostico da ISR
// --------------------------------------------------

static uint8_t ledCounter = 0;
static bool ledState = false;

// --------------------------------------------------
// Saturacao da saida
// --------------------------------------------------

static inline int limita(int valor) {
  if (valor > 255) return 255;
  if (valor < 0) return 0;
  return valor;
}

// --------------------------------------------------
// ISR do temporizador: PID a 100 Hz
// --------------------------------------------------

void ARDUINO_ISR_ATTR onControlTimer() {

  // Pulso de diagnostico: inicio da ISR.
  // GPIO27 deve permanecer alto durante o processamento.
  GPIO.out_w1ts = (1UL << PIN_ISR_TEST);

  // Copia os dados compartilhados.
  float localSP, localKp, localKi, localKd, localAlpha;
  float localPV, localManual;
  bool localControl;

  portENTER_CRITICAL_ISR(&dataMux);

  localSP = sp;
  localKp = Kp;
  localKi = Ki;
  localKd = Kd;
  localAlpha = alpha;

  localControl = control;
  localManual = manualCommand;
  localPV = adcSample;

  portEXIT_CRITICAL_ISR(&dataMux);

  // Variavel de processo.
  pv = localPV;

  if (localControl) {

    // Erro de controle
    e = localSP - localPV;

    // Acao proporcional
    u = localKp * e;

    // Acao integral: integracao trapezoidal
    if (localKi > 0.0f) {
      sum_i += T * (e + e1) / 2.0f; % integração trapezoidal
      u += ...;
    }

    // Acao derivativa:
    // filtro passa-baixas exponencial de primeira ordem
    if (localKd > 0.0f) {
        % Filtro derivativo
      f = ...;
      u += localKd * ((f - f1) / T);
    }

  } else {

    // Modo manual
    u = localManual;
  }

  // Saturacao do comando de controle
  int output = limita((int)u);

  // Disponibiliza resultado para o loop().
  portENTER_CRITICAL_ISR(&dataMux);

  pwmCommand = output;
  mv = (float)output;
  isrCount++;

  portEXIT_CRITICAL_ISR(&dataMux);

  // Atualiza variaveis atrasadas para a proxima amostra.
  f1 = f;
  e1 = e;
  u1 = (float)output;

  // LED indicador: alterna a cada 50 execucoes.
  if (++ledCounter >= 50) {
    ledCounter = 0;
    ledState = !ledState;

    if (ledState)
      GPIO.out_w1ts = (1UL << PIN_LED_MON);
    else
      GPIO.out_w1tc = (1UL << PIN_LED_MON);
  }

  // Final da ISR: encerra pulso de diagnostico.
  GPIO.out_w1tc = (1UL << PIN_ISR_TEST);
}

// --------------------------------------------------
// Publicacao de informacoes
// Estas funcoes sao chamadas somente pelo loop().
// --------------------------------------------------

void publica_status() {

  float localSP, localPV, localMV;
  float localKp, localKi, localKd, localAlpha;
  bool localControl, localVerbose;

  portENTER_CRITICAL(&dataMux);

  localSP = sp;
  localPV = pv;
  localMV = mv;

  localKp = Kp;
  localKi = Ki;
  localKd = Kd;
  localAlpha = alpha;

  localControl = control;
  localVerbose = verbose;

  portEXIT_CRITICAL(&dataMux);

  Serial.println("\n# Status do sistema ################");

  Serial.print("PV = ");
  Serial.println(localPV, 2);

  Serial.print("MV = ");
  Serial.println(localMV, 2);

  Serial.print("SP = ");
  Serial.println(localSP, 2);

  Serial.print("Modo = ");
  Serial.println(localControl ? "AUTO" : "Manual");

  Serial.print("Kp = "); Serial.println(localKp, 4);
  Serial.print("Ki = "); Serial.println(localKi, 4);
  Serial.print("Kd = "); Serial.println(localKd, 4);
  Serial.print("alpha = "); Serial.println(localAlpha, 4);

  Serial.print("Verbose = ");
  Serial.println(localVerbose ? "ON" : "OFF");
}

// --------------------------------------------------
// Interpretacao de comandos seriais
// --------------------------------------------------

void process_instruction(char cmd, float value, bool hasValue) {

  bool beep = false;

  portENTER_CRITICAL(&dataMux);

  switch (cmd) {

    case 'p':
      Kp = value;
      break;

    case 'i':
      Ki = value;
      break;

    case 'd':
      Kd = value;
      break;

    case 'l':
      alpha = value;
      break;

    case 'r':
      sp = value;
      break;

    case 'u':
      manualCommand = hasValue ? value : 0.0f;
      break;

    case 'a':
      control = hasValue ? (value > 0.0f) : !control;

      if (control) {
        // Inicializa estados ao entrar em modo automatico.
        e = 0.0f;
        e1 = 0.0f;
        f = 0.0f;
        f1 = 0.0f;
        sum_i = 0.0f;
        u1 = manualCommand;
      }

      break;

    case 'v':
      verbose = hasValue ? (value > 0.0f) : !verbose;
      break;

    default:
      break;
  }

  portEXIT_CRITICAL(&dataMux);

  if (cmd == 's') {
    publica_status();
    return;
  }

  Serial.print("Comando recebido: ");
  Serial.print(cmd);

  if (hasValue) {
    Serial.print(" = ");
    Serial.println(value, 4);
  } else {
    Serial.println();
  }
}

// --------------------------------------------------
// Setup
// --------------------------------------------------

void setup() {

  Serial.begin(115200);

  pinMode(PIN_ADC, INPUT);

  pinMode(PIN_ISR_TEST, OUTPUT);
  pinMode(PIN_LED_MON, OUTPUT);

  digitalWrite(PIN_ISR_TEST, LOW);
  digitalWrite(PIN_LED_MON, LOW);

  analogReadResolution(12);

  // Configura PWM de processo:
  // GPIO25, 980 Hz, resolucao de 8 bits.
  if (!ledcAttach(PIN_PWM, PWM_FREQ, PWM_BITS)) {
    Serial.println("ERRO: nao foi possivel configurar LEDC.");
    while (true) delay(1000);
  }

  ledcWrite(PIN_PWM, 0);

  // Timer de hardware: contador a 1 MHz.
  controlTimer = timerBegin(TIMER_HZ);

  if (controlTimer == nullptr) {
    Serial.println("ERRO: timerBegin falhou.");
    while (true) delay(1000);
  }

  timerAttachInterrupt(controlTimer, &onControlTimer);

  // 10000 ticks de 1 us = 10 ms = 100 Hz.
  timerAlarm(controlTimer, TIMER_PERIOD, true, 0);

  Serial.println("\nPID ESP32 iniciado.");
  Serial.println("ISR do controlador: 100 Hz.");
  Serial.println("GPIO27: monitor da duracao da ISR.");
  Serial.println("GPIO25: PWM de controle do processo.");
  Serial.println("Digite s para consultar o status.");
}

// --------------------------------------------------
// Loop principal
// --------------------------------------------------

void loop() {

  // 1. Leitura do ADC fora da ISR.
  // ADC do ESP32 classico: 12 bits (0..4095).
  // Redimensionamento para 0..1023, aproximando
  // a escala numerica utilizada no Arduino Uno.

  float adc = (float)analogRead(PIN_ADC);
  adc *= 1023.0f / 4095.0f;

  portENTER_CRITICAL(&dataMux);
  adcSample = adc;
  portEXIT_CRITICAL(&dataMux);

  // 2. Atualizacao do PWM de processo.
  // O hardware LEDC gera o sinal continuamente.
  // A ISR apenas calcula o novo valor de duty-cycle.

  static int lastPWM = -1;

  int newPWM;

  portENTER_CRITICAL(&dataMux);
  newPWM = pwmCommand;
  portEXIT_CRITICAL(&dataMux);

  if (newPWM != lastPWM) {
    ledcWrite(PIN_PWM, newPWM);
    lastPWM = newPWM;
  }

  // 3. Recepcao de comandos seriais.

  if (Serial.available() > 0) {

    String line = Serial.readStringUntil('\n');
    line.trim();

    if (line.length() > 0) {

      char cmd = (char)tolower(line[0]);

      String argument = line.substring(1);
      argument.trim();

      bool hasValue = (argument.length() > 0);
      float value = hasValue ? argument.toFloat() : 0.0f;

      process_instruction(cmd, value, hasValue);
    }
  }

  // 4. Publicacao de dados para acompanhamento.
  // Publicacao limitada a aproximadamente 20 Hz.

  static uint32_t lastPrint = 0;

  bool localVerbose;
  float localSP, localPV, localMV;

  portENTER_CRITICAL(&dataMux);

  localVerbose = verbose;
  localSP = sp;
  localPV = pv;
  localMV = mv;

  portEXIT_CRITICAL(&dataMux);

  if (!localVerbose && millis() - lastPrint >= 50) {

    lastPrint = millis();

    Serial.print(localSP, 2);
    Serial.print('\t');

    Serial.print(localPV, 2);
    Serial.print('\t');

    Serial.println(localMV * 100.0f / 255.0f, 2);
  }
}
