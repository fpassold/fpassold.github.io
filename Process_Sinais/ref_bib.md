# Processamento (Digital) de Sinais

Conteúdo Previsto

**1-parte: baseado em "Digital Signal Processing Foundations"**, de David Dorran -->  [1-Digital Signal Processing Foundations.pdf](../Teoria/1-Digital Signal Processing Foundations.pdf), 29 páginas:

1. Intro. Sistemas Discretos -->  [intro_process_sinal.html](intro_process_sinal.html) 
2. Filtro de Média Móvel -->  [media_movel.html](media_movel.html) 
   1. Uso da função `filter()` do Matlab -->  [funcao_filter.html](funcao_filter.html) 
3. Modelagem de Sistema Termico -->  [modelo_termico.html](modelo_termico.html) 
4. Usando FFT (no Matlab) -->  [usando_fft_matlab.html](usando_fft_matlab.html) 



Este material termina com:

* System frequency response --> YouTube: [Frequency Response - Introduction](https://www.youtube.com/watch?v=IhfAA9hZJLM), 6min55:
  * Linear time-invariane systems: 1:12
  * The Magnitude response: 4:19
  * Recap the main points: 5:57
* Magnitude response using plots -->  YouTube: [Frequency Magnitude Response Explained using Plots](https://www.youtube.com/watch?v=YjvEfmjU7GA), 8:02:
  * Frequency Response: 0:47
  * Examples: 1:57
  * Hig-Pass Filer: 4:55
* Filtering signals using discrete systems --> YouTube: [filtering in **matlab** using 'built-in' filter design techniques](https://www.youtube.com/watch?v=vfH5r4cKukg), 18:01:
  * Intro: 0:00
  * Butter: 2:52
  * Frequency Response: 5:48
  * Filter: 7:45
  * High order filter: 9:19
  * Higher order filter output: 11:30
  * Band reject filter: 13:35
  * Documentação (PDF) previsto em --> ResearchGate: [**Digital Filters -A practical guide**](https://www.researchgate.net/publication/360964002_Digital_Filters_-A_practical_guide?channel=doi&linkId=6295f1eb6886635d5cb15d01&showFulltext=true), May 2022. --> baixado como:  [3-DigitalFilters-apracticalguide.pdf](../Teoria/3-DigitalFilters-apracticalguide.pdf) 
  * Código disponível em: [Filter Design Using Matlab Demo](https://dadorran.wordpress.com/2013/10/18/filter-design-using-matlab-demo/) --> baixado como:  [1_filter_design_demo.m](../Teoria/ddorran_codes/1_filter_design_demo.m) 



Falta:

2a-parte: "**An introduction to the frequency-domain and negative frequency**", March 2023, 27 pp.  -->  [2-Anintroductiontothefrequency-domainandnegativefrequency.pdf](../Teoria/2-Anintroductiontothefrequency-domainandnegativefrequency.pdf) :

>  Se você é completamente novo no DSP, recomendo que primeiro dê uma olhada no documento de fundamentos. Depois de ler este documento, você pode querer revisar a resposta de frequência.
>
> **Table of Contents**
> How to use this series of documents 
> An introduction to the frequency-domain 
> 	What are sinusoidal waveforms? 
> 	All signals can be decomposed into sinusoidal waveforms 
> 	A note on the duration of a sinusoidal waveform 	
> 	A note on Fourier analysis
> How to use Octave/Matlab’s fft function 
> 	Using Octave/Matlab’s fft function to analyse a bass guitar signal
> 	Interpreting the output of the fft function 
> Negative Frequencies  
> 	Visualising complex exponentials and negative frequency . 
> 	Why complex exponential waveforms have a helix shape 
> 	Another perspective on complex exponentials
> 	The magnitude spectrum of a complex exponential 



3a-parte: "**Digital Filters -A practical guide**" -->  [3-DigitalFilters-apracticalguide.pdf](../Teoria/3-DigitalFilters-apracticalguide.pdf), 66 pp, May 2022.

> A filtered audio example
> An introduction to a filter’s frequency response
> 	Matlab/Octave code used to create the ‘toy examples’
> 	The magnitude response of the audio filter example 
> 	Magnitude response quiz 
> The decibel magnitude scale and logarithmic frequency axis 
> 	The decibel (dB) magnitude scale
> 	The logarithmic frequency axis  
> Implementing filters using filter design functions in Matlab/Octave 
> 	Filter order 
> 	Filter cut-off frequency (normalised frequency) 
> 		Normalised Frequency (radians per sample) 
> 	Filter types 
> 	Designing a minimum order filter  
> 	Other filter design functions and their benefits
> Some ‘intuitive’ filters (moving averager, comb filter, DC removal)
> 	Moving averager 
> 	Comb filter 
> 	DC removal (a basic high pass filter)
> Linear Time-Invariant (LTI) systems
> 	Linearity 
> 	Time-Invariance .
> Transient response of filters 
> 	Why transients always occur at system start-up 



4a-prate: "YY" -->  [4-TheDiscreteFourierTransform-Apracticalapproach.pdf](../Teoria/4-TheDiscreteFourierTransform-Apracticalapproach.pdf) 



5a-parte: "ZZ" -->  [5-TheZ-transform-Apracticaloverview.pdf](../Teoria/5-TheZ-transform-Apracticaloverview.pdf) 



---

## Material Extra

Talvez Laboratório:

* Arduino sinuoidal waveform generator and signal capture | dadorran -->  [Arduino sinuoidal waveform generator and signal capture | dadorran.pdf](../Teoria/Arduino sinuoidal waveform generator and signal capture | dadorran.pdf). Acompanha arquivo:  [arduino_sin_gen.zip](../Teoria/ddorran_codes/arduino_sin_gen.zip):

  ```bash
  fernandopassold@MacBook-Pro-de-Fernando /V/D/U/f/D/U/P/T/d/arduino_sin_gen> tree
  .
  ├── breadboard circuit.jpg
  ├── link to video demo.txt
  ├── schematic.svg
  └── sin_gen
      ├── DAC_MCP49xx.cpp
      ├── DAC_MCP49xx.h
      └── sin_gen.ino
  
  2 directories, 6 files
  fernandopassold@MacBook-Pro-de-Fernando /V/D/U/f/D/U/P/T/d/arduino_sin_gen> 
  ```

  *  Video no YouTube: [sinusoidal generator with ADC capture on Arduino Nano](https://www.youtube.com/watch?v=_31sQn1Cg9g), 5:37,  26 de nov. de 2020.

* YouTube --> [Demonstration of Discrete/Digital Signal Capture](https://www.youtube.com/watch?v=ArEFvrF-sPU), 9:51, 5 de jun. de 2011:

  * Light Sensor (LDR !?): 0:27
  * ADC: 1:19
  * Sampling Rate: 3:08
  * 

* Virtual Oscilloscope --> https://pzdsp.com/elab/

  * Video explicativo no YouTube: [How to use an oscilloscope - an interactive simulation](https://www.youtube.com/watch?v=-LcKO7f-sEk), 4:34, 16 de abr. de 2020.
  * Como foi criado (época do COVID-19) --> https://www.pzdsp.com/elab/tutorial/ + PDF: "**A Guide to Implementing Online Simulations using HTML, JavaScript and SVG images**", [ResearchGate](https://www.researchgate.net/publication/350459302_A_Guide_to_Implementing_Online_Simulations_using_HTML_JavaScript_and_SVG_images?channel=doi&linkId=6061b07f299bf17367780704&showFulltext=true).

* [FFT based FIR filter design](https://dadorran.wordpress.com/2019/07/19/372/).



---

Fernando Passold, 31/03/2024

