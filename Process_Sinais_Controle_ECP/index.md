![Kioto_2](Kioto_2.jpg)

# Processamento de Sinais e Controle Digital

:point_right: Parte de **[Laboratório](lab/lab_proces_ecp_2024.html)** 🖥️ !?

👇 Segue Parte Teórica

**Conteúdo Previsto**:

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

Parte 1: **Controle Digital**:

1. Modelagem do Sustentador de Ordem Zero ([cálculo de $BoG(z)$](https://fpassold.github.io/Controle_3/3_transformada/3_BoG_Transformada_Z.pdf))
2. [Impacto (ou falta) do $BoG(z)$](https://fpassold.github.io/Controle_3/3_5_Modelagem_G_BoG/teste_BoG.html)
3. [Sistema de 1a-ordem digitalizado](https://fpassold.github.io/Controle_3/exemplo_1_BoG/intro_exemplo_1a_ordem.html) (uso de Matlab)
4. Análise de Sinais/Transformada de Laplace/Modelagem (voltado à Controle Digital)
   1. [Transformada de Laplace](3_transformada_laplace.pdf) (aplicado à Controle: revisão).
   2. [Respostas temporais](4_Respostas_Sistemas.pdf) típicas de Processos Industriais.
   3. [Introdução à Modelagem](5_intro_modelagem.pdf) (algumas técnicas).
   4. [Paralelos entre plano-s $\times$ plano-z](6_respostas_paralelos_s_z.pdf) (parte final: malha controle digital típica).
5. [Introdução ao Matlab](../Matlab/aula_intro_matlab_1.html) 
6. [Ações Básicas de Controle](7_acoes_controle.pdf): P, PI, PD, PID e outros (ainda mundo contínuo).
7. [Teoria do Erro](https://fpassold.github.io/Controle_3/4_teoria_erros/resumo_teoria_erro.html) (ou da Precisão + importância do integrador c/ dedução integral numérica).
8. **Projetos de Controladores Digitais usando Root-Locus**:
   1. O que é o "Root Locus" ?
   2. Controlador Proporcional -- [Aula de 08/04/2024](2024_1/aula_080402024.html);
   3. Controlador Proporcional + Controle com Ação Integral Pura -- [Aula de 22/04/2024](2024_1/aula_22042024.html);
   4. Controlador PI (diferentes opções) + "Lag" -- [Aula de 29/04/2024](2024_1/aula_29042024.html);
   5. Teoria associada com controladores PD e Lead:
      1. [Base Teórica](https://fpassold.github.io/Controle_3/Controle_Acao_Derivativa.html);
        (video* da aula de [Processamento Sinais (Parte 1/2) (2024-05-06 19:53 GMT-3)](https://drive.google.com/open?id=1TUPkOz03XtrCgci29U_2iWQJ1XH5Kl9u));
      2. [Teste de Controladores com Ação Derivativa](https://fpassold.github.io/Controle_3/estudo_caso/Teste_Controladores_Acao_Derivativa.html) (uso de Matlab/Simulink);
          (video* da aula de [Processamento Sinais (Parte 2/2) (2024-05-06 21:01 GMT-3)](https://drive.google.com/open?id=1UbSlcx5dHV9S7n09K8VHMfBXQ8EfScXY))
      3. ["Resumo"](https://fpassold.github.io/Controle_3/pd_plus_filtro.pdf);
         *Videos eventualmente só acessíveis com usuário logado no domínio @upf.br.
   6. Controlador PD aplicado à planta do estudo de caso:
      1. [Aulas passadas](https://fpassold.github.io/Controle_3/projeto_PD_lead_2020.html);
      2. [Aula de 13/05/2024](2024_1/aula_13052024.html) (Projeto de PD e Lead).
   7. Controlador PID:
      1. [Embasamento teórico](https://fpassold.github.io/Lab_Controle_2/PID/pid.html);
      2. [Sintonizando um PID](https://fpassold.github.io/Controle_2/8_Ajuste_PID/Sintonia_PIDs_usando_ZN.html), Tabela de Ziegler-Nichols [(Wikipedia)](https://en.wikipedia.org/wiki/Ziegler–Nichols_method);
      3. PID no formato velocidade: [figura](https://fpassold.github.io/Controle_3/PID/uso_planta_PID_velocity.png) + arquivos: [.SLX](https://fpassold.github.io/Controle_3/PID/planta_PID_velocity.slx) ou [.MDL](https://fpassold.github.io/Controle_3/PID/planta_PID_velocity.mdl) (Simulink).

Fim da 1a-parte: Controle Digital

Parte 2: **Processamento (Digital) de Sinais**:

1. Análise de Sinais/Transformada de Fourir/Modelagem - aplicado à Processamento (Digital) de Sinais
   2. Diagrama de Bode (análise)
   3. Série de Fourier (espectro de ondas; síntese de onda quadrada)
   4. DFT e FFT, cuidados.
5. Filtros digitais.
   1. Filtros de média aritmética, média móvel;
   2. Filtros FIR
   3. Filtros IFIR
6. Implementação em sistemas embarcados de filtros digitais.



Parte Prática da disciplina: Aulas de **[Laboratório](lab/lab_proces_ecp_2024.html)** (a partir de 30/04/2024).



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

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("Fernando Passold, página atualizada em " + LastUpdated); // End Hiding -->
</script>


