# Projeto Contador Síncrono 2021/2

Projeto deste semestre:

<img src="projeto_sync_dig2_2021_2.png" alt="projeto_sync_dig2_2021_2" style="zoom:50%;" />

Como resolver?

1) Quantos FF's? 

*Solução*: o contador proposto exige 6 estados. 6 estados => 3 FF's.

Detalhe: existem combinações binárias ou estados que não são atingidas pelo circuto usando os 3 FF's, os estados: 0 e 5.

2. Como continuo?

*Solução*: Levantar tabela de transição.

|  Ref |  M   | q2 q1 q0 | Q2 Q1 Q0 |  d2  |  d1  |  d0  |
| ---: | :--: | :------: | :------: | :--: | :--: | :--: |
|    0 |  0   |  0 0 0   |  X X X   |  X   |  X   |  X   |
|    1 |  0   |  0 0 1   |  1 1 1   |      |      |      |
|    2 |  0   |  0 1 0   |  1 1 0   |      |      |      |
|    3 |  0   |  0 1 1   |  1 0 0   |      |      |      |
|    4 |  0   |  1 0 0   |  0 0 1   |      |      |      |
|    5 |  0   |  1 0 1   |  X X X   |  X   |  X   |  X   |
|    6 |  0   |  1 1 0   |  0 1 1   |      |      |      |
|    7 |  0   |  1 1 1   |  0 1 0   |      |      |      |
|    8 |  1   |  0 0 0   |  X X X   |  X   |  X   |  X   |
|    9 |  1   |  0 0 1   |  0 1 0   |      |      |      |
|   10 |  1   |  0 1 0   |  0 1 1   |      |      |      |
|   11 |  1   |  0 1 1   |  1 1 1   |      |      |      |
|   12 |  1   |  1 0 0   |  0 0 1   |      |      |      |
|   13 |  1   |  1 0 1   |  X X X   |  X   |  X   |  X   |
|   14 |  1   |  1 1 0   |  1 0 0   |      |      |      |
|   15 |  1   |  1 1 1   |  1 1 0   |      |      |      |

 Terminando/completando a tabela:

$q(t) \longrightarrow Q(t+1)$

Considerando a tabela de transição do FF adotado teremos:

| q(t) | Q(t+1) | D    |
| ---- | ------ | ---- |
| 0    | 0      | 0    |
| 0    | 1      | 1    |
| 1    | 0      | 0    |
| 1    | 1      | 1    |

Completando a tabela de transição do circuito:

|  Ref |  M   | q2 q1 q0 | Q2 Q1 Q0 |  d2  |  d1  |  d0  |
| ---: | :--: | :------: | :------: | :--: | :--: | :--: |
|    0 |  0   |  0 0 0   |  X X X   |  X   |  X   |  X   |
|    1 |  0   |  0 0 1   |  1 1 1   |  1   |  1   |  1   |
|    2 |  0   |  0 1 0   |  1 1 0   |  1   |  1   |  0   |
|    3 |  0   |  0 1 1   |  1 0 0   |  1   |  0   |  0   |
|    4 |  0   |  1 0 0   |  0 0 1   |  0   |  0   |  1   |
|    5 |  0   |  1 0 1   |  X X X   |  X   |  X   |  X   |
|    6 |  0   |  1 1 0   |  0 1 1   |  0   |  1   |  1   |
|    7 |  0   |  1 1 1   |  0 1 0   |  0   |  1   |  0   |
|    8 |  1   |  0 0 0   |  X X X   |  X   |  X   |  X   |
|    9 |  1   |  0 0 1   |  0 1 0   |  0   |  1   |  0   |
|   10 |  1   |  0 1 0   |  0 1 1   |  0   |  1   |  1   |
|   11 |  1   |  0 1 1   |  1 1 1   |  1   |  1   |  1   |
|   12 |  1   |  1 0 0   |  0 0 1   |  0   |  0   |  1   |
|   13 |  1   |  1 0 1   |  X X X   |  X   |  X   |  X   |
|   14 |  1   |  1 1 0   |  1 0 0   |  1   |  0   |  0   |
|   15 |  1   |  1 1 1   |  1 1 0   |  1   |  1   |  0   |

Continuando... Montando os mapas de Karnaugh:

<img src="mapa_k_d2.jpg" alt="mapa_k_d2" style="zoom:50%;" />

<img src="mapa_k_d1.jpg" alt="mapa_k_d1" style="zoom:50%;" />



<img src="mapa_k_d0.jpg" alt="mapa_k_d0" style="zoom:50%;" />

Se forem usadas portas lógicas básicas, serão necessárias:

- portas AND(3) x 5 --> 2 x CI's; 
- portas AND(2) x 6 --> 2 x CI's;
- portas OR(3) x 1 --> 1 x CI;
- portas OR(4) x 2 --> 1 x CI;

Total para a parte de comando dos FF's seriam 6 x CI's + CI para os 3 x FF's D (com saída $\overline{Q}$).

Podemos usar o CI 74LS175 (Quad FF type D) -- ver: https://fpassold.github.io/Digitais_2/2020_1/projeto_contador_sincrono_2020_1.html 

Note um porém, se for usada a pastilha 74LS175, só conseguimos inicializar o circuito no estado: $q_2q_1q_0=000_{(2)}=0_{10}$ e percebe-se que justamente este estado não está previsto neste projeto.

Supondo que ativo o "Master Reset" do 74LS175, e analizado os Mapas de Karnaugh anteriores, vamos perceber que o próximo estado assumido pelo circuito seria: 

* quando M=0 --> $Q_2Q_1Q_0=101_{(2)}=5_{(10)}$; Notamos que o "5" também não faz parte da sequencia prevista, o circuito então avança para:
  * quando M=0 ($q2q1q0=101_{(2)}=5_{(10)}$) : $Mq_2q_1q_0=0101_{(2)}$ --> $Q_2Q_1Q_0=3_{(10)}$;
  * quando M=1 ($q2q1q0=101_{(2)}=5_{(10)}$) : $Mq2q1q0=1101_{(2)}$ --> $Q2Q1Q0=010_{(2)}=2_{(10)}$.
* quando M=1 --> $Q_2Q_1Q_0= 011_{(2)}=3_{(10)}$ (nos mapas é a condição inicial: $Mq_2q_1q_0=1000_{(2)}$).

Poderia resumir este comportamento num diagrama de estados:

<img src="projeto_sync_dig2_2021_2_b.jpg" alt="projeto_sync_dig2_2021_2_b" style="zoom:50%;" />

Note: alguém pode considerar que o circuito vai iniciar via Master Reset assumindo uma sequencia de estados estranha. Ok, ela ocorre como mostra o diagrama obtido acima, mas o que importa num primeiro momento é que o Master Reset, mesmo nesta situação não leva a um "dead-look"  (um estado de paralisia do circuito).

Uma opção que temos para evitar esta inicialização algo confusa e considerando que só podemos iniciar os FF's do nosso circuito, com todos resetados (pino de Master Reset da pastilha 74LS175), uma opção mais interessante e possível já que estamos realizando o projeto, é definir explicitamente qual o próximo estados desejado para o nosso circuito depois que os FF's iniciam todos resetados. Poderíamos realizar algo como:

* $\overline{MR}$ e $M=0 \quad \Rightarrow \quad Mq_2q_1q_0=0000_{(2)}=0_{(10)} \quad \longrightarrow \quad Q_2Q_1Q_0=4_{(10)}=100_{(2)}$;
* $\overline{MR}$ e $M=1 \quad \Rightarrow \quad Mq_2q_1q_0=1000_{(2)}=8_{(10)} \quad \longrightarrow \quad Q_2Q_1Q_0=1_{(10)}=001_{(2)}$.

Ou na forma de um diagrama de estado, significa que queremos agora fazer:

<img src="projeto_sync_dig2_2021_2_c.png" alt="projeto_sync_dig2_2021_2_c" style="zoom:50%;" />

Isto significa que temos que alterar algumas linhas na nossa tabela de transição do circuito para:

---

Até aqui em 08/10/2021.



