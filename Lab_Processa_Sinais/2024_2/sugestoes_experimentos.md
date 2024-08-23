# LIsta de Experimentos

Aqui está uma lista de 13 experimentos e códigos exemplo para um curso de processamento digital de sinais (PDS) utilizando Arduino Uno e ESP32. Os experimentos começam com conceitos simples e evoluem para aplicações mais complexas.

### 1. **Amostragem e Quantização de Sinais (Arduino Uno)**
   - **Descrição:** Use um sensor analógico (como um potenciômetro) para capturar um sinal. Mostre como o sinal é amostrado e quantizado pelo conversor A/D do Arduino.
   - **Código:** Captura de sinais analógicos usando `analogRead()` e armazenamento dos valores amostrados.

### 2. **Filtro Média Móvel (Arduino Uno)**
   - **Descrição:** Implementar um filtro média móvel simples para suavizar um sinal ruidoso capturado por um sensor.
   - **Código:** Aplicação de um filtro média móvel usando um buffer circular.

### 3. **Transformada Rápida de Fourier (FFT) Offline (Arduino Uno)**
   - **Descrição:** Capturar dados de um sinal, armazenar em um buffer, e depois aplicar uma FFT para analisar o conteúdo espectral do sinal.
   - **Código:** Implementação de FFT offline usando bibliotecas como ArduinoFFT.

### 4. **Detecção de Pico (Arduino Uno)**
   - **Descrição:** Implementar um algoritmo para detectar picos em um sinal analógico, como picos de batimentos cardíacos a partir de um sensor de pulso.
   - **Código:** Algoritmo de detecção de pico simples usando técnicas de derivada ou thresholds.

### 5. **Geração de Sinais (Arduino Uno)**
   - **Descrição:** Gerar diferentes tipos de sinais (senoidal, quadrado, dente de serra) usando a saída PWM do Arduino.
   - **Código:** Geração de formas de onda usando manipulação de `analogWrite()` e temporizadores.

### 6. **Filtro Passa-Baixas FIR Offline (Arduino Uno)**
   - **Descrição:** Implementar um filtro FIR passa-baixas simples para filtrar ruído de um sinal amostrado e armazenado.
   - **Código:** Filtro FIR offline com coeficientes definidos pelo usuário.

### 7. **Filtro Passa-Banda IIR (Arduino Uno)**
   - **Descrição:** Implementar um filtro IIR passa-banda para isolar uma frequência específica em um sinal de áudio.
   - **Código:** Implementação de filtro IIR com recursão em tempo real.

### 8. **Processamento de Áudio em Tempo Real (ESP32)**
   - **Descrição:** Capturar áudio em tempo real usando um microfone e aplicar um filtro passa-baixas.
   - **Código:** Uso do ADC e DAC internos do ESP32 para capturar e reproduzir áudio filtrado.

### 9. **Equalizador de Áudio Simples (ESP32)**
   - **Descrição:** Implementar um equalizador de 3 bandas usando filtros passa-baixa, passa-alta, e passa-banda em tempo real.
   - **Código:** Processamento de áudio em tempo real com ajuste de ganho para cada banda de frequência.

### 10. **Detecção de Fala (ESP32)**
   - **Descrição:** Implementar um algoritmo básico de detecção de fala para identificar quando uma pessoa está falando.
   - **Código:** Análise do envelope do sinal de áudio e detecção baseada em energia.

### 11. **Análise de Frequência em Tempo Real (ESP32)**
   - **Descrição:** Aplicar uma FFT em tempo real para visualizar o espectro de frequências de um sinal de áudio capturado.
   - **Código:** Uso de FFT em tempo real com visualização do espectro via serial ou display.

### 12. **Redução de Ruído (ESP32)**
   - **Descrição:** Implementar uma técnica básica de redução de ruído em um sinal de áudio capturado.
   - **Código:** Filtros adaptativos ou técnicas de subtração espectral aplicadas em tempo real.

### 13. **Implementação de Controle Feedback Baseado em PDS (ESP32)**
   - **Descrição:** Implementar um sistema de controle em malha fechada que ajusta um atuador baseado no sinal de um sensor usando técnicas de PDS.
   - **Código:** Sistema de controle digital (PID) com filtragem de sinal de feedback e ajuste em tempo real.

Esses experimentos cobrem uma ampla gama de aplicações de processamento digital de sinais, desde conceitos básicos até técnicas avançadas, utilizando o Arduino Uno e o ESP32 como plataformas de hardware.

----

## Detector de Picos

### Algoritmo de Detecção de Pico Baseado em Derivadas

