<!--title: Controle 3 -->
# Curso de Controle Automático III

![cason-asher-Ur7Efx8lBjs-unsplash.jpg](cason-asher-Ur7Efx8lBjs-unsplash.jpg)

**Tópicos:**

## 1. Introdução

* [Introdução à disciplina](1_intro/intro.pdf);
* [Sequência prevista para as aulas](1_intro/seq_aulas.html);
  
## 2. Teorema de Amostragem

* [Teoria Sistemas de Amostragem](2_sampling/01_Sistema_Amostrado_no_Tempo.pdf)
   > Modelagem do processo de amostragem;
      Diagramas espectrais

<details><summary>Resumo gráfico processo de amostragem de um sinal...</summary>
<p>

![figura](2_sampling/Process%20of%20digitizing%20and%20converting%20a%20signal%20with%20an%20infinite%20precision%20ADC-DAC_0.png)

</p>
</details>

* Material opcional:

  * [From Analog to Digital – Part 2/**The Conversion Process** | Nutaq | Nutaq.pdf](2_sampling/From%20Analog%20to%20Digital%20–%20Part%202:%20The%20Conversion%20Process%20|%20Nutaq%20|%20Nutaq.pdf)
  * [Wolfram Demonstrations Project: **Sampling Theorem**](https://demonstrations.wolfram.com/SamplingTheorem/)
  * [Wolfram Demonstrations Project: **Aliasing** in Time Series Analysis](https://demonstrations.wolfram.com/AliasingInTimeSeriesAnalysis/);
  

* [Exercício explorando Teorema da Amostragem](Teste_Amost/teste_amostragem.html);
   > Amostrando uma onda dente-de-serra

## 3. Transformada Z

* [Parte 1](3_transformada/transformada_Z.pdf): Definições, conceitos iniciais, primeiras transformadas;
* [Parte 2](3_transformada/transformada_Z_parte2.pdf): Transformadas de alguns sinais, Propriedades da Transformada Z;
* [Parte 3](3_transformada/transformada_Z_parte_3.pdf): Métodos de Transformada Inversa de Z;
* [Modelagem do Sustentador](3_transformada/3_BoG_Transformada_Z.pdf) de Ordem Zero (ZOH, ou $BoG(z)$).
* 1o-exemplo de sistema de 1a-ordem digitalizado:
   > Incorporando o **Sustentador de Ordem Zero**, cálculo de $BoG(z)$ $\rightarrow$ [deduções e simulações](exemplo_1_BoG/intro_exemplo_1a_ordem.html).
* [Resumo final Transformada Z](3_transformada/revisao_partes_importantes_transformada_Z.pdf) (partes importantes).

## 4. Teoria do Erro

* [**Teoria do Erro** (papel do integrador)](4_teoria_erros/resumo_teoria_erro.html);

## 5. Estabilidade

* Estabilidade $\Rightarrow$ **Método de Jury**: [Aplicação](Exemplo_Jury/problema_1.html)
  

## 6. Estudo de Caso (Projeto de Controladores):

  1. Projeto de **Controlador Proporcional**:
     * [Aula de 07/05/2020](aula_07_05_2020.html);
     * Projeto de **PI = Controlador Proporcional + Integral Puro** ([aula de 07/10/2020](2020_2/aula_07_10_2020.html));
  2. Projeto de **PI**:
     * [Aula de 14/05/2020](aula_14_05_2020.html);
     * Outro projeto de [Controlador Ação Integral Pura e PI](2021_1/aula_05_05_2021.html), incluindo comparações (05/05/2021).
     * [Aula de 23/09/2021](Controle3_2021_2/aula_1.html) >> Projeto de P, I e PI (início);

  3. O que acontece quando se tenta acrescentar **+Integração em Sistema tipo 1** [[aula de 07/10/2021](sis_tipo1/sis1_mais_integradores.html)];
  4. Projeto de Controlador por **Atraso de Fase (Lag)**:
     * [Aula de 21/05/2020](controlador_Lag.html);
     * Projeto de Controlador PI + Lag ([aula de 14/10/2020](2020_2/aula_14_10_2020.html))
  5. Deduzindo [Equações de **Controladores com Ação Derivativa** (arquivo PDF)](pd_plus_filtro.pdf) (Aula de 21/05/2020);
  6. Projeto de Controladores **PD e Lead**:
     1. [Projeto de PD (sem contribuição angular)](2020_2/aula_28_10_2020.html) (Aula de 28/10/2020)
     2. [Projeto de Controlador PD](projeto_PD_lead_2020.html) (Aula de 28/05/2020);
     3. [Projeto de Lead](lead/lead_ex1.html) (Aula de 11/11/2020);
  7. Controlador **Deadbeat** -- projeto(s): 
     * [Aula de 04/06/2020](deadbeat_08out2019.html) ;
     * [Aula de 11/11/2020](deadbeat/deadbeat_exemplo_1.html);
     * [Aula de 09/06/2021](deadbeat_09062021/aula_deadbeat_09_06_2021.html).
  8. Projeto de PID (com ajuste por Ziegler-Nichols)
     * (..aguardar..)

EXTRAs:

* [**Implementações** de algoritmos de controle digitais](implementacao_controlador_digital.html)
* [**Processo da Bola no Tubo: implementação real**](implementacao_controle_digital.html) (TCC de 2006).


<details><summary>Dicas instalação do MATLAB (toolboxes necessários)...</summary>
<p>

> Para os propósitos desta disciplina (Controle Automático I, Controle Automático II e Controle Automático III), é altamente desejável o uso do Matlab/Simulink.
>
> O software Matlab/Simulink normalmente vêm acompanhado de vários "toolboxes" (bibliotecas extras que complementam suas funções), em tal quantidade que sua instalação completa (todos os toolboxes), facilmente pode exigir mais de 30 GBytes de espaço em disco!
> 
> Sugere-se no momento da instalação do Matlab/Simulink, optar-se pela instalação dos seguintes pacotes:
>
> Products:
> MATLAB (**>= Matlab R2017b**)</br>
> [x] **Simulink**</br> 
> [x] **Control System Toolbox**</br>
> [x] **Curve Fitting Toolbox**</br>
>
> A lista acima envolvendo instalação do Matlab versão 2017B realizada num MacOS exigiu:
> Installation Size: 5,759 MB (5,7 Gbytes) 
> (Espaço ocupado numa máquina executando MacOS Monterey; o espaço final pode variar um pouco para sistemas Linux ou Windows)
> 
> Recomenda-se também: </br>
> [x] Symbolic Math Toolbox </br>
> [x] SimEvents </br>
> [x] Simscape </br>
> [x] Simscape Driveline </br>
> [x] Simscape Electronics </br>
> [x] Simscape Fluids </br>
> [x] Simscape Multibody </br>
> 
> **Exemplo real**: Instalação do MATLAB Version: 9.5.0.944444 (R2018b) em Windows 11,com os seguintes toolboxes:
> 
```bash
MATLAB                                                Version 9.5         (R2018b)
Simulink                                              Version 9.2         (R2018b)
Computer Vision System Toolbox                        Version 8.2         (R2018b)
Control System Toolbox                                Version 10.5        (R2018b)
Curve Fitting Toolbox                                 Version 3.5.8       (R2018b)
Data Acquisition Toolbox                              Version 3.14        (R2018b)
Database Toolbox                                      Version 9.0         (R2018b)
Deep Learning Toolbox                                 Version 12.0        (R2018b)
Fixed-Point Designer                                  Version 6.2         (R2018b)
Fuzzy Logic Toolbox                                   Version 2.4         (R2018b)
Image Acquisition Toolbox                             Version 5.5         (R2018b)
Image Processing Toolbox                              Version 10.3        (R2018b)
MATLAB Coder                                          Version 4.1         (R2018b)
MATLAB Distributed Computing Server                   Version 6.13        (R2018b)
Optimization Toolbox                                  Version 8.2         (R2018b)
Parallel Computing Toolbox                            Version 6.13        (R2018b)
Partial Differential Equation Toolbox                 Version 3.1         (R2018b)
Robotics System Toolbox                               Version 2.1         (R2018b)
Sensor Fusion and Tracking Toolbox                    Version 1.0         (R2018b)
Signal Processing Toolbox                             Version 8.1         (R2018b)
SimEvents                                             Version 5.5         (R2018b)
Simscape                                              Version 4.5         (R2018b)
Simscape Driveline                                    Version 2.15        (R2018b)
Simscape Electrical                                   Version 7.0         (R2018b)
Simscape Fluids                                       Version 2.5         (R2018b)
Simscape Multibody                                    Version 6.0         (R2018b)
Simulink 3D Animation                                 Version 8.1         (R2018b)
Simulink Check                                        Version 4.2         (R2018b)
Simulink Coder                                        Version 9.0         (R2018b)
Simulink Control Design                               Version 5.2         (R2018b)
Simulink Coverage                                     Version 4.2         (R2018b)
Simulink Desktop Real-Time                            Version 5.7         (R2018b)
Simulink PLC Coder                                    Version 2.6         (R2018b)
Simulink Real-Time                                    Version 6.9         (R2018b)
Simulink Requirements                                 Version 1.2         (R2018b)
Simulink Test                                         Version 2.5         (R2018b)
Stateflow                                             Version 9.2         (R2018b)
Statistics and Machine Learning Toolbox               Version 11.4        (R2018b)
Symbolic Math Toolbox                                 Version 8.2         (R2018b)
System Identification Toolbox                         Version 9.9         (R2018b)
```

> Exigiu: 15,7 Gbytes de espaço em disco!
</p>
</details>

---

<font size="2"> (c) Fernando Passold, página atualiza em 28/05/2020, 04/06/2020, 11/11/2020, 07.04.2021, 11/03/2023, 04/08/2023 </font>