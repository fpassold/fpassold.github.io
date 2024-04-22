# Setup para uso de PID em Arduino Uno

Para as aulas de controle digital usando kits Feedback ainda presentes no Laboratório de Controle do Curso de Engenharia Elétrica da UPF, foram desenvolvidas algumas placas extras para possibilitar a ligação de uma placa Arduino Uno à estes kits.

A figura abaixo mostra a montagem de uma malha-fechada de [controle de posição angular usando kits da marca inglesa Feedback com PID analógico](https://fpassold.github.io/Lab_Controle_2/controle_posicao.html):

![kit](https://fpassold.github.io/Lab_Controle_2/figs/controle_posicao_com_PID.jpg)

Na figura anterior, na parte inferior central está ressaltando o PID analógico. O diagrama de blocos equivalente ao sistema acima aparece abaixo:

![blocos](https://fpassold.github.io/Lab_Controle_2/figs/controle_posicao_kit_feedback.drawio.png)

Mas para as aulas práticas de controle digital, a idéia é executar uma **versão digital do PID**.

Para tanto, os seguintes componentes são necessários:

* Placa Arduino Uno comum;
* Módulo DAC/I2C **MPC4725** - para saber como usar/instalar, clique [[aqui]](https://fpassold.github.io/Lab_Controle_2/PID_Digital/modulo_DAC.html);
* Filtros Passa-Baixa com frequência de corte em $f_c=$ 50 Hz, para prever efeitos de *aliasing*;
* Placa acondicionadora de sinais para o A/D do Arduíno;
* Placa acondicionado do sinal de saída do DAC incorporado ao Arduino.

Um [primeiro teste do algoritmo de controle digital de um PID usando Arduíno Uno](PID_no_Arduino.html) pode ser visto [[aqui]](PID_no_Arduino.html).

Segue breve descrição de cada bloco.

## Módulo DAC MPC4725

Uma placa Arduino Uno (ou mesmo Raspberry Pi) não contempla um conversor D/A (de sinal digital para analógico).

Para resolver este problema, está previsto o uso de pequenos módulos DAC, baseados no chip MPC4725. 

<img src="https://fpassold.github.io/Lab_Controle_2/PID_Digital/MCP4725.webp" alt="MPC4725" style="zoom:45%;" />

Trata-se um conversor A/D de 12-bits (trabalha com números de entrada, inteiros sem sinal, na faixa de [0 .. 4095]). Este pequeno módulo se comunica com o Arduino usando protocolo digital I2C, através dos pinos: A4 (sinal SDA) e A5 (sinal SCL). E então é capaz de gerar um sinal de saída analógico variando de 0 à 5 Volts no máximo. 

Ver [Trabalhar com o Módulo DAC](https://fpassold.github.io/Lab_Controle_2/PID_Digital/modulo_DAC.html) para obter mais informações e detalhes sobre como instalar/fazer este módulo funcionar com a interface de programação tradicional das placas Arduino Uno.

Este módulo está previsto para ser encaixado na placa "condicionara de sinai de saída do DAC".

## Placa de Condicionamento de Sinal para o DAC

Um DAC normalmente só gera tensão na mesma faixa do circuito digital com o qual opera. No caso, no intervalo entre [0 .. 5] Volts. Mas para sua aplicação num sistema real, se faz necessário "amplificar" e "isolar" seu sinal de saída. Em parte para não danificar o próprio módulo e em parte porque normalmente um sistema real (físico/analógico) trabalha com faixas de tensão que vão de $[-10 \ldots +10]$ Volts ou outras faixas ainda dependendo da aplicação.

Neste caso, está previsto ao controle de um motor CC usando o driver de potência, módulo SA150D dos kits Feedback. Este módulo aceita tensões em cada uma de suas entradas, variando na faixa de $[-15 \ldots +15]$ Volts. Eventualmente este módulo pode ser usado com um pré-amplificador, módulo PA150C, que também é capaz de trabalhar com estas mesma faixa de tensão em cada uma de suas entradas. O fato é que, se queremos realizar um controle de posição angular por exemplo, girar um motor de certo número de graus, se faz necessário comandar o motor nos 2 sentidos, o que implica em apresentar tensões negativas na entrada do driver de potência ou de seu módulo pré-amplificador. Sem isto, o motor não pode inverter o sentido do giro caso tenha ultrapassado a posição angular desejada.

Este é o motivo para a criação da placa de **Condicionamento de Sinal para o DAC**:

<img src="placas_arduino_DAC.jpeg" alt="placas_arduino_DAC" style="zoom:67%;" />

Esta placa recebe o sinal analógico gerado pelo **módulo MPC4725** e é capaz de amplificar e acrescentar um *offset* negativo de tensão para enquadrar a saída do sinal analógico nas faixas:

1. $[-2,5 \ldots +2,5]$ Volts;
2. $[-5 \ldots +5]$ Volts;
3. $[-10 \ldots +10]$ Volts;
4. $[-15 \ldots +15]$ Volts.

De acordo com a seleção da SW1.

Esta placa contêm:

<img src="placa_modulo_DAC_2.png" alt="placa_modulo_DAC_2" style="zoom:20%;" />



## Placa de Acondicionamento de sinal de ADC

De forma semelhar ao caso anterior, uma placa Arduino Uno até possui um conversor A/D de 10 bits (gera número inteiro sem sinal, variando de [0 .. 1024]), mas suas entradas analógicas só suportam trabalhar com faixa de tensão entre $[0 \ldots +5]$ Volts. Nem suporta tensão negativa nestas entradas.

Motivo pelo qual se faz necessário outro circuito que capaz de "atenuar" e "enquadrar" tensões analógicas variando em extrermos bem superiores aos previstos pelo A/D do Arduino:

<img src="placas_arduino_ADC.jpeg" alt="placas_arduino_ADC" style="zoom:67%;" />

Neste caso, esta placa possibilita trabalhar com tensões analógicas de entrada variando nas faixas:

* $[-5 \ldots +5]$ Volts;
* $[-10 \ldots +10]$ Volts;
* $[-15 \ldots +15]$ Volts;
* $[-30 \ldots +30]$ Volts.

enquadrando estas tensões para a faixa aceita pelo A/D do Arduino (entre $[0 \ldots +5]$ Volts).

Circuito presente na placa:

<img src="ganho_offset_ve3_out_protected_resistores_corrigidos.png" alt="ganho_offset_ve3_out_protected_resistores_corrigidos" style="zoom:25%;" />



## Placa do Filtro Passa Baixas

Por fim, a fim de evitar problemas com *aliasing* associados com digitalização de sinais, foi previsto um filtro passa-baixas de 4a-ordem com frequência de corte $f_c=$ 50 Hz. Esta frequência limita ruídos e geração de sinais em frequênicas superiores. Esta placa está prevista para trabalhar com tensões variando na faixa de $[-15 \ldots +15]$ Volts:

<img src="placas_arduino_filtro_passa_baixas.jpeg" alt="placas_arduino_filtro_passa_baixas" style="zoom:67%;" />

Circuito interno:

<img src="placa_filtro_passa_baixas_50Hz_LM358.png" alt="placa_filtro_passa_baixas_50Hz_LM358" style="zoom:25%;" />

---

Fernando Passold, em 08/04/2024.

