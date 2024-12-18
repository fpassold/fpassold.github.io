<!-- title: Circuitos Digitais I -->

![circuito digital](https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1650&q=80)

# Circuitos Digitais I

## Cap 1) Introdução Circuitos Digitais

* Introdução à disciplina / **Sistemas de Numeração** --> [Intro_Digitais_1.pdf](cap1/Intro_Digitais_1.pdf):

  Conceitos básicos.
  	Sinais analógicos x digitais.
  	Sistemas de numeração e conversão entre bases numéricas.
  	Outros sistemas de codificação.

* Outros Sistemas de Codificação Binários --> [outros_codigos_binarios.pdf](cap1/outros_codigos_binarios.pdf)

  Tabela ASCII;
  	Código Gray e relação com Encoders Absolutos;
  	Encoders Absolutos x Incrementais.

* Exercícios Conversão entre bases
      --> https://fpassold.github.io/Digitais_1/codigos/exe_sist_numeracao.html


* [Exercícios (resolvidos) Sistemas de Codificação](cap1/exemplos_conversao_base.html) <!-- [exemplos_conversao_base.pdf](cap1/) -->

&nbsp;

## Cap 2) Portas Lógicas Básicas

* Portas Lógicas Básicas - Intro --> [Portas_Lógicas_Basicas.pdf](cap2/Portas_Logicas_Basicas.pdf):

      Portas NOT, AND, OR, NAND, NOR, XOR e NXOR;
      Exemplos deduzindo tabelas verdades, formas de onda, equações;
      desenhando primeiros circuitos digitais.

* Portas Lógicas Básicas - Intro (material com anotações) --> [Portas_Lógicas_Basicas - cópia.pdf](cap2/Portas_Logicas_Basicas%20-%20cópia.pdf):

      Mesmo material de "Portas Lógicas Básicas" mas
      acrescentado de anotações realizadas durante a aula
      (resolução de alguns exemplos mostrados em slides)

<!--
		2.2) Aula (gravada): Portas Lógicas BásicasItem postado: 11 de ago. de 2022
		2.3) Aula (gravada): Portas lógicas básicas - exemplos (10.08.2021)Item postado: 11 de ago. de 2022
		2.4) Aula Gravada: Portas XOR NXOR - equações - exercícios portas básicas (10.08.2021)Item postado: 11 de ago. de 2022
--> 

* Portas Lógicas Básicas (Resumo) + Álgebra de Boole --> [PortasLogicasBasicas.pdf](cap2/PortasLogicasBasicas.pdf):

* Simbologia ANSI/IEEE Std 91-1984 - Portas lógicas básicas --> [IEEE_symbols.pdf](cap2/IEEE_Symbols.pdf)

&nbsp;

## Cap 3) Álgebra de Boole

* Álgebra de Boole - Teoria --> [Algebra_Boole.pdf](cap3/Algebra_Boole.pdf) + [Algebra_Boole - editado.pdf](cap3/Algebra_Boole%20-%20editado.pdf):

      Obs.: 2 arquivos PDF's:
      O arquivo "Álgebra_Boole - editado".pdf corrige alguns
      erros e apresenta soluções de exercícios propostos no
      slide original "Álgebra_Boole.pdf".

* Material opcional (em espanhol): --> [algebra_boole_suplementar.pdf](cap3/algebra_boole_suplementar.pdf)

* Video recomendado --> https://www.youtube.com/watch?v=aYVz0l3ZMWc&authuser=1

* Lista de Exercícios (com respostas) --> [exercicios2.pdf](cap3/exercicios2.pdf)

&nbsp;

## Cap 4) Mapas de Karnaugh
4.1 Mapas de Karnaugh (Parte inicial: [Parte 1/2](4_Karnaugh/4_mapas_karnaugh_keynote_novo.pdf));

4.2 Mapas de Karnaugh (agrupamentos possíves, + exemplos, mapas para 5 e 6 variáveis, DEC/Displays, Displays, condições *dont´t care*): [Parte 2/2](4_Karnaugh/Mapas_Karnaugh_2a_parte_2023.pdf))

* [Vídeo no YouTube: **Mapas de Karnaugh**](https://youtu.be/ohRBnobVvgo?si=Ph7Zm48IPD7AOdcp)

&nbsp;

## Cap 5) Funções Lógicas (ou Circuitos MSI)

5.1) Funções Lógicas --> [circuitos_media_escala_integracao_pt_2.pdf](msi/circuitos_media_escala_integracao_pt_2.pdf) (8,2 MB; 80 slides)

5.2) [Pastilhas MSI](msi/pastilhas_MSI.pdf)  (várias pastilhas com símbolos lógicos e tabelas verdade)

5.3) Avaliação (complementar) - Funções Lógicas

5.4) Exemplos:

