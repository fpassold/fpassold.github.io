<!-- ttitle: Controle Automático II -->

![Photo by David Watkis, Golden Gate Bridge](https://images.unsplash.com/photo-1566153580922-16a9709fff30?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1469&q=80) <font size="1"> Photo by David Watkis on https://unsplash.com/images/feelings/cool?</font> 

# Curso de Controle Automático II

## 2) Ações de Controle

* Exemplo de [Controle de Velocidade de motor CC](Testes_Velocidade_Motor_CC/modelagem_motor_cc.html) (diferentes controladores), incluindo sua modelagem.

## 3) Teoria do Erro

* [Exemplos de sistemas à serem simulados](Simulink_Erros/Readme.html) (Matlab/Simulink: arquivos disponibilizados)

## 4) Estabilidade

- [Parte 1](estabilidade.html) (Conceitos e simulações)
- [Parte 2](estabilidade2.html) (Incompleto)

## 5) Projeto de Controladores usando Root Locus

- [Projeto de Controladores usando Root Locus (Parte I): Controlador Proporcional](projeto_usando_root_locus_parte_1.html);
- [Melhorias em Controlador Proporcional !?](Melhora_Kp/melhorias_controlador_proporcional.html) (aula de 04/06/2021)
- [**Projeto de Controladores Prooporcional e com Ação Integral**](PI_parte1.html)
- [Projeto de Controlador Proporcional (Aula #1: 2022/2)](control2inf_2020_2/aula_10102022.html) (aula de 10/10/2022; cálculo de $Kp$ em função do $e(\infty)$ desejado);

- Projeto de Controladores com **Ação Integral**:
  - [Projeto de Controladores com Ação Integral (Aula #2: 2022/2)](control2inf_2020_2/17102022.html) (aula de 17/10/2022);
  - [Projeto de PI (por contribuição angular) + Lag](PI_angular_Lag.html); (Aula de 30/10/2020);
    - [Projeto de PI usando contribuição angular](projeto_controladores_acao_integral_extendido.html)(versão antiga, de 2019/2);
    - [Exemplo$_1$ (Aula de 20/05/2020)](aula_20_05_2020/aula_20_05_2020.html): Projeto de PI usando Contribuição Angular + Projeto de Compensador por Atraso de Fase.
    - [Exemplo$_2$ (Aula de 26/10/2020)](2020_2/PI_Lag_aula_26_10_2020.html): Projeto de PI usando Contribuição Angular + Projeto de Compensador por Atraso de Fase.
    - [Exemplo$_3$ (Aula de 14/05/2021)](controle_2_info_2021_1/aula_14_05_2021.html): **E quando o $t_s$ desejado é impossível de ser alcançando?**
  - [Observações](observacoes_cuidados_contribuicao_angular.html) quanto à **cálculos de contribuição angular**.

- Controladores com **Ação Derivativa**:  
  - [Ação Derivativa](Acao_Derivativa.html) (Derivador Puro? Simulações, cuidados e atenção).
  - [Ação Derivativa na presença de sinal ruidoso](Exemplo_ruido_acao_derivativa/circuito_derivativo.html) (11/11/2022).
  - [Teoria à respeito de Compensador por Avanço de Fase (Lead)](Teoria_PD_Lead/acoes_derivativas.html) (Aula de 02/06/2021)  
  - [Projeto de PD](aula_PD_03out2019.html) (Aula de 03/10/2019; Uso de Contribuição angular)
  - [Projeto de Controladores PD](control2inf_2020_2/aula_07112022.html) (Aula de 07/11/2022; estudo de múltiplos casos para posição do zero + projeto do PD usando contribuição angular);
  - [Projeto de Compensador por Avanço de Fase (Lead)](projeto_Lead/exemplo_lead.html) (Aula de 09/06/2021)
  - [Projeto de Compensadores Lead](control2inf_2020_2/aula_21_11_2022.html) (Aula de 21/11/2022)

- [Projeto de PID](PID/examplo_9_5_PID.html) (*example_9_5* de [**NISE**, Norman S. **Control Systems Engineering**](https://bcs.wiley.com/he-bcs/Books?action=index&itemId=1118170512&bcsId=9295)).

- [Projeto de Lead-Lag](Aula_28_05_2019_lead_lag.html) (Aula de 28/05/2019)

- [Outros exemplos de projetos de controladores usando RL](exercicios/exercicios.html) (exercícios aleatórios).

- [Sintonia de PID](8_Ajuste_PID/Sintonia_PIDs_usando_ZN.html) (usando Ziegler-Nichols e Método do Relé)

## 6) Projeto de Controladores no Domínio Frequência

- [Projeto de Controlador Proporcional (Ajuste de Ganho)](projeto_bode_01.html);
- [Projeto de Controlador por Atraso de Fase (Lag)](lag_bode.html);
- [Projeto de Controlador por Avanço de Fase (Lead)](lead_bode.html);
- Projeto de Compensador Lead-Lag

## Trabalhos

* :boom: [Turma de 2023/1](trabalho_2023_1/trabalho_2023_1.html) 

## :speech_balloon: Anexos

- [Como obter gráficos de $u(t)$ e $e(t)$](Acoes_Controle_Erro/acoes_controle_erro.html) na linha de comandos do Matlab.
- [Uso do MATLAB nas aulas de Controle + documentação **Markdown**](sugestao_uso_matlab_em_controle.html);

------

<font size="1">[:musical_note:](https://soundcloud.com/paolitachan/paul-mccartney-wings-live-and) Prof. Fernando Passold</font>

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
<font size="1">
document.writeln ("Last updated: " + LastUpdated);
</font>
// End Hiding -->
</script>