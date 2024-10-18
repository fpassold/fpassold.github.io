# Detecção de Picos

[toc]

----

## Versão "1": Método "Simples"

Para detectar a distância entre dois picos máximos de um sinal no Arduino, considerando um "vale de descida" entre os picos, é possível utilizar o seguinte algoritmo:

1. **Captura do Sinal**: Leia os dados do sinal usando o conversor A/D do Arduino.
2. **Detecção de Máximos**: Detecte os picos máximos, levando em conta o `width_min` para desconsiderar picos muito próximos.
3. **Verificação de Vale de Descida**: Certifique-se de que há um "vale" entre os picos, ou seja, que o sinal caiu abaixo de um certo limiar antes de encontrar um novo pico.

O código abaixo implementa essa lógica:

```c
#define NUM_SAMPLES 100    // Número de amostras a capturar
#define THRESHOLD 512      // Limiar para considerar um pico
#define WIDTH_MIN 20       // Distância mínima entre os picos
#define ANALOG_PIN A0      // Pino analógico para leitura

int samples[NUM_SAMPLES];    // Array para armazenar as amostras
int lastPeakIndex = -1;      // Índice do último pico máximo encontrado

void setup() {
    Serial.begin(9600);
}

void loop() {
    // Captura os dados do sinal
    for (int i = 0; i < NUM_SAMPLES; i++) {
        samples[i] = analogRead(ANALOG_PIN);
        delay(10); // Delay para simular a aquisição do sinal
    }

    detectPicos(samples, NUM_SAMPLES);
    
    // Aguarda um tempo antes de nova leitura
    delay(1000);
}

void detectPicos(int *data, int length) {
    for (int i = 1; i < length - 1; i++) {
        // Verifica se é um pico máximo
        if (data[i] > data[i - 1] && data[i] > data[i + 1] && data[i] > THRESHOLD) {
            // Verifica se o pico está distante o suficiente do último pico
            if (lastPeakIndex == -1 || (i - lastPeakIndex) >= WIDTH_MIN) {
                Serial.print("Pico encontrado em: ");
                Serial.print(i);
                Serial.print(" com valor: ");
                Serial.println(data[i]);

                lastPeakIndex = i; // Atualiza o índice do último pico
            }
        }
    }
}
```

**Explicação do Código:**

1. **Definições**:
   - `NUM_SAMPLES`: O número de amostras a capturar.
   - `THRESHOLD`: O limiar acima do qual um valor é considerado um pico máximo.
   - `WIDTH_MIN`: O número mínimo de amostras entre dois picos.
   - `ANALOG_PIN`: O pino A0 do Arduino para ler o sinal.

2. **Setup**:
   - Inicia a comunicação serial.

3. **Loop Principal**:
   - Captura as amostras do sinal em um array.
   - Chama a função `detectPicos` para verificar os picos.

4. **Função `detectPicos`**:
   - Percorre as amostras e verifica se o valor atual é um pico máximo, comparando com seus vizinhos.
   - Verifica se o último pico detectado está suficientemente distante, utilizando `width_min`.
   - Se um novo pico for encontrado, ele é impresso no console serial e o índice do pico é atualizado.

Note que o código anterior não calcula a distância entre 2 picos máximos.

## Versão "2": Usando Derivadas

Note que:

- Para melhorar a robustez da detecção, você pode considerar o cálculo da **primeira derivada** (ou diferenças entre amostras consecutivas) para confirmar que o sinal realmente está subindo antes de detectar um pico.
- A **derivada segunda** pode ser usada para verificar a concavidade, mas para casos básicos, a lógica acima deve ser suficiente para a detecção de picos em um sinal típico.

Para determinar a distância em número de amostras entre dois picos máximos de um sinal, você pode modificar o código anterior. Em vez de imprimir o valor de cada pico, você irá armazenar a distância entre o último pico encontrado e o atual. O código atualizado ficaria assim:

```c
#define NUM_SAMPLES 100    // Número de amostras a capturar
#define THRESHOLD 512      // Limiar para considerar um pico
#define WIDTH_MIN 20       // Distância mínima entre os picos
#define ANALOG_PIN A0      // Pino analógico para leitura

int samples[NUM_SAMPLES];    // Array para armazenar as amostras
int lastPeakIndex = -1;      // Índice do último pico máximo encontrado

void setup() {
    Serial.begin(9600);
}

void loop() {
    // Captura os dados do sinal
    for (int i = 0; i < NUM_SAMPLES; i++) {
        samples[i] = analogRead(ANALOG_PIN);
        delay(10); // Delay para simular a aquisição do sinal
    }

    int distance = detectPicos(samples, NUM_SAMPLES);
    
    // Mostra a distância entre picos, se um novo pico foi encontrado
    if (distance >= 0) {
        Serial.print("Distância entre picos: ");
        Serial.println(distance);
    }

    // Aguarda um tempo antes de nova leitura
    delay(1000);
}

int detectPicos(int *data, int length) {
    for (int i = 1; i < length - 1; i++) {
        // Verifica se é um pico máximo
        if (data[i] > data[i - 1] && data[i] > data[i + 1] && data[i] > THRESHOLD) {
            // Verifica se o pico está distante o suficiente do último pico
            if (lastPeakIndex == -1 || (i - lastPeakIndex) >= WIDTH_MIN) {
                int distance = (lastPeakIndex == -1) ? 0 : (i - lastPeakIndex);
                lastPeakIndex = i; // Atualiza o índice do último pico
                return distance;    // Retorna a distância entre os picos
            }
        }
    }
    return -1; // Retorna -1 se nenhum novo pico foi encontrado
}
```

