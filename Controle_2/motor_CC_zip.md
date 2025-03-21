# "Motor_CC.zip"

Arquivos SLX para Simulações de ações de controle de velocidade do motor CC (para uso com Matlab/Simulink) + imagens e HTML em formato Zipado em:  [Motor_CC.zip](2_acoes/Motor_CC.zip) (5 MB).

**Conteúdo do arquivo *.zip:**


```bash
Downloads % unzip -l Motor_CC.zip
Archive:  Motor_CC.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  08-02-2023 17:07   Motor_CC/
   532911  08-31-2020 16:00   Motor_CC/Armature Controlled DC Motor - Wikipedia.pdf
   616785  08-31-2020 17:40   Motor_CC/Control Tutorials for MATLAB and Simulink - Motor Speed: Simulink Control.pdf
   496414  08-31-2020 17:39   Motor_CC/Control Tutorials for MATLAB and Simulink - Motor Speed: Simulink Modeling.pdf
   672037  08-31-2020 15:53   Motor_CC/Creating a High-Fidelity Model of an Electric Motor for Control System Design and Verification - MATLAB & Simulink.pdf
   196291  08-31-2020 15:52   Motor_CC/DC Motor Model.pdf
   148642  09-01-2020 22:34   Motor_CC/modelagem_motor_cc.html
    11871  09-01-2020 22:34   Motor_CC/modelagem_motor_cc.md
  1456599  09-01-2020 22:34   Motor_CC/modelagem_motor_cc.pdf
    32883  08-31-2020 17:21   Motor_CC/monitoracao_motor_cont_Prop.png
    22922  08-31-2020 17:31   Motor_CC/monitoramento_cont_PD.png
    27987  08-31-2020 17:27   Motor_CC/monitoramento_cont_PI.png
    34142  08-31-2020 17:35   Motor_CC/Motor_CC_Velocidade-modelo_interno.pdf
   154191  08-31-2020 18:55   Motor_CC/Motor_CC_Velocidade-modelo_interno.png
    23847  08-31-2020 17:33   Motor_CC/motor_cc_velocidade-subsistema.pdf
    52161  08-31-2020 18:56   Motor_CC/motor_cc_velocidade-subsistema.png
    38708  08-31-2020 17:28   Motor_CC/motor_cc_velocidade_cont_PD.pdf
   131721  08-31-2020 19:20   Motor_CC/motor_cc_velocidade_cont_PD.png
    37639  08-31-2020 17:23   Motor_CC/motor_cc_velocidade_cont_PI.pdf
    43061  08-31-2020 19:25   Motor_CC/motor_cc_velocidade_cont_PID.pdf
   194239  08-31-2020 19:25   Motor_CC/motor_cc_velocidade_cont_PID.png
    34534  08-31-2020 17:17   Motor_CC/motor_cc_velocidade_cont_Prop.pdf
   129720  08-31-2020 19:06   Motor_CC/motor_cc_velocidade_cont_Prop.png
    28247  08-31-2020 17:16   Motor_CC/motor_cc_velocidade_teste_MA.pdf
    71860  08-31-2020 18:59   Motor_CC/motor_cc_velocidade_teste_MA.png
    15737  08-31-2020 17:47   Motor_CC/motor_phisic_setup.png
    31648  08-31-2020 18:05   Motor_CC/Picture1.png
    34539  08-31-2020 18:15   Motor_CC/Picture2.png
    36338  08-31-2020 18:19   Motor_CC/Picture3.png
    39880  08-31-2020 18:49   Motor_CC/Picture4.png
    30494  08-31-2020 18:51   Motor_CC/Picture44.png
    35633  08-31-2020 17:11   Motor_CC/resposta_PID.png
    25237  08-31-2020 17:30   Motor_CC/resultado_cont_PD.png
    30466  08-31-2020 17:24   Motor_CC/resultado_cont_PI.png
    33204  08-31-2020 17:19   Motor_CC/resultado_cont_Prop.png
    40831  08-31-2020 17:15   Motor_CC/resultado_MA.png
        0  08-02-2023 17:07   Motor_CC/Simulink/
    23960  08-31-2020 17:35   Motor_CC/Simulink/motor_cc_velocidade.slx
    23849  08-31-2020 17:32   Motor_CC/Simulink/motor_cc_velocidade_cont_PD.slx
    23722  08-31-2020 17:27   Motor_CC/Simulink/motor_cc_velocidade_cont_PI.slx
    24127  08-31-2020 17:12   Motor_CC/Simulink/motor_cc_velocidade_cont_PID.slx
    23685  08-31-2020 17:22   Motor_CC/Simulink/motor_cc_velocidade_cont_Prop.slx
    23048  08-31-2020 17:15   Motor_CC/Simulink/motor_cc_velocidade_teste_MA.slx
---------                     -------
  5685810                     43 files
```

**Instruções de uso:**

* Baixar apenas o arquivo Motor_CC.zio (quase 5 Mbytes);
* Depois descompactar arquivo Motor_CC.zip. 
* Serão gerados vários arquivos a partir da pasta "\Motor_CC"; 
* Nesta pasta busque pelo arquivo "modelagem_motor_cc.html". Abra este arquivo no seu browser preferido. 
* É criando ainda um subdiretório à partir da pasta anterior: \Motor_CC\Simulink", contendo todos os arquivos SLX (diagramas de blocos para Matlab/Simulink). Indique este "path" no Matlab para pode acessar estes arquivos.
* **Obs.:** Executar script `motor.m` ANTES de rodar rotinas SLX do Simulink. Senão Simulink será paralizado com mensagem de erro questionando sobre variáveis desconhecidas). Na janela de console (comandos) do Matlab, basta digitar: `>> motor`.

