![Kioto_2](Kioto_2.jpg)

# Processamento de Sinais e Controle Digital

**Conteúdo Previsto** (parte teórica):

1. [Teoria da amostragem e Aquisição de Sinais](../Controle_3/2_sampling/01_Sistema_Amostrado_no_Tempo.pdf).
   1. [Simulação demonstrando Teorema da Amostragem](https://fpassold.github.io/Controle_3/Teste_Amost/teste_amostragem.html) (*Amostrando uma onda dente-de-serra*).
   2. [Síntese de Onda Quadrada usando Série de Fourier](https://fpassold.github.io/Controle_3/estudo_dirigido/Síntese_Onda_Quadrada.html). 
   3. [Wolfram Demonstrations Project: **Sampling Theorem**](https://demonstrations.wolfram.com/SamplingTheorem/)
   4. [Wolfram Demonstrations Project: **Aliasing** in Time Series Analysis](https://demonstrations.wolfram.com/AliasingInTimeSeriesAnalysis/);
2. Transformada Z.
   1. Parte 1:  [transformada_Z.pdf](../Controle_3/3_transformada/transformada_Z.pdf) (parte inicial, definições, transformadas de sinais "básicos")
   2. Parte 2:  [transformada_Z_parte2.pdf](../Controle_3/3_transformada/transformada_Z_parte2.pdf) (continuando com transformadas de outros sinais, Propriedades)
   3. Parte 3:  [transformada_Z_parte_3.pdf](../Controle_3/3_transformada/transformada_Z_parte_3.pdf) (Métodos Transformada Inversa de Laplace)
   4. Resumo:  [revisao_partes_importantes_transformada_Z.pdf](../Controle_3/3_transformada/revisao_partes_importantes_transformada_Z.pdf) (paralelos sinais/sistemas tempo contínuo x tempo discreto)
   5. Modelagem do Sustentador de Ordem Zero ([cálculo de $BoG(z)$](https://fpassold.github.io/Controle_3/3_transformada/3_BoG_Transformada_Z.pdf))
   6. [Impacto (ou falta) do $BoG(z)$](https://fpassold.github.io/Controle_3/3_5_Modelagem_G_BoG/teste_BoG.html)
   7. [Sistema de 1a-ordem digitalizado](https://fpassold.github.io/Controle_3/exemplo_1_BoG/intro_exemplo_1a_ordem.html) (uso de Matlab)
3. Análise de Sinais/Transformada de Laplace/Modelagem (voltado à Controle Digital)
   1. [Transformada de Laplace](3_transformada_laplace.pdf) (aplicado à Controle: revisão).
   2. [Respostas temporais](4_Respostas_Sistemas.pdf) típicas de Processos Industriais.
   3. [Introdução à Modelagem](5_intro_modelagem.pdf) (algumas técnicas).
   4. [Paralelos entre plano-s $\times$ plano-z](6_respostas_paralelos_s_z.pdf) (parte final: malha controle digital típica).
4. [Introdução ao Matlab](../Matlab/aula_intro_matlab_1.html) 

Parte de **Controle Digital**:

1. [Ações Básicas de Controle](7_acoes_controle.pdf): P, PI, PD, PID e outros (ainda mundo contínuo).
2. [Teoria do Erro](https://fpassold.github.io/Controle_3/4_teoria_erros/resumo_teoria_erro.html) (ou da Precisão + importância do integrador c/ dedução integral numérica).
3. Projetos de Controladores Digitais usando Root-Locus
   1. O que é o "Root Locus" ?
   2. Controlador Proporcional -- [Aula de 08/04/2024](2024_1/aula_080402024.html);
   3. Controlador Proporcional + Controle com Ação Integral Pura -- [Aula de 22/04/2024](2024_1/aula_22042024.html);
   4. Controlador PI;
   5. Controlador PD;
   6. Controlador PID;
4. Variações de PID´s
5. Implementação em sistemas embarcados de controladores digitais.

Parte de **Processamento (Digital) de Sinais**:

1. Análise de Sinais/Transformada de Fourir/Modelagem - aplicado à Processamento (Digital) de Sinais
   2. Diagrama de Bode (análise)
   3. Série de Fourier (espectro de ondas; síntese de onda quadrada)
   4. DFT e FFT, cuidados.
5. Filtros digitais.
   1. Filtros de média aritmética, média móvel;
   2. Filtros FIR
   3. Filtros IFIR
6. Implementação em sistemas embarcados de filtros digitais.

---

**Formas de Avaliação:**

- Provas teóricas abordando os conceitos fundamentais.
- Avaliação de projetos de filtros e controladores digitais.
- Relatórios de experimentos realizados em laboratório.
- Participação em discussões e atividades em sala de aula.
- Trabalhos individuais e em grupo.
  - [Trabalho #1)](trabalho_1_2024_1.html) Sobre sinais amostrados (Teorema de Amostragem) -- Deadline: 01/04/2024. (Equipes de no máximo 2 alunos + 1 equipe de 3 alunos).

---

**Softwares Indicados:**

- MATLAB/Simulink para análise e simulação de sistemas de controle digital e filtros digitais.
- Ambiente de desenvolvimento integrado (IDE) para microcontroladores, como o Code Composer Studio para MSPs.
- Ferramentas de simulação de sinais e sistemas discretos, como GNU Octave ou Python com bibliotecas especializadas (limitado). Ver: http://octave-online.net/ (versão online do Octave).

---

Detalhes:

* Parte teórica: 1 semestre com 19 encontros de 3 horas e 15 minutos com intervalo centra de 15 minutos.
* Parte prática: 9 encontros de 1,5 horas divididos em 2 seções de 1h30min.
* [Pré-requisitos sugeridos](pre_requisitos.html).

---

<font size="1">[T. Dark Graphite]</font>
<font size="2">Prof. Passold, em 11/03/2024, 18/03/2024, 31/04/2024.</font>

