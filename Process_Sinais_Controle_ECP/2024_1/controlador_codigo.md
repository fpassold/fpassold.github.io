# Controlador Digital

**Intro**

**Questão**: Como implementar $C(z)$? Ou como $C(z) \longrightarrow u[kT]$ ? 

Seja um controlador PI, como o mostrado abaixo:

![blocos_PI](https://fpassold.github.io/Controle_3/aula_14_05_2020/PI_blocos.drawio.png)

Sua equação no plano$-z$ fica:

$C_{PI}(z)=\dfrac{K_p \left[ z - \left( 1 - \dfrac{K_i}{K_p}\right)\right]}{(z-1)}$

Ou de forma mais genérica (e paramétrica):

$C(z)=\dfrac{K(z-b)}{(z-a)}$		(eq. (1))

onde: $K=$ ganho genérico do controlador (provavelmente definido à partir de projeto usando *root-locus*); $a=$ pólo do controlador; $b=$ zero do controlador.

Esta mesma equação pode ser re-escrita usando notação negativa para os expoentes em $z$:

$C(z)=\dfrac{K(z-b)}{(z-a)} \cdot \dfrac{z^{-1}}{z^{-1}}$

$C(z)=\dfrac{K(1-bz^{-1})}{(1-az^{-1})}$		(eq. (2))

A idéia é obter a eq. de diferenças à partir de $C(z)$ e a notação anterior é mais prática porque termos como:

 $z^{-1} \cdot E(z) \xrightarrow[]{\mathcal{Z^{-1}}} e[k-1]$.

ou, lembrando das propriedades da Transformada$-\mathcal{Z}$, $z^{-1}X(z)$ respresenta uma amostra atrasada (de 1 período de amostragem) do sinal $x[kT]$.

Voltando a eq. (2) lembramos ainda que:

$C(z)=\dfrac{U(z)}{E(z)}$

Então:

$\dfrac{U(z)}{E(z)} = \dfrac{K(1-bz^{-1})}{(1-az^{-1})}$

trabalhando esta equação vamos obter:

$U(z)(1-az^{-1})=K(1-bz^{-1})E(z)$

$U(z) = K E(z) - K b z^{-1} E(z)+a z^{-1} U(z)$

$\downarrow \quad \mathcal{Z}^{-1}$

$u[k]=K\cdot e[k] - K\cdot b \cdot e[k-1]+ a \cdot u[k-1]$		(eq. (3))

Onde: $u[k]=$ sinal de controle atual (sinal de atuação); $u[k-1]=$ sinal de controle no instante de amostragem anterior; $e[k]=$ erro atual do sistema; $e[k-1]=$ erro no instante de amostragem anterior; $K=$ ganho genérico do controlador; $b=$ zero do controlador; $a=$ pólo do controlador.

Note que a eq. (3) é a equação que deve ser implementada num controlador e deve ser executada de maneira síncrona, isto é, cada vez que se passa o intervalor de tempo correspondendo ao período de amostragem $T$.

Então poderiámos codificar diretamente a eq. (3) ?

`u[k] = K * e[k] - K * b * e[k-1] + a * u[k-1];` ?		(eq.(4))

Com: `float K, u[], e[], a, b`, e provavelmente: `unsigned int k;`.

Até se poderia, mas com um detalhe, a variável `k` usada como índice para acessar posições nos vetores `u[]` e `e[]` , do ponto de vista da eq. (3), varia no intervalo: $0 < k < \infty$, ou seja, não existe um limite finito para o tamanho destes vetores. O maior valor atingido pelo vetor $k$ vai depender de quanto tempo o algoritmo de controle (a eq. (3)) está rodando. 

Na prática, se a eq. (3) for diretamente implementada como a eq. (4), provavelmente vamos incorrer num *overflow* na memória do micro-controlador (ou tentiva de "inavasão" de áreas de RAM reservadas para outros processos num sistema de tempo-real) usado para implementar este algoritmo de controle. De todas as formas, provavelmente vamos incorrer no disparo do *watchdog* do microcontrolador (e consequentemente seu *re-boot*) ou ocorrência de exceção causada por tentativa de invasão de faixas de RAM, depois de certo intervalo de tempo.

Então, cada termo da eq. (4) deverá ser transformado numa simples variável escalar (array $1 \times 1$), algo do tipo:

`u = K*e - K*b*e1 + a*u1;`		(eq. (5))

as variáveis teriam de ser `float` e os valores das variáveis `u1` e `e1` associados com valores de amostras atrasadas dos sinais de controle e de erro deveriam ser atualizadas de forma adequada dentro do código associado com o algoritmo de controle.

Como o algoritmo de controle deve ser implementado numa `task` síncrona ou rotina da tratamento de interrupção, resultaria em algo semelhante à:

```c++
ISR(TIMER2_COMPA_vect){
    // tratamento de interrupção associado ao timer2 numa placa Arduino Uno
    y = analogRead(analogPin); 	// leitura de A/D conectado ao sensor de posição/velocidade
    e = r - y;					// cálculo do erro
    u = K*e - K*b*e1 + a*u1;	// lei de controle
    DAC_found = dac.setVoltage((int)u, false);	// comandando D/A, módulo MCP4725
}
```

Note que esta rotina lê informações de um sensor usando um A/D, compara com referência desejada (variável `r`), calcular o sinal do erro, computa o sinal de controle e lança este sinal para fora usando um D/A.

Note que não é declarada nenhum variável dentro do bloco porque todas são propositalmente globais.

O objetivo da rotina do algoritmo de controle é apenas e exclusivamente executar o algoritmo de controle. Não deve ser usada para mostrar informações num display ou transmitir informações numa porta serial. O programador deve ser dar conta que o tempo de processamento gasto com a execução deste algoritmo deve ser o menor possível. 

Se o usuário quiser transmitir ou mostrar dados do processo, ou até mesmo alterar o ganho ou outros parâmetros do controlador ou alterar o próprio valor da referênica (ou *set-point*), isto deve ser feito fora desta rotina. Motivo pelo qual, as variáveis presentes dentro do algoritmo de controle são globais. Se fosse usado um sistema operacional de tempo real oritentado à objetos, algumas variuáveis poderiam ser declaradas como atributos privados de certos objetos. Mas o caso do código exemplo mostrado aqui, não contempla uma situação como esta. E sim, esta mais direcionada para implementação numa placa micro-controlada tão simples quanto uma Arduino Uno.

No caso de ser usada uma placa como Arduino Uno, a seção de código associada com a função `void setup(){ .. }` deveria inicializar pinos, porta serial, módulo DAC e configurar adequadamente uma interrupção de software associada com *overflow* de algum timer da placa micro-controlada (no caso do código mostrado, seria o timer2).

E na seção `void loop(){ .. }` poderia estar contigo código que mostra num display ou transmite pela porta serial, dados do processo sob controle (conteúdo das variáveis `r`= referência atual, `y`= saída atual do processo e `u`= sinal de controle atual) e ainda deveria haver algum código que permite interação com o usuário para "desligar" o algoritmo de controle, mudar parâmetros do controlador ou mudar refência usada para o processo. 

Como o algoritmo de controle sempre estará sendo executado de forma periódica, obedecendo o período de amostragem requerido, o código como um todo passa a impressão para o usuário de que: está lendo dados do processo, processando o algoritmo de controle e processando dados de controle (parâmetros) passados pelo usuário. 

Um último detalhe: antes de executar a linha:

```c++
    DAC_found = dac.setVoltage((int)u, false);	// comandando D/A, módulo MCP4725
```

é interessante lembrar que qualquer DAC trabalha dentro de uma faixa limitada de valores inteiros. Motivo pelo qual está sendo realizado o *casting* em relação à variável `u`. Mas seria bastante aconselhável, antes de simplesmente enviar o sinal de controle `u` para o DAC, limitar seu valor de acordo com o DAC usado.

No caso do DAC MPC4725, o mesmo é de 12-bits, o que significa que só aceita números `unsigned int` variando entre: $0 < DAC < 2^{12}-1$ ou na faixa: $[0, 4095]$. Então antes desta linha de código é interessante que seja colocaco um bloco "Saturador" do tipo:

```c++
	unsigned int valor_DAC;		// esta declaração pode ser global ou outro local
	valor_DAC = (int)u;			// transforma de float para int
	if (valor_DAC < 0)
        valor_DAC = 0;
	if (valor_DAC > 4095)
        valor_DAC = 4095;
	DAC_found = dac.setVoltage(valor_DAC, false);
```

Em resumo estaríamos realizando algo como:

<img src="Controlador_digital.png" alt="Controlador_digital" style="zoom:67%;" />

Fim.

* Exemplo de uso do **módulo DAC MPC4725**, pode ser enocontrado [[aqui](https://fpassold.github.io/Lab_Controle_2/PID_Digital/modulo_DAC.html)];
* Uso de interrupção por software causado por *overlfow* de timer para placa Arduino Uno (ou **rotina ISR**), pode ser encontrada [[aqui](https://fpassold.github.io/Lab_Controle_2/Arduino_Int/Arduino_Int.html)] ;
* Exemplo de codificação de um **PID Digital usando Arduino Uno** pode ser encontrado [[aqui](https://fpassold.github.io/Lab_Controle_2/PID_Arduino/PID_no_Arduino.html)].

---

Fernando Passold, em 30/04/2024

