![Kioto-Koizumo_Junsaku-twin_dragons_2](figuras/Kioto-Koizumo_Junsaku-twin_dragons_2.jpeg)

# Processamento Digital de Sinais

(Eng. Elétrica / disciplina de apenas 2 créditos)

**Conteúdo previsto**:

1. [**Teoria da Amostragem** e Aquisição de Sinais](https://fpassold.github.io/Controle_3/2_sampling/01_Sistema_Amostrado_no_Tempo.pdf).
   1. [Simulação demonstrando Teorema da Amostragem](https://fpassold.github.io/Controle_3/Teste_Amost/teste_amostragem.html) (*Amostrando uma onda dente-de-serra*).
   2. [Síntese de Onda Quadrada usando Série de Fourier](https://fpassold.github.io/Controle_3/estudo_dirigido/Síntese_Onda_Quadrada.html). 
   3. [Wolfram Demonstrations Project: **Sampling Theorem**](https://demonstrations.wolfram.com/SamplingTheorem/)
   4. [Wolfram Demonstrations Project: **Aliasing** in Time Series Analysis](https://demonstrations.wolfram.com/AliasingInTimeSeriesAnalysis/);
2. Transformada Z.
   1. Parte 1:  [transformada_Z.pdf](../Controle_3/3_transformada/transformada_Z.pdf) (parte inicial, definições, transformadas de sinais "básicos")
   2. Parte 2:  [transformada_Z_parte2.pdf](../Controle_3/3_transformada/transformada_Z_parte2.pdf) (continuando com transformadas de outros sinais, propriedades)
   3. Parte 3:  [transformada_Z_parte_3.pdf](../Controle_3/3_transformada/transformada_Z_parte_3.pdf) (Métodos Transformada Inversa de Laplace)
   4. Resumo:  [revisao_partes_importantes_transformada_Z.pdf](../Controle_3/3_transformada/revisao_partes_importantes_transformada_Z.pdf) (paralelos sinais/sistemas tempo contínuo x tempo discreto)
3. [Iniciando no Matlab](https://fpassold.github.io/Matlab/aula_intro_matlab_1.html) ou [Matlab fácil](https://fpassold.github.io/Matlab/tutorial.html) (outro tutorial) ou [Matlab Guide](https://fpassold.github.io/Matlab/Matlab_guide.pdf) (arquivo PDF, 44 pp.) 
4. [Intro. Sistemas Processamento Digital de Sinais](intro_process_sinal.html)
   
   1. **[Filtro de Média Móvel](media_movel.html)**;
      1. [Uso da função `filter()` do Matlab](funcao_filter.html)
   2. [Modelagem de Sistema Térmico](modelo_termico.html)
5. [Usando FFT (no Matlab)](usando_fft_matlab.html)
   
   1. Analisador de Espectro - [exemplos de uso](https://academo.org/demos/spectrum-analyzer/) 
      (site academo.org, em inglês com animações Javascript);
   2. [Exemplo de uso de Espectro de um Sinal](exe_uso_fft.html) (Espectro de sinal de bateria; tentativa de recomposição do sinal).
6. Revisando [Funções Trasferência](funcao_transferencia.html) (Diagramas pólo-zero).
7. [Estabilidade](estabilidade.html) de Sistemas Discretos.
8. [Impacto dos pólos e zeros](papel_polos_zeros.html) na magnitude da resposta frequencial de um sistema.
9. Projeto de Filtros:
1. [Filtro Passa-Baixas Exponencial](https://fpassold.github.io/Lab_Processa_Sinais/Filtro/filtro_exponencial.html);
   2. [Filtros Butterworth digitais](butter1.html);
   3. "Projeto por emulação" → [Transformações biliares: Método de Tustin](metodo_tustin.html).
      2. [Filtro Passa Baixas](FPB_Arduino.html) de 1a-ordem e Butterworth de 2a-ordem (uso do método de Tustin):
      Revisando Diagrama de Bode, Funções Transferência e FFT - baseado em: [How to design and implement a digital low-pass filter on an Arduino](https://www.youtube.com/watch?v=HJ-C4Incgpw), (de 20/06/2021, [Curio Res](https://www.youtube.com/@curiores111)) - (material em inglês, mas ótimas animações enfatizando uso, papel da magnitude e do atraso num filtro passa-baixas) - (Acessado em 20/05/2024).
   4. Projeto usando alocação pólo-zero: [Filtro Notch sobre sinal de ECG](projeto_polo_zero.html) (Eletrocardiograma). 
      <!-- projeto_polo_zero.md (em edição> 27/05/2024) -->
10. [Reverberação](https://fpassold.github.io/Lab_Processa_Sinais/Lab_2/lab_2_convolucao.pdf) (baseado em [Teoria da Convolução](https://fpassold.github.io/Lab_Processa_Sinais/Convolucao/convolucao.html)).

<!--🚧 Conteúdo atualizado até 18/06/2024 -->

**Formas de Avaliação:**

- Avaliação de projetos de filtros digitais
- Participação em discussões e atividades em sala de aula.
- Trabalhos individuais e em grupo.
  - [Trabalho #1)](trabalho_1_2024_1.html) Sobre sinais amostrados (Teorema de Amostragem) Deadline: 15/04/2024. (Equipes de no máximo 2 alunos + 1 equipe de 3 alunos).
  - ~~[Trabalho #2)](guitar.html) Resinstetizando sinal de guitarra~~ (não exigido em 2024/1) ⚠︎.
  - Trabalho #3) Filtrando sinal de ECG usando: 
    - Média Móvel;
    - Filtro Notch (projeto por emulação);
    - Filtro Notch (projeto por alocação de pólos-zeros),  e;
    - Filtro Butterworth de 5a-ordem.

---

**Softwares Indicados:**

- MATLAB/Simulink para análise e simulação de filtros digitais.
- http://octave-online.net/ (versão online do Octave).
- Eventualmente Pyhon + Jupyter:
  Para baixar o Python: https://wiki.python.org/moin/BeginnersGuide/Download;
  Para instalar o Jupyter ("Python interativo"): https://jupyter.org/install.html
  ou instale:
  Miniconda: https://docs.anaconda.com/free/miniconda/index.html (menor)
  [Anaconda](https://www.anaconda.com): https://www.anaconda.com/download (pode exigir 4.8 Gbytes - mas se você pretende com IA... :smile: ).

------

<font size="2">🌊 [Fernando Passold](https://fpassold.github.io/)[ 📬 ](mailto:fpassold@gmail.com), <script language="JavaScript"><!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("página criada em 05/05/2024; atualizada em " + LastUpdated); // End Hiding -->
</script></font>