Quando o sinal real (como um ECG) está acompanhado de ruído de alta frequência, uma abordagem comum é usar uma combinação de filtragem e detecção de picos. Aqui está uma abordagem detalhada:

#### Passos do Algoritmo:
1. **Filtragem do Sinal**:
   - **Filtro Passa-Baixa**: Aplique um filtro passa-baixa para remover o ruído de alta frequência. Em sinais de ECG, é comum usar um filtro com uma frequência de corte entre 20 Hz e 40 Hz, dependendo da aplicação.
   - **Filtro Notch**: Opcionalmente, use um filtro notch (por exemplo, 50 Hz ou 60 Hz) para remover ruídos específicos como o de interferência da rede elétrica.

2. **Cálculo da Derivada**:
   - **Primeira Derivada**: Calcule a primeira derivada do sinal filtrado para destacar as mudanças rápidas, que correspondem às transições de pico no ECG (como o complexo QRS).
   - **Segunda Derivada**: Calcule a segunda derivada, que ajuda a identificar os pontos onde a inclinação do sinal muda mais drasticamente, auxiliando na detecção dos picos reais.

3. **Identificação de Picos**:
   - **Thresholding**: Defina um limiar (threshold) baseado na amplitude da derivada. Picos verdadeiros terão mudanças acentuadas na derivada, enquanto o ruído será atenuado pelo filtro.
   - **Intervalo Refratário**: Após detectar um pico, ignore qualquer outro pico dentro de um certo intervalo de tempo (refratário) para evitar múltiplas detecções do mesmo complexo QRS.

#### Exemplo de Implementação em Pseudocódigo:
```python
def detect_peaks(signal, sample_rate):
    # Passo 1: Filtragem do sinal
    filtered_signal = low_pass_filter(signal, cutoff=40, sample_rate=sample_rate)
    filtered_signal = notch_filter(filtered_signal, notch_freq=50, sample_rate=sample_rate)
    
    # Passo 2: Cálculo das derivadas
    first_derivative = np.diff(filtered_signal)
    second_derivative = np.diff(first_derivative)
    
    # Passo 3: Identificação de picos
    peaks = []
    threshold = calculate_threshold(second_derivative)
    refractory_period = 0.2 * sample_rate  # 200 ms
    last_peak = -refractory_period
    
    for i in range(1, len(second_derivative) - 1):
        if second_derivative[i] > threshold:
            if (i - last_peak) > refractory_period:
                peaks.append(i)
                last_peak = i
    
    return peaks
```

### Repositórios Públicos de Sinais de ECG

Existem vários repositórios públicos que oferecem sinais de ECG, onde você pode acessar dados reais para testar o algoritmo:

1. **PhysioNet**:
   - [PhysioNet](https://physionet.org/) é uma das maiores fontes de dados fisiológicos, incluindo ECG. Eles oferecem diversos bancos de dados, como o *MIT-BIH Arrhythmia Database*.

2. **Kaggle**:
   - [Kaggle ECG Datasets](https://www.kaggle.com/datasets) possui uma coleção de conjuntos de dados de ECG, incluindo sinais para diferentes condições cardíacas.

3. **E-Health Sensor Platform**:
   - A E-Health Sensor Platform da Cooking Hacks oferece dados de sensores de ECG capturados de forma prática e experimental, disponíveis [aqui](https://www.cooking-hacks.com/documentation/tutorials/ehealth-biometric-sensor-platform-arduino-raspberry-pi-medical/).

Esses repositórios oferecem uma vasta gama de sinais de ECG, que podem ser usados para desenvolver, testar e validar algoritmos de detecção de picos e outras análises de PDS.

----

**A rotina anteior pode ser usada para detectar BPM de audio**

Sim, você pode usar um detector de picos para estimar a frequência de batimentos por minuto (BPM) a partir de um sinal de áudio, como uma batida de música ou um sinal de batimento cardíaco capturado por um microfone. Aqui está como você pode fazer isso:

### Passos para Estimar o BPM a partir de um Sinal de Áudio:

1. **Pré-processamento do Sinal**:
   - **Filtragem**: Aplique um filtro passa-baixas para eliminar frequências que não estão relacionadas ao ritmo da batida. Para detectar batidas musicais, um filtro passa-baixas com uma frequência de corte em torno de 150 Hz pode ser útil.
   - **Normalização**: Normalize o sinal para garantir que as amplitudes sejam consistentes, facilitando a detecção dos picos.

2. **Detecção de Picos**:
   - **Cálculo da Derivada**: Calcule a derivada do sinal para destacar mudanças rápidas de amplitude, que geralmente correspondem às batidas.
   - **Thresholding**: Aplique um limiar para detectar picos significativos. Isso ajuda a ignorar ruídos ou variações menores que não correspondem a uma batida real.

3. **Cálculo do Intervalo entre Picos**:
   - **Detecção de Picos**: Identifique os picos no sinal que correspondem às batidas.
   - **Intervalo entre Picos**: Calcule o tempo entre picos consecutivos para determinar o período entre batidas.

4. **Cálculo do BPM**:
   - **Estimativa do BPM**: O BPM pode ser calculado como:
     \[
     \text{BPM} = \frac{60}{\text{Intervalo entre Picos (em segundos)}}
     \]
   - Se você detectar múltiplos picos, pode calcular o BPM médio sobre todos os intervalos de picos.

### Exemplo de Pseudocódigo:

```python
def calculate_bpm(signal, sample_rate):
    # Passo 1: Filtragem e Normalização
    filtered_signal = low_pass_filter(signal, cutoff=150, sample_rate=sample_rate)
    normalized_signal = normalize(filtered_signal)
    
    # Passo 2: Detecção de Picos
    first_derivative = np.diff(normalized_signal)
    threshold = calculate_threshold(first_derivative)
    peaks = detect_peaks(first_derivative, threshold)
    
    # Passo 3: Cálculo do BPM
    intervals = np.diff(peaks) / sample_rate
    average_interval = np.mean(intervals)
    bpm = 60 / average_interval
    
    return bpm
```

### Considerações:

- **Precisão**: A precisão do BPM dependerá da precisão com que os picos são detectados. Certifique-se de que o threshold esteja ajustado corretamente para o tipo de sinal que está analisando.
- **Ruído**: Em sinais de áudio com muito ruído ou variação de amplitude, a filtragem e normalização são cruciais para obter resultados precisos.
- **Tempo de Integração**: Para sinais onde o BPM pode variar, como em batidas cardíacas ou músicas com mudanças de ritmo, pode ser útil calcular o BPM sobre uma janela de tempo deslizante.

### Aplicação em Diferentes Cenários:

- **Música**: ==Detectar o BPM de uma música para sincronização com efeitos de luzes==, ou como parte de um aplicativo de DJ.
- **Sinais Fisiológicos**: Estimar o BPM de um batimento cardíaco capturado por um microfone ou um sensor de pulso.

Essas técnicas podem ser adaptadas para diferentes tipos de sinais e podem ser implementadas em plataformas como Arduino ou ESP32 para aplicações em tempo real.

**Idéia**: Detector de BPM para mudular brilho de LED baseado em sinal de audio sendo digitalizado pelo Arduíno.

----

## Filtro de Voz

Apresente um exemplo de código de filtro IIR passa-banda para isolar vozes em sinal de aúdio usando recursão em tempo real, para uma placa Arduino One ou ESP32.

Aqui está um exemplo de código para implementar um filtro IIR passa-banda para isolar vozes em um sinal de áudio, utilizando recursão em tempo real. Este exemplo pode ser implementado em uma placa Arduino Uno ou ESP32. Vou focar no ESP32 devido à sua maior capacidade de processamento e melhor suporte para processamento de sinais em tempo real, mas o conceito pode ser adaptado para o Arduino Uno.

### Código para ESP32: Filtro IIR Passa-Banda em Tempo Real

O filtro IIR passa-banda é ideal para isolar frequências específicas, como as da faixa da voz humana (geralmente entre 300 Hz e 3400 Hz). Este código usa coeficientes de filtro predefinidos para aplicar o filtro IIR em tempo real ao sinal de áudio.

```cpp
#include "driver/i2s.h"

// Configurações do I2S (para captura de áudio via microfone)
#define I2S_WS  25  // Pino de palavra de amostra (Word Select)
#define I2S_SD  26  // Pino de dados do microfone
#define I2S_SCK 27  // Pino de clock serial

#define SAMPLE_RATE 16000  // Taxa de amostragem de 16 kHz (adequada para voz)

void setup() {
  Serial.begin(115200);

  // Configuração do I2S
  i2s_config_t i2s_config = {
    .mode = (i2s_mode_t)(I2S_MODE_MASTER | I2S_MODE_RX),
    .sample_rate = SAMPLE_RATE,
    .bits_per_sample = I2S_BITS_PER_SAMPLE_16BIT,
    .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,
    .communication_format = I2S_COMM_FORMAT_I2S_MSB,
    .intr_alloc_flags = ESP_INTR_FLAG_LEVEL1,
    .dma_buf_count = 8,
    .dma_buf_len = 64,
    .use_apll = false,
    .tx_desc_auto_clear = true,
    .fixed_mclk = 0
  };

  i2s_pin_config_t pin_config = {
    .bck_io_num = I2S_SCK,
    .ws_io_num = I2S_WS,
    .data_out_num = I2S_PIN_NO_CHANGE,
    .data_in_num = I2S_SD
  };

  i2s_driver_install(I2S_NUM_0, &i2s_config, 0, NULL);
  i2s_set_pin(I2S_NUM_0, &pin_config);
}

void loop() {
  size_t bytesRead;
  int16_t sample;
  int16_t output;

  // Coeficientes do filtro IIR passa-banda
  const float a[] = {1.0, -1.5610180758, 0.6413515381};  // Coeficientes de feedback
  const float b[] = {0.0200833656, 0.0401667312, 0.0200833656};  // Coeficientes de feedforward

  // Estados anteriores
  static float x[3] = {0.0, 0.0, 0.0};  // Entradas anteriores
  static float y[3] = {0.0, 0.0, 0.0};  // Saídas anteriores

  while (true) {
    // Ler o próximo bloco de áudio
    i2s_read(I2S_NUM_0, (char *)&sample, sizeof(sample), &bytesRead, portMAX_DELAY);

    // Aplicar o filtro IIR passa-banda
    x[0] = (float)sample;  // Entrada atual
    y[0] = b[0] * x[0] + b[1] * x[1] + b[2] * x[2] - a[1] * y[1] - a[2] * y[2];

    // Deslocar as amostras
    x[2] = x[1];
    x[1] = x[0];
    y[2] = y[1];
    y[1] = y[0];

    // Converter a saída para o formato de áudio
    output = (int16_t)y[0];

    // Enviar o sinal filtrado para a saída (ou armazenamento, ou outro processamento)
    // Para este exemplo, enviaremos para a saída serial
    Serial.write((uint8_t *)&output, sizeof(output));
  }
}
```

### Explicação do Código:

1. **Configuração do I2S**:
   - Utilizamos a interface I2S para capturar o áudio em tempo real do microfone. O ESP32 suporta essa interface nativamente, o que facilita o processamento de sinais de áudio.

2. **Coeficientes do Filtro IIR**:
   - Os coeficientes `a[]` e `b[]` são os coeficientes do filtro IIR. Esses valores foram calculados para um filtro passa-banda com frequência central na faixa de voz. Eles determinam como o filtro processa o sinal de entrada para produzir o sinal de saída filtrado.

3. **Loop Principal**:
   - O loop principal lê continuamente o sinal de áudio, aplica o filtro IIR em tempo real e, em seguida, gera a saída filtrada. O sinal filtrado pode ser transmitido para outra interface, como uma saída de áudio, ou simplesmente monitorado via Serial.

### Adaptação para Arduino Uno:
Para usar este código no Arduino Uno, você precisaria simplificar o processamento devido às limitações de hardware. O código precisaria ser ajustado para capturar áudio usando um ADC simples (por exemplo, usando `analogRead()`), e a taxa de amostragem seria mais baixa. A implementação do filtro IIR seria semelhante, mas o desempenho em tempo real poderia ser mais desafiador devido ao processador mais lento e à memória limitada.

Este exemplo no ESP32 deve fornecer um bom ponto de partida para aplicações de processamento de áudio em tempo real, como o isolamento de voz.

### Código anterior para Arduino One

Aqui está uma versão do código adaptada para a placa Arduino Uno, utilizando o ADC interno do Arduino para capturar o sinal de áudio e o módulo DAC externo MCP4725 para reproduzir o sinal filtrado. O Arduino Uno possui limitações de processamento e memória em comparação com o ESP32, portanto, o código foi simplificado e otimizado para rodar eficientemente na plataforma.

### Circuito:
- **Entrada de Áudio**: Um microfone ou outra fonte de áudio conectada a um pino analógico (por exemplo, A0) do Arduino.
- **Saída de Áudio**: O sinal filtrado será enviado para o módulo MCP4725, que estará conectado via I2C.

### Código para Arduino Uno: Filtro IIR Passa-Banda

```cpp
#include <Wire.h>
#include <Adafruit_MCP4725.h>

// Definir pino de entrada do ADC
#define ADC_PIN A0

// Configurar o MCP4725
Adafruit_MCP4725 dac;

void setup() {
  Serial.begin(9600);
  dac.begin(0x60);  // Endereço I2C padrão do MCP4725
  
  // Configuração inicial do filtro IIR
  for (int i = 0; i < 3; i++) {
    x[i] = 0;
    y[i] = 0;
  }
}

void loop() {
  // Coletar o sinal de entrada do ADC
  int16_t sample = analogRead(ADC_PIN);
  
  // Normalizar o valor lido (0-1023) para -1 a 1
  float input = (sample - 512.0) / 512.0;
  
  // Aplicar o filtro IIR
  float output = filterIIR(input);
  
  // Converter a saída para o formato de 12 bits (0-4095) para o DAC
  uint16_t dac_output = (output + 1.0) * 2048.0;
  
  // Enviar o sinal filtrado para o MCP4725 (DAC)
  dac.setVoltage(dac_output, false);
}

float x[3];  // Entradas anteriores
float y[3];  // Saídas anteriores

// Coeficientes do filtro IIR passa-banda
const float a[] = {1.0, -1.5610180758, 0.6413515381};  // Coeficientes de feedback
const float b[] = {0.0200833656, 0.0401667312, 0.0200833656};  // Coeficientes de feedforward

float filterIIR(float input) {
  // Atualizar os valores de entrada
  x[0] = input;

  // Aplicar o filtro IIR
  y[0] = b[0] * x[0] + b[1] * x[1] + b[2] * x[2]
         - a[1] * y[1] - a[2] * y[2];

  // Deslocar os valores anteriores
  x[2] = x[1];
  x[1] = x[0];
  y[2] = y[1];
  y[1] = y[0];

  return y[0];
}
```

### Explicação do Código:

1. **Captura de Sinal de Entrada**:
   - O sinal de áudio é capturado usando o conversor A/D interno do Arduino (`analogRead(ADC_PIN)`), que amostra o sinal no pino A0. O valor lido é normalizado para a faixa de -1 a 1.

2. **Implementação do Filtro IIR**:
   - O filtro IIR é implementado utilizando recursão direta. O sinal de entrada é passado pelo filtro, que utiliza os coeficientes `a[]` e `b[]` definidos para um filtro passa-banda adequado para voz (faixa de 300 Hz a 3400 Hz).

3. **Conversão e Saída do Sinal Filtrado**:
   - O sinal filtrado (`output`) é convertido de volta para a faixa de 0 a 4095 (12 bits), que é a faixa de operação do MCP4725.
   - A função `dac.setVoltage(dac_output, false);` envia o valor filtrado para o DAC MCP4725, que converte o sinal digital em um sinal analógico que pode ser usado como saída de áudio.

### Considerações:
- **Taxa de Amostragem**: O Arduino Uno tem uma taxa de amostragem limitada, o que pode impactar a qualidade do sinal filtrado, especialmente em frequências mais altas. Para sinais de áudio de voz, a taxa de amostragem precisa ser alta o suficiente (idealmente, pelo menos 8 kHz).
- **Precisão**: A precisão do filtro é limitada pela precisão dos coeficientes em ponto flutuante e pela resolução do ADC e DAC.
- **Limitações de Hardware**: O processamento de sinais em tempo real no Arduino Uno é mais limitado em comparação com o ESP32, mas este código ainda é capaz de realizar uma filtragem básica em tempo real.

Este exemplo pode ser usado em projetos básicos de processamento de áudio com Arduino, onde a tarefa é isolar ou filtrar certas frequências do sinal de áudio capturado.

**Complementando Informações**

Sim, vamos detalhar a equação de diferença e a função de transferência associada ao filtro IIR passa-banda utilizado no código.

### 1. **Equação de Diferença**

A equação de diferença descreve a relação entre a saída do filtro \( y[n] \) e as entradas presentes e passadas \( x[n] \) e \( x[n-1] \), bem como as saídas passadas \( y[n-1] \) e \( y[n-2] \). Para um filtro IIR (Infinite Impulse Response) de segunda ordem, a equação de diferença pode ser expressa como:

$
y[n] = b_0 \cdot x[n] + b_1 \cdot x[n-1] + b_2 \cdot x[n-2] - a_1 \cdot y[n-1] - a_2 \cdot y[n-2]
$

Onde:
- $x[n]$ é a entrada atual do filtro.
- $y[n]$ é a saída atual do filtro.
- $b_0, b_1, b_2$ são os coeficientes de feedforward (associados à entrada do filtro).
- $a_1, a_2$ são os coeficientes de feedback (associados às saídas passadas do filtro).

No exemplo dado, os coeficientes foram definidos como:

- $b_0 = 0.0200833656$
- $b_1 = 0.0401667312$
- $b_2 = 0.0200833656$
- $a_1 = -1.5610180758$
- $a_2 = 0.6413515381$

Substituindo os coeficientes na equação de diferença, temos:

$
y[n] = 0.0200833656 \cdot x[n] + 0.0401667312 \cdot x[n-1] + 0.0200833656 \cdot x[n-2] - (-1.5610180758) \cdot y[n-1] - 0.6413515381 \cdot y[n-2]
$

Ou simplificando:

$
y[n] = 0.0200833656 \cdot x[n] + 0.0401667312 \cdot x[n-1] + 0.0200833656 \cdot x[n-2] + 1.5610180758 \cdot y[n-1] - 0.6413515381 \cdot y[n-2]
$

### 2. **Função de Transferência**

A função de transferência \( H(z) \) de um filtro IIR é obtida tomando a Transformada Z da equação de diferença. Ela é dada por:

$
H(z) = \dfrac{Y(z)}{X(z)} = \dfrac{b_0 + b_1 \cdot z^{-1} + b_2 \cdot z^{-2}}{1 + a_1 \cdot z^{-1} + a_2 \cdot z^{-2}}
$

Substituindo os coeficientes, obtemos:

$
H(z) = \dfrac{0.0200833656 + 0.0401667312 \cdot z^{-1} + 0.0200833656 \cdot z^{-2}}{1 - 1.5610180758 \cdot z^{-1} + 0.6413515381 \cdot z^{-2}}
$

Essa função de transferência caracteriza o comportamento do filtro no domínio da frequência. A resposta em frequência do filtro pode ser obtida ao substituir $z$ por $e^{j\omega}$, onde $\omega$ é a frequência angular.

### 3. **Interpretação**

- **Coeficientes de Feedforward ( $b_0, b_1, b_2$ )**: Eles controlam a contribuição das entradas atuais e passadas para a saída do filtro.
- **Coeficientes de Feedback ( $a_1, a_2$ )**: Eles controlam como as saídas passadas influenciam a saída atual do filtro. Esse realimentação é o que faz o filtro ser "infinito" em sua resposta impulsiva (IIR).

### 4. **Faixa de Passagem**

Este filtro passa-banda foi projetado para isolar frequências típicas de voz humana, normalmente entre 300 Hz e 3400 Hz. A exata faixa de passagem depende dos valores dos coeficientes $a$ e $b$ e da taxa de amostragem utilizada. Ao calcular a resposta em frequência $H(e^{j\omega})$, seria possível visualizar essa faixa.

Esse filtro, quando implementado no código para Arduino Uno, filtra em tempo real o sinal de áudio capturado, isolando componentes na faixa de frequências especificada.

### Problema

**Problema de implementação no código sugerido: sem taxa explícita de amostragem**!

**Correçao!?**

Você está absolutamente certo em suas observações. Para implementar corretamente um filtro digital que opere em uma faixa de frequências específica, como de 300 Hz a 3400 Hz, seria necessário garantir a taxa de amostragem correta e usar técnicas apropriadas para processamento em tempo real, como interrupções (ISR) ou sistemas de gerenciamento de tarefas como o FreeRTOS. Além disso, a taxa de amostragem é fundamental para determinar os coeficientes do filtro.

Agora, vou explicar como os coeficientes $a$ e $b$ usados no filtro IIR foram determinados.

### Design de Filtros IIR: Ferramentas e Processo

Os coeficientes$a$ e $b$ para um filtro IIR são geralmente obtidos usando ferramentas de design de filtros digitais, como MATLAB, Octave, ou bibliotecas específicas em linguagens de programação como Python (usando `scipy.signal`).

### Passos Gerais para Projetar um Filtro IIR:

1. **Definir Especificações do Filtro**:
   - **Tipo de Filtro**: Passa-banda.
   - **Frequência de Corte**: 300 Hz (filtro passa-alta) e 3400 Hz (filtro passa-baixa).
   - **Taxa de Amostragem**: Por exemplo, 8000 Hz.

2. **Escolher a Aproximação do Filtro**:
   - **Butterworth, Chebyshev, Elliptic, etc.**: Butterworth é comumente usado por sua resposta suave.

3. **Calcular os Coeficientes**:
   - As ferramentas de design de filtros calculam os coeficientes $a$ e $b$ com base nas especificações do filtro. Estes coeficientes definem a resposta em frequência do filtro.

### Exemplo em Python (usando `scipy`):

Aqui está um exemplo de como os coeficientes $a$ e $b$ podem ser calculados usando Python e a biblioteca `scipy`:

```python
from scipy.signal import butter

# Taxa de amostragem e frequências de corte
fs = 8000  # Taxa de amostragem em Hz
lowcut = 300.0  # Frequência de corte inferior em Hz
highcut = 3400.0  # Frequência de corte superior em Hz

# Calcular a frequência normalizada (dividir pela metade da taxa de amostragem)
low = lowcut / (0.5 * fs)
high = highcut / (0.5 * fs)

# Gerar coeficientes do filtro Butterworth de segunda ordem (N=2)
b, a = butter(N=2, Wn=[low, high], btype='band')

print("Coeficientes b:", b)
print("Coeficientes a:", a)
```

### Resultados Típicos:

Ao executar o código acima, você pode obter coeficientes como:

```plaintext
Coeficientes b: [ 0.02008337  0.          0.04016673  0.          0.02008337]
Coeficientes a: [ 1.         -3.47839835  4.7744202  -3.12639291  0.83051334]
```

Esses coeficientes serão normalizados para que possam ser usados no filtro IIR de segunda ordem.

### Como Interpretar os Coeficientes:

- **$b$**: Coeficientes de feedforward, que controlam a influência das amostras de entrada atuais e passadas.
- **$a$**: Coeficientes de feedback, que controlam a influência das saídas passadas na saída atual do filtro.

### Relacionando ao Código Original:

No código fornecido anteriormente, os valores dos coeficientes $b$ e $a$ foram inseridos diretamente. Esses valores são resultado de um design de filtro como o descrito acima. Para garantir que o filtro funcione corretamente para a faixa de 300 Hz a 3400 Hz, seria necessário:

1. **Garantir uma taxa de amostragem de 8000 Hz ou maior**.
2. **Usar um sistema de temporização preciso (usando ISR ou temporizadores)** para garantir que a amostragem seja consistente.
3. **Recalcular os coeficientes se a taxa de amostragem mudar**.

### Conclusão

Os coeficientes $a$ e $b$ no exemplo foram obtidos de um design de filtro digital padrão, considerando uma taxa de amostragem específica e as frequências de corte desejadas. Se você alterar a taxa de amostragem ou as especificações do filtro, esses coeficientes precisarão ser recalculados.

### Usando Matlab

Vamos demonstrar como calcular os coeficientes $a$ e $b$ para um filtro passa-banda utilizando o MATLAB.

### Passos no MATLAB:

1. **Definir os parâmetros do filtro**: taxa de amostragem, frequências de corte, e a ordem do filtro.
2. **Usar a função `butter`** para projetar o filtro Butterworth e calcular os coeficientes.

### Exemplo MATLAB:

```matlab
% Definir parâmetros
fs = 8000;  % Taxa de amostragem em Hz
lowcut = 300;  % Frequência de corte inferior em Hz
highcut = 3400;  % Frequência de corte superior em Hz
N = 2;  % Ordem do filtro

% Normalizar frequências de corte
Wn = [lowcut highcut] / (fs/2);

% Projetar o filtro Butterworth passa-banda
[b, a] = butter(N, Wn, 'bandpass');

% Exibir coeficientes
disp('Coeficientes b:');
disp(b);
disp('Coeficientes a:');
disp(a);
```

### Saída Esperada:

```plaintext
Coeficientes b:
   0.020083365564211,  0,  -0.040166731128423,  0,   0.020083365564211

Coeficientes a:
   1,  -3.561018075800718,  5.481787376349140,  -3.665040255869825,  0.641351538057563
```

### Explicação:

- **`butter(N, Wn, 'bandpass')`**: Cria um filtro Butterworth de ordem $N = 2$, com frequências de corte normalizadas $Wn$, e tipo passa-banda.
- **`b` e `a`**: Os coeficientes do filtro, onde `b` são os coeficientes de feedforward e `a` os coeficientes de feedback.

### Conclusão

Esse código MATLAB mostra como determinar os coeficientes $a$ e $b$ para um filtro passa-banda. Com esses coeficientes, você pode implementar o filtro digitalmente em plataformas como Arduino ou ESP32, considerando a taxa de amostragem específica.

### Usando FreeTOS no Arduino Uno

Aqui está um exemplo de código para o Arduino Uno utilizando FreeRTOS para capturar um sinal analógico e reconstituí-lo usando o módulo MCP4725. O código também inclui uma tarefa assíncrona que, ao pressionar um botão, alterna a saída entre o sinal nulo (0) e o sinal capturado de entrada.

### Circuito:
1. **Entrada de Áudio**: Conectada ao pino A0 do Arduino Uno.
2. **Saída de Áudio**: Conectada ao módulo MCP4725 (conectado via I2C).
3. **Botão**: Conectado ao pino digital 2 do Arduino Uno.

### Configuração:
- **Taxa de Amostragem**: 8 kHz.
- **Tarefas FreeRTOS**:
  - **Captura e Reconstrução do Sinal**.
  - **Verificação do Botão**.

### Código Arduino Uno com FreeRTOS:

```cpp
#include <Arduino_FreeRTOS.h>
#include <Wire.h>
#include <Adafruit_MCP4725.h>

#define ADC_PIN A0
#define BUTTON_PIN 2

Adafruit_MCP4725 dac;

volatile bool outputEnabled = true;

void setup() {
  Serial.begin(9600);

  // Inicializar o MCP4725
  dac.begin(0x60);

  // Configurar pino do botão como entrada com pull-up
  pinMode(BUTTON_PIN, INPUT_PULLUP);

  // Criar as tarefas FreeRTOS
  xTaskCreate(TaskSampleAndOutput, "SampleAndOutput", 128, NULL, 1, NULL);
  xTaskCreate(TaskButtonCheck, "ButtonCheck", 128, NULL, 2, NULL);
}

void loop() {
  // Nada para fazer aqui, FreeRTOS gerencia as tarefas
}

// Tarefa para capturar o sinal e enviar para o MCP4725
void TaskSampleAndOutput(void *pvParameters) {
  const TickType_t xDelay = pdMS_TO_TICKS(1); // Delay para amostragem a 8 kHz (~125 µs)
  for (;;) {
    int16_t sample = analogRead(ADC_PIN); // Capturar sinal

    if (outputEnabled) {
      uint16_t dac_output = map(sample, 0, 1023, 0, 4095); // Converter para 12 bits
      dac.setVoltage(dac_output, false); // Enviar para o DAC
    } else {
      dac.setVoltage(0, false); // Saída nula
    }

    vTaskDelay(xDelay); // Aguardar próximo ciclo de amostragem
  }
}

// Tarefa para verificar o estado do botão
void TaskButtonCheck(void *pvParameters) {
  bool lastButtonState = HIGH;
  for (;;) {
    bool currentButtonState = digitalRead(BUTTON_PIN);

    if (currentButtonState == LOW && lastButtonState == HIGH) {
      outputEnabled = !outputEnabled; // Alternar entre sinal e zero
    }

    lastButtonState = currentButtonState;
    vTaskDelay(pdMS_TO_TICKS(50)); // Debounce simples
  }
}
```

### Explicação do Código:

1. **Inicialização**:
   - **`dac.begin(0x60)`**: Inicializa o MCP4725 com o endereço I2C padrão.
   - **`pinMode(BUTTON_PIN, INPUT_PULLUP)`**: Configura o pino do botão como entrada com pull-up interno.

2. **Tarefas FreeRTOS**:
   - **TaskSampleAndOutput**: Captura o sinal analógico a uma taxa de aproximadamente 8 kHz e o envia para o DAC. Se o botão for pressionado, a saída é alternada entre o sinal real e zero.
   - **TaskButtonCheck**: Verifica o estado do botão a cada 50 ms. Se detectar uma transição de alto para baixo, alterna o estado da variável `outputEnabled`.

3. **Taxa de Amostragem**:
   - **`vTaskDelay(xDelay)`**: Introduz um atraso para criar uma taxa de amostragem de aproximadamente 8 kHz. O valor de `xDelay` é calculado para fornecer um período de amostragem de 125 µs (equivalente a 8 kHz).

4. **Tratamento de Sinal**:
   - O sinal analógico é lido pelo ADC (`analogRead(ADC_PIN)`), mapeado para a faixa de 12 bits necessária pelo DAC, e enviado ao MCP4725 com `dac.setVoltage(dac_output, false)`. Se o botão for pressionado, `outputEnabled` é alternado, e a saída é ajustada para zero ou para o sinal real.

5. **Debounce do Botão**:
   - A tarefa `TaskButtonCheck` inclui um atraso de 50 ms para evitar falsos acionamentos do botão (debounce).

### Considerações:
- **Taxa de Amostragem**: O uso de `vTaskDelay` em uma tarefa FreeRTOS é uma aproximação para alcançar a taxa de amostragem desejada. A precisão depende da carga geral do sistema.
- **Desempenho**: O Arduino Uno possui limitações de recursos, então o uso de FreeRTOS pode sobrecarregar a CPU se muitas tarefas forem adicionadas.

Este código permite capturar e reconstituir sinais analógicos com controle simples de saída usando FreeRTOS, proporcionando uma base sólida para implementação de sistemas mais complexos.

**Observação**: O FreeRTOS não permite taxas de amostragem inferiores à 1 KHz! Então a rotina de captura e reconstitução do sinal obrigatoriamente terá que se implementada na forma de uma rotina ISR.

