![Controle-PID-1-1](figs/Controle-PID-1-1.png)

# Sintonia de PID em Controle de Posição (angular)

<!-- Laboratório previsto para data de 11/04/2023.-->

A ideia neste laboratório é realizar controle de posição em malha-fechada, baseado em controlador analógico PID. **Incluindo a sintonia do controlador PID** para este processo.

<!--A próxima figura passa uma ideia da estrutura mecânica que tentaremos controlar.-->

<!--![conjunto_motor_taco.jpg](figs/conjunto_mototr_taco.jpg)-->

<!--A primeira figura ainda mostra o tacogerador acoplado ao sistema (módulo GT150X). Na realidade, o mesmo está sendo usado como uma carga para o motor (além do freio magnético que também aparece na figura mas não está previsto para ser usado), mas também está sendo aproveitado como um ``moto-redutor'' (motor com caixa de redução). Assim, o motor pode rotacionar mais e mais rápido sem comprometer tão rapidamente a faixa de leitura do nosso sensor de posição (potenciômetro, módulo OP150K).-->

A próxima figura mostra as ligações usadas para realizar um **controle proporcional** de posição em malha-fechada usando o kit da Feedback:

<!-- Manual da Feedback, Lab 6, fig 3.6.5 -->
<!-- ou no material do Mikhail, fig. 6.4 -->

![fig-6-4.png](figs/fig-6-4.png)

O diagrama de ligações pode ser redesenhado da seguinte forma, para compreender melhor a malha de realimentação:

![controle_posicao_kit_feedback.drawio](figs/controle_posicao_kit_feedback.drawio.png)



Note pela figura anterior, que um potenciômetro (módulo OP150K) será usado como sensor de posição angular (lembrar que sua faixa de operação fica limitada entre $-160^o < \theta < 160^o$). Outro potenciômetor, IP150H atua como divisor de tensão gerando a referência (posição angular desejada). Algo como:

<img src="figs/lab_controle_4_1.jpeg" alt="lab_controle_4_1" style="zoom:25%;" />

Perceba que **as polaridades** geradas pelos módulos IP150H e OP150K entram propositalmente **invertidas** no módulo do Amp.Op. (OA150A), que desempenha o papel associado com o "cálculo'' do sinal de erro, $e(t)$. Ambos os módulos IP150H e OP150K são simples potenciometros atuando como divisores de tensão. 

O módulo OA150A realiza (na sua saída 6):

$\text{Erro} = \tilde{\theta}=\theta_{ref} - \theta_{atual}$

A saída do OA150A antes de ser entregue diretamente ao driver de potência (módulo SA150D), passa antes por um **ajuste de ganho** (módulo AU150B), que permite "dosar" (reduzir a tensão do erro) que depois é repassado para o módulo pré-amplificador PA150C. O potenciômetro AU150B atua definindo o "**ganho proporcional**" desejado (neste caso: $0 \le K_p \le 1$). 

O módulo PA150C que recebe o sinal do potenciômetro gera tensões diferenciadas (saídas 3 e 4) necessárias para comandar as entradas 1 e  2 do driver de potência (SA150D), o que permite um "jogo de balanço corrente'' na armadura do motor e consequente giro no sentido horário ou anti-horário do motor. A figura abaixo esclarece o funcionamento do módulo pré-amplificador PA150C:

<img src="figs/funcionamento_modulo_PA150C.png" alt="funcionamento_modulo_PA150C" style="zoom:35%;" />



No caso deste laboratório, nossa intenção é realizar o controle de posição fechando a malha usando o PID, **trocamos o módulo AU150A** (potenciômetro responsável pela definção do ganho proporcional)**, pelo módulo do PID**.

A montagem anterior, considerando a incorportação do PID analógico fica algo como:

![controle_posicao_com_PID](figs/controle_posicao_com_PID.jpg)



O módulo do PID (PID150Y) aparece destacado na figura abaixo:

<img src="figs/PID_PID150Y.jpg" alt="PID_PID150Y.jpg" style="zoom:67%;" />

Notamos que podemos selecionar através de chaves quando é desejada a ação Proporcional, Integral e Derivativa. E existem outras chaves para variar a amplitude do ganho proporcional ou amplitude dos tempos derivativos e integrativos.



## Ajuste do PID

Se sugere o [uso do **método 2**](aula2/aula2b.html) para ajuste inicial do PID. Isto implica inicialmente desligar propositalmente as ações integrativas e derivativas, mantendo apenas a ação proporcional. 

O estudante deve então ajustar o potenciômetro asscoiado com o ganho da ação Proporcional (e eventualmente comutar a chave para ajuste da escala de ganho da ação proporcional) para encontrar o valor do ganho máximo $K_u$ que coloca o sistema na condição de oscilação sustentada. 

| Ganho $K < K_u$ | Ganho $K=K_u$ |
| :---: | :---: |
| ![ondas_ajuste_Ku_PID.jpg](figs/ondas_ajuste_Ku_PID.jpg) | ![step_planta_2_Ku.png](figs/step_planta_2_Ku.png) |

A oscilação produzida na saída do sistema deverá ser observada com a **ajuda de um osciloscópio**, uma vez que o mesmo será necessário para determinar o período da oscilação, $T_u$. **LIgação do kit ao osciloscópio**: conectar o canal 1 do osciloscpópio na saída do potenciômetro que define a referência para o sistema (módulo IP150H, saída 3) e o canal 2 na saída do potenciômetro usado como sensor de posiçao (módulo OP150K, saída 3).

A medida que o estudante aumenta o valor do ganho, pode comprovar resultados gráficos na tela do osciloscópio, similares aos mostrados abaixo:

<img src="figs/TEK0012.JPG" alt="TEK0012" style="zoom:67%;" />

Obs.: Na figura acima, o canal 1 do osciloscópio (curva em azul) foi obtida conectando esta ponteira (canal 1) na saída do amplificador que calcula o erro (saída 6 do módulo OA150A); e a "referência" neste caso, foi gerada usando um gerador de onda quadrada oscilando na frequência de 1/4 Hz (0,25 Hz). O **uso de um gerador de sinais** conectado ao kit pode acelear o processo de busca e determinação de $K_u$ e $T_u$. Neste, caso o potênciômetro que era usado para estabelecer a referência de posição angular (módulo IP150H) não é mais usado. A sua saída 3 é substituída pela saída do gerador de sinais. Apenas limite a faixa de amplitude da onda quadrada sendo gerada (normalmente $\pm 2$ Volts deve resolver). 

Depois que o estudante encontra o valor prático de $K_u$ (ultimate gain) e $T_u$ (período de oscilação; determinado com ajuda do osciloscópio), se faz necessário acessar alguma tabela de Ziegler-Nichols para testar valores sugeridos para os parâmetros $K_p=K_c$ (ganho proporcional), $\tau_i$ (tempo de integração) e $\tau_d$ (tempo derivativo) para um primeiro teste do PID analógico:

|                Controlador |       $K_{p}$       |        $T_{i}$        |       $T_{d}$        |            $K_{i}$            |           $K_{d}$           |
| -------------------------: | :-----------------: | :-------------------: | :------------------: | :---------------------------: | :-------------------------: |
|                          P |     $0.50K_{u}$     |           –           |          –           |               –               |              –              |
|                         PI |    $0.45\,K_{u}$    | $0.8{\dot{3}}\,T_{u}$ |          –           |       $0.54\,(K_u/T_u)$       |                             |
|                         PD |    $0.80\,K_{u}$    |           –           |    $0.125\,T_{u}$    |               –               |    $0.100\,K_{u}\,T_{u}$    |
|           ==PID clássico== |    $0.60\,K_{u}$    |     $0.50\,T_{u}$     |    $0.125\,T_{u}$    |     $1.2\,(K_{u}/T_{u})$      |    $0.075\,K_{u}\,T_{u}$    |
| Regra Integrador de Pessen |    $0.70\,K_{u}$    |     $0.40\,T_{u}$     |    $0.150\,T_{u}$    |     $1.75\,(K_{u}/T_{u})$     |    $0.105\,K_{u}\,T_{u}$    |
|            Algum overshoot | $0.3\dot{3}\,K_{u}$ |     $0.50\,T_{u}$     | $0.33\dot{3}\,T_{u}$ | $0.{6}\dot{6}\,(K_{u}/T_{u})$ | $0.11\dot{1}\,K_{u}\,T_{u}$ |
|              Sem overshoot |    $0.20\,K_{u}$    |    $0.50\, T_{u}$     | $0.33\dot{3}\,T_{u}$ |     $0.40\,(K_{u}/T_{u})$     | $0.06\dot{6}\,K_{u}\,T_{u}$ |

> Tabela originalmente diponível em: https://en.wikipedia.org/wiki/Ziegler%E2%80%93Nichols_method (acessado em 13/10/2022).

Neste primeiro teste do PID são esperado *overshoots* elevados, algo como:

<img src="figs/step_planta_2_PID_classico.png" alt="step_planta_2_PID_classico" style="zoom:48%;" />

Uma **sintonia fina** dever ser conduzida para determinar os valores finais dos parâmetros do PID para tentar limitar o $\%OS \le 10\%$.

O estudante deve apresentar as telas capturadas do osciloscópio para comprovar os ajustes realizados usando o PID: o primeiro ajuste refletindo a simples adoção dos valores sigeridos por Ziegler-Nichols e uma segunda tela mostrando o resultado da "sintonia fina" do PID.



## Questões

1. Apresentar o esquema de ligações elétricas dos módulos Feedback incorporando o controlador PID.
2. Apresentar um diagrama em blocos equivalente do sistema realizada na prática.
3. Apresentar o valor encontrado para $K_u$ e $T_u$, mostrando a tela capturada na saída do osciloscópio comprovando a oscilação sustentada.
4. Apresentar os cálculos dos parâmetros iniciais do PID: $K_c$, $T_i$ e $T_d$. O módulo PID150Y parece contemplar um PID no formato ISA, onde alterar o ganho $K_c$ também implica alterar os valores iniciais encontrados para $T_i$ e $T_d$.
5. Mostrar o resultado obtido na prática com a sintonia inicial do PID baseada no método 2. Mostrar a tela do osciloscópio.
6. Realizar o posterior "ajuste fino'' do PID, variando seus parâmetros para limitar o sobressinal a no máximo 10%.

Fim.

---

Fernando Passold, em 11/04/2023