* Video Youtube: exemplificando [funcionamento de DEC 3/8](https://youtu.be/ZnH7KCXbZhc?si=k65qQc6xv5jaiNcu);
* [Exemplos de circuitos digitais usando pastilhas MSI: MUX e Comparador Magnitude](MSI_exemplos/exercicios_01.html) (ou exemplos de uso de funções lógicas);
* [Exemplo de efeito visual usando DEC 3/8](Lab_9_Efeito_Visual/Lab_9_Efeito_Visual_Usando_DEC.html);
* Exemplo de circuitos combinacionais: [DEC´s especiais para Display 7-Segmentos](https://youtu.be/MxOgABeGGLg?si=XPuZK49xv6NUeLad) (caracteres diferentes; "frases")
* Exemplo de [circuito de Bargraph (velocímetro de bicicleta](https://youtu.be/EuQ4-OHVD6w?si=FHujYx9g7wQQAYE0));
* [Exemplo de uso de **DEC** com Pastilhas de Memória](resumo_MSI/exemplo_uso_DEC.html);
* [Funcionamento de **MUX** de 4 canais de entrada (com animação)](Funcionamento_MUX/funcionamento_MUX_4.html);

&nbsp;

5.5) [Exercícios](msi/exercicios_4.pdf)  + [Respostas](msi/exercicios_4_respuestas.pdf)  + [Erratas](msi/Errata_2a_lista_exercicios_digitais_1.pdf) (algumas respostas).

*   [Exemplo de projeto de Decodificador para Display 7-segmentos usando FPGA (linguagem Verilog)](SystemVerilog Study Notes. Hex-Digit to Seven-Segment LED Decoder RTL Combinational Circuit - elemen.pdf).

&nbsp;

## Cap 6) Aritmética Binária Digital

*   Circuitos Aritméticos Binários (Arquivo [PDF](ula/Aritmetica_Digital_KeyNote_v5.pdf));
    *   [Exemplos de operações artiméticas binárias](exemplos_operacoes_sinais/exemplos_operacoes.html) de números inteiros com sinal;
*   Teoria ULA's (Arquivo [PDF](ula/ULAs.pdf));
    *   Exemplo de [Projeto de ULA 4-bits 8-operacoes (pdf)](exe_ulas/projeto_exemplo_ULA_4-bits_8-operacoes.pdf) (2016);
*   [Lista Exercícios 3a-prova (pdf)](exe_ulas/digitais_1_exerecicios_p3.pdf) (com soluções).

&nbsp;

## Cap 7) Intro Arquitetura Computadores

*    [Intro Arquitetura Computadores (pdf)](intro_arquitetura_computadores.pdf) 
*   Sites sugeridos:
    *   [Arquitetura Von Neumann (e seu "gargalo")](https://en.wikipedia.org/wiki/Von_Neumann_architecture):
    *   [Arquitetura Harward](https://en.wikipedia.org/wiki/Harvard_architecture);
    *   [Lei de Moore](https://en.wikipedia.org/wiki/Moore%27s_law);
    *   [Novo chip para IA da IBM: **North Pole**](https://research.ibm.com/blog/northpole-ibm-ai-chip);
        *   Artigo na [Scince](https://www.science.org/doi/full/10.1126/science.adh1174) e [Nature](https://www.nature.com/articles/s41586-023-06337-5): chip capaz de estocar informações (pesos sinápticos) de forma analógica usando "**phasse-change memories**" (não volátil).
        *   **[Vídeo no YouTube (Anastasi In Tech)](https://www.youtube.com/watch?v=p0W5eHn5sZ0)**.
        *   [Redes ResNet-50](https://huggingface.co/microsoft/resnet-50) (rede para reconhecimento fde imagens);
        *   [Rede YOLOv4](https://arxiv.org/abs/2004.10934) (rede para detecção de objetos).
        *   [Redes Transformer](https://blog.research.google/2017/08/transformer-novel-neural-network.html) (rede recorrente; para modelos de linguagem (LLM's): ChatGPT);
        *   [O que é IA Generativa?](https://research.ibm.com/blog/what-is-generative-AI).
        *   [Algoritmo de Strassen's para multiplicação de matrizes 2x2](https://www.quantamagazine.org/ai-reveals-new-possibilities-in-matrix-multiplication-20221123/);
        *   Novo Algoritmo (Google DeepMind) para multiplicação de matrizes (usando aprendizado reforçado): [vídeo YouTube 1](https://www.youtube.com/watch?v=WHuH4qSqoRs), [video YouTube 2 (Quanta Magazine)](https://www.youtube.com/watch?v=fDAPJ7rvcUw) e artigo na [Nature](https://www.nature.com/articles/s41586-022-05172-4);

&nbsp;

----

## Tutoriais: Software para Circuitos Digitais I:

* [Tutorial para uso do LogiSim](Uso_LogiSim.html);
* Video YouTube: [Uso do **LogiSim**](https://youtu.be/NBPMN7aTm_Y?si=f9tcww26C64ca5Bm)
* Vídeo YouTube: [Video Intro Usando **Proteus** 7.x (Win7) e 8.x (Win10)](https://youtu.be/4wIsafBMCFs)

----

## Exercícios

* Exercícios 1a-Prova
* 	Exercícios sobre conversões entre bases numéricas [[aula de 14.09.2021](codigos/exe_sist_numeracao.html)];
* [Exercícios Mapas de Karnaugh](exe_mapas_K_2021_1/exemplos_mapas_K3.html): usando Mapas de Karnaugh envolvendo 3 variáveis:
* Exercícios 2a-Prova
* [Exemplos de Operações Aritméticas Binárias](exemplos_operacoes_sinais/exemplos_operacoes.html);

&nbsp;

[:guitar:](https://youtu.be/ZLQiD4_OiLU?si=5MThm5cd2kzeSy7q)

---

Fernando Passold, atualizado em 17.03.2011; 21/11/2023.
