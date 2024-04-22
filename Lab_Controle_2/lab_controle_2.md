<!-- title: Lab Controle 2 -->

![https://unsplash.com/photos/U9YrT6trizs](https://images.unsplash.com/photo-1605387202149-47169c4ea58a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80)

<font size="2">
Photo by <a href="https://unsplash.com/@marcwieland95?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Marc Wieland</a> on <a href="https://unsplash.com/s/photos/sailing?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
</font>

# Laboratório de Controle Automático II

### Teoria

* [PID (Analógico) e Métodos de sintonização](Lab1/lab1.html) (Resumo) <!-- (aula de 13/10/2022). :white_check_mark: -->

* Sintonização de PIDs: 
  * [Sintonia de PID: Método 1) Resposta em MA para entrada degrau](aula2/aula2.html) <!-- (aula de 20/10/2022); :white_check_mark: -->
  * [Sintonia de PID: Método 2) Buscando *Ku*](aula2/aula2b.html) <!-- (aula de 20/10/2022); :white_check_mark: -->
  * [Sintonia de PID: Método 3) Método do Relé (Parte I: teoria)](https://fpassold.github.io/Controle_2/8_Ajuste_PID/Sintonia_PIDs_usando_ZN.html); <!-- (aula de 27/10/2022); :white_check_mark: -->
  * [Sintonia de PID: Método 3) Método do Relé (Parte II: simulação)](aula2/metodo_rele_2_simulink.html); <!-- (aula de 27/10/2022); :white_check_mark: -->
  * Trabalho #1 ( [2024/1](trabalho_1_2024_1.html) ) <!-- | [2023/1](aula2/trabalho_1_2023_1.html) | [2022/2](aula2/trabalho_1_2022_2.html) ) -->
<!--&nbsp;-->
  * [PID Digital](PID/pid.html) (equações, código, implementação) <!--(previsto para 25/04/2023)-->
<!-- * [PID com anti-windup](PID_anti_windup/PID_anti_windup_1.html) (página em desenvolvimento).-->
  * [PID com Anti-Windup](Trabalho_Final_2/trabalho_final_2_lab_controle_2_2022_2.html) (Trabalho final em 2022/2) 

### Parte Prática

<!--~~* [Proposta de Projeto Final (2022/2)](Projeto_Final/projeto_final.html) :white_check_mark: -->

  * [**Arduino & Interrupções (Rotinas ISR)**](Arduino_Int/Arduino_Int.html); <!-- :white_check_mark: -->
  * [Exemplo Processo Bola-no-Tubo (interface c/usuário); conexão PWM do Arduino à kit Feedback](Projeto_Final/parte_10_11_2022.html); <!-- :white_check_mark: -->
  * Exemplo\_1: [Usando Arduino (saída PWM) para gerar **Senoide** de 40 Hz](Projeto_Final/gerador_senoidal.html) :+1:
  * Exemplo\_2: [Usando Arduino (saída PWM) para gerar **onda triangular** de 0,1 Hz](Projeto_Final/onda_triangular.html) :+1:
    * [Teste de Onda Triangular](onda_triangular_driver/triangular_no_driver.html) - aplicado no driver de potência SA150D da Feedback (controle de velocidade em malha-aberta) -- teste realizado em 25/04/2023 :+1:
  * [**Interface com o Usuário?**](Projeto_Final/interface_usuario.html);
<!--&nbsp;-->
* [**Sintonia prática de PID Analógico** aplicado em Controle de Posição no kit Feedback](controle_posicao.html) (Aula de 11/04/2023, :+1:)
<!--&nbsp;-->
* [Como trabalhar com Módulo DAC: MPC 4725](PID_Digital/modulo_DAC.html) (Conexão I2C com Arduino One).
<!--&nbsp;-->
* Teste de [PID Digital usando Arduino Uno](PID_Arduino/PID_no_Arduino.html), (algoritmo de controle executado à taxa de 100 Hz; interface com usuário via comunicação serial/USB).
* [Setup previsto para placa Arduino Uno + kits Feedback](PID_Arduino/setup_arduino_PID.html);



* Eventual uso de placa Raspberry Pi 3 executando run-time CODESYS (2024/1); :new:
  * [Sobre o CODESYS](CODESYS/instalacao.html);
  * [Instalação do CODESYS Development System](CODESYS/codesys_install.html);
  * [SSH para placa Rasp](CODESYS/SSH_Rasp.html) (descobrindo seu número IP);



-----

<font size="1">[♫](https://soundcloud.com/prmdmusic/sets/hotel-garuda-ft-violet-days) Fernando Passold, em 22/10/2022, 02/12/2022, 11/04/2023</font> .

