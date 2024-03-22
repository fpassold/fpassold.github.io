# Trabalho #1

Lab. Controle 2 | Semestre 2024/1.

1. Aplicar o método 1 para sintonia de um PID para a seguinte planta:

   $G_1(s)=\dfrac{5}{2}\left( \dfrac{1}{s^2+5,5s+2,5} \right)$

   Suponha que o sistema sintonizado com PID deva tentar respeitar: $\%OS<20\%$ e $t_s<0,67$ segundos (para entrada degrau unitário).

   **Atenção**: não é necessário realizar sintonia fina deste PID.

2. Aplicar os últimos 2 métodos de sintonia de um PID à seguinte planta:

   $G_{2,3}(s)=\dfrac{21}{(s+1)(s+3)(s+7)}$

   Suponha que se deseja um $\%OS \le 20\%$ e um tempo de assentamento abaixo de $t_s \le 2,5$ segundos (para entrada degrau unitário).

   **Obs.**: **Esperada sintonia fina** do PID inicialmente obtido.

---

**Prazo de entrega**: ==até 16/04/2024==.

**Observações finais**, sobre o documento à ser gerado:

Apresentar um documento (pode ser criado editando arquivo Markdown, Word, OpenOffice, WordPad **exportado para PDF**) descrevendo a aplicação de cada método. Este documento deve mostrar para cada método:

- os cálculos realizados (poder ser incluído código Matlab ressaltando resultados; **mas** incluir apenas os cálculos com resultados numéricos efetivamente usados; não o "copy-&-paste" de toda a sequencia de comandos usados -- o professor **não vai** ler código do Matlab tentando identificar o que foi realizado -- sua avaliação será rebaixada mesmo se eventualmente correta!);
- mostrar os gráficos obtidos com **boa resolução** (≥≥ 150 DPI, usar arquivo tipo .png, tamanho de fonte interno ≥≥ 12).
- Para os 3 métodos aplicados, testar os resultados obtidos usando ao final o PID previsto no Matlab/Simulink com os parâmetros clássicos propostos por Ziegler-Nichols e apenas no final deste trabalho, como se fosse um 4o4o-item, realize um ajuste fino do PID para a última planta apenas, explicando que parâmetros foram alterados, os valores finalmente adotados e o resultado final obtido (gráficos).

------

Fernando Passold em 21/03/2024.