**Detalhes do código**:

1. **Detecção de Picos**:
   - A função `detectPicos` agora retorna a distância em número de amostras entre dois picos.
   - Se um novo pico for detectado e estiver a uma distância maior ou igual a `WIDTH_MIN` do último pico, a distância entre eles é calculada e retornada.

2. **Loop Principal**:
   - Após a chamada de `detectPicos`, se uma distância válida for retornada, ela é impressa no console serial.

3. **Retorno de Distância**:
   - Se um pico é encontrado, a distância entre o último pico e o atual é calculada. Caso contrário, a função retorna -1.

**Observações:**

- Você deve ajustar `THRESHOLD` e `WIDTH_MIN` para melhor se adaptar ao seu sinal (adequando às características do sinal que está analisando.)
- Certifique-se de que o sinal lido esteja bem definido para garantir a detecção correta dos picos.

## Considerando Derivadas Consecutivas

Para incluir a abordagem de derivadas no código de detecção de picos, você pode calcular a primeira derivada (ou diferença entre amostras consecutivas) para identificar quando o sinal está subindo ou descendo. Isso pode ajudar a garantir que um pico seja detectado apenas após uma subida e uma descida, confirmando a formação de um pico verdadeiro.

Aqui está uma versão do código que implementa essa abordagem:

```c
#define NUM_SAMPLES 100    // Número de amostras a capturar
#define THRESHOLD 512      // Limiar para considerar um pico
#define WIDTH_MIN 20       // Distância mínima entre os picos
#define ANALOG_PIN A0      // Pino analógico para leitura

int samples[NUM_SAMPLES];    // Array para armazenar as amostras
int lastPeakIndex = -1;      // Índice do último pico máximo encontrado

void setup() {
    Serial.begin(9600);
}

void loop() {
    // Captura os dados do sinal
    for (int i = 0; i < NUM_SAMPLES; i++) {
        samples[i] = analogRead(ANALOG_PIN);
        delay(10); // Delay para simular a aquisição do sinal
    }

    int distance = detectPicos(samples, NUM_SAMPLES);
    
    // Mostra a distância entre picos, se um novo pico foi encontrado
    if (distance >= 0) {
        Serial.print("Distância entre picos: ");
        Serial.println(distance);
    }

    // Aguarda um tempo antes de nova leitura
    delay(1000);
}

int detectPicos(int *data, int length) {
    // Variável para armazenar o valor da primeira derivada
    int derivativePrev = data[1] - data[0];

    for (int i = 1; i < length - 1; i++) {
        // Calcula a primeira derivada
        int derivativeCurr = data[i + 1] - data[i];

        // Verifica se é um pico máximo
        if (derivativePrev > 0 && derivativeCurr < 0 && data[i] > THRESHOLD) {
            // Verifica se o pico está distante o suficiente do último pico
            if (lastPeakIndex == -1 || (i - lastPeakIndex) >= WIDTH_MIN) {
                int distance = (lastPeakIndex == -1) ? 0 : (i - lastPeakIndex);
                lastPeakIndex = i; // Atualiza o índice do último pico
                return distance;    // Retorna a distância entre os picos
            }
        }

        derivativePrev = derivativeCurr; // Atualiza a derivada anterior
    }
    return -1; // Retorna -1 se nenhum novo pico foi encontrado
}
```

**Detalhes do Código**:

1. **Cálculo das Derivadas Consecutivas**:
   - A primeira derivada é calculada como a diferença entre amostras consecutivas (`derivativeCurr`).
   - A variável `derivativePrev` armazena o valor da derivada da iteração anterior.

2. **Detecção de Pico**:
   - Um pico é detectado quando a derivada anterior é positiva (indicando que o sinal estava subindo) e a derivada atual é negativa (indicando que o sinal começou a descer), juntamente com a condição de que o valor do sinal é maior que o `THRESHOLD`.

3. **Cálculo da Distância**:
   - Se um novo pico é detectado e está suficientemente distante do último pico (`WIDTH_MIN`), a distância é calculada e retornada.

## Benefícios da Abordagem de Derivadas:

- Essa abordagem ajuda a garantir que você esteja detectando picos verdadeiros, reduzindo a probabilidade de detectar picos falsos que podem ocorrer devido a ruídos ou variações rápidas no sinal.
- A implementação é ainda mais robusta, pois leva em conta o comportamento do sinal em relação à sua taxa de mudança.



----

<font size="2">🌊 [Fernando Passold](https://fpassold.github.io/)[ 📬 ](mailto:fpassold@gmail.com), <script language="JavaScript"><!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("página criada em Oct 15, 2024; atualizada em " + LastUpdated); // End Hiding -->
</script></font>