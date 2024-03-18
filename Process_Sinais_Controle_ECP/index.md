# Processamento de Sinais e Controle Digital

**Conteúdo sendo previsto** (parte teórica):

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
3. Análise de Sinais/Transformada de Laplace/Modelagem - aplica à Controle Digital
   1. [Transformada de Laplace](3_transformada_laplace.pdf) (aplicado à Controle: revisão).
   2. [Respostas temporais](4_Respostas_Sistemas.pdf) típicas de Processos Industriais.
   3. [Introdução à Modelagem](5_intro_modelagem.pdf) (algumas técnicas). 
4. Açoes de Controle Típicas
   1. Ações Típicas de Controle: P, PI, PD e PID:
      1. Modelos/Simulações no mundo contíniuo - plano-s;
      2. Paralelos entre planos s e z
      3. Modelos/Simulações no mundo digital - plano-z.
5. Implementação em sistemas embarcados de controladores digitais.
6. Análise de Sinais/Transformada de Fourir/Modelagem - aplica à Processamento (Digital) de Sinais
   1. Diagrama de Bode (análise)
   2. Série de Fourier (espectro de ondas; síntese de onda quadrada)
   3. DFT e FFT, cuidados.
7. Filtros digitais.
   1. Filtros de média aritmética, média móvel;
   2. Filtros FIR
   3. Filtros IFIR
8. Implementação em sistemas embarcados de filtros digitais.

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
- Ferramentas de simulação de sinais e sistemas discretos, como GNU Octave ou Python com bibliotecas especializadas (limitado).

---

Detalhes:

* Parte teórica: 1 semestre com 19 encontros de 3 horas e 15 minutos com intervalo centra de 15 minutos.
* Parte prática: 9 encontros de 1,5 horas divididos em 2 seções de 1h30min.
* [Pré-requisitos sugeridos](pre_requisitos.html).

---

Prof. Passold, em 11/03/2024, 18/03/2024.

