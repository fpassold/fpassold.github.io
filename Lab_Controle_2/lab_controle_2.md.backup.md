<!-- title: Lab Controle 2 -->
![https://unsplash.com/photos/U9YrT6trizs](https://images.unsplash.com/photo-1605387202149-47169c4ea58a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80)
Photo by <a href="https://unsplash.com/@marcwieland95?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Marc Wieland</a> on <a href="https://unsplash.com/s/photos/sailing?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

# Laboratório de Controle Automático II

## Aulas:

* Lab 1) [PID (alógico) e Métodos de sintonização](Lab1/lab1.html) <!-- (aula de 13/10/2022). :white_check_mark: -->

* Lab 2) Simulações sintonização PIDs: 
  * [Sintonia de PID: Método 1) Resposta em MA para entrada degrau](aula2/aula2.html) <!-- (aula de 20/10/2022); :white_check_mark: -->
  * [Sintonia de PID: Método 2) Buscando *Ku*](aula2/aula2b.html) <!-- (aula de 20/10/2022); :white_check_mark: -->
  * [Sintonia de PID: Método 3) Método do Relé (Parte I: teoria)](https://fpassold.github.io/Controle_2/8_Ajuste_PID/Sintonia_PIDs_usando_ZN.html); <!-- (aula de 27/10/2022); :white_check_mark: -->
  * [Sintonia de PID: Método 3) Método do Relé (Parte II: simulação)](aula2/metodo_rele_2_simulink.html); <!-- (aula de 27/10/2022); :white_check_mark: -->

&nbsp;

* Projeto Final <!-- (Proposta não confirmada) (versão 1)** (**==cancelado== em 01/12/2022)**; -->
  * [Texto sobre Projeto Final](Projeto_Final/projeto_final.html); <!-- >:white_check_mark: -->
  * [**Arduino & Interrupções**](Arduino_Int/Arduino_Int.html); <!-- :white_check_mark: -->
  * [Sugestões uso PWM filtrado do Arduino com kit Feedback](Projeto_Final/parte_10_11_2022.html); <!-- :white_check_mark: -->
  * [Gerador **Senoide** 40 Hz](Projeto_Final/gerador_senoidal.html); <!-- :white_check_mark: -->
  * [Gerador **onda triangular** 0,1 Hz](Projeto_Final/onda_triangular.html); <!--  :white_check_mark: -->
  * [Prevendo uma **Interface com o Usuário**](Projeto_Final/interface_usuario.html);

&nbsp;

* [Controle de Posição usando PID Analógico](controle_posicao.html) (Aula prevista para 11/04/2023, Ok :+1:)

&nbsp;

* [PID Digital](PID/pid.html) (equações, código, implementação) (previsto para 25/04/2023)

&nbsp;

* [Aplicando uma Onda Triangular](onda_triangular_driver/triangular_no_driver.html) no driver de potência SA150D da Feedback (controle de velocidade em malha-aberta) -- teste realizado no dia 25/04/2023.
* Como [trabalhar com Módulo I2C MPC 4725](PID_Digital/modulo_DAC.html).

&nbsp;

---

#### Sequencia de aulas previstas para o semestre de 2023/1:

* Módulo externo de ajuste de ganho/offset para A/D;
* Módulo externo D/A p/Arduíno (Raspberry);
* Filtros Passa-Baixa de 5a-ordem.

* Testes com **PID Analógico**:
	* Controle de Posição ou, :v: (realizado em 11/04/2023)
	* Controle de Velocidde.
	* Usando Método 2 de sintonia de PID (fechamento da malha com Controlador Proporcional, determinação de $K_u$ e $T_u$ (usando osciloscópio))
	* Sintonia fina

* Testes com **PID Digital** usando placa Arduino One
  * Aplicando onda triangular (saída PWM filtrada) com $T=10$ segundos no driver de potência (módulo SA150D) (teste em 25/04/2023)
  * Selecionar e fixar fs (50 ou 100 Hz) ou T.
  * Implementar (usando Interrupção), algoritmo de PID  Parelelo;
  * Prever alguma interface de entrada e de saída com usuário.
  * Sintonia deste PID usando Método 2.
  * Sintonia Fina


<!--
  * [PIC com anti-windup](PID_anti_windup/PID_anti_windup_1.html) (página em desenvolvimento).

* **Trabalho Final** (Proposta não confirmada)
  
  * [**PID com Anti-Windup**](Trabalho_Final_2/trabalho_final_2_lab_controle_2_2022_2.html) 
-->  
  <!--(Data entrega: 08/12/2022) -->

-----

<font size="1">[♫](https://soundcloud.com/prmdmusic/sets/hotel-garuda-ft-violet-days) Fernando Passold, em 22/10/2022, 02/12/2022, 11/04/2023</font> .
