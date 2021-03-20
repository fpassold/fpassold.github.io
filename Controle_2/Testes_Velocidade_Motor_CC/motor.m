% Modelagem motor
% Fernando Passold, em 31/08/2020
%
% Ref.Bib.: 
% Sobre a modelagem & simulink
% (1) DC Motor Speed: Simulink Modeling,
% http://ctms.engin.umich.edu/CTMS/index.php?example=MotorSpeed&section=SimulinkModeling
% (acessado em 31/08/2020)
% Para testes
% (2) DC Motor Speed: Simulink Controller Design,
% http://ctms.engin.umich.edu/CTMS/index.php?example=MotorSpeed&section=SimulinkControl
% (acessado em 31/08/2020)

J=0.01;  % Kg.m^2 - momento de inercia do rotor
b=0.1;   % N.m.s - constante de atrito viscoso do motor
Ke=0.01; % V/rad/sec - constante de força eletromotiva
Kt=0.01; % N.m/Amp - constante de torque do motor
R=1;     % Ohm - Resistencia de Armadura, Ra (Ohms)
L=0.5;   % H - Indutância elétrica

% Outros valores baseados em:
% Resultados copiados diretamente do programa: Ref.: 2007_KitExperimentalParaIdentificaçãoDeMotoresCC_TG_MarcoAntônioDaSilva.pdf
% Perda de Tensao nas Escovas-Vb (V):2.44 
% Corrente de Regime-Ia (A):1.017
% tau_e =  2E-6; % Constante de Tempo Eletrica-TauE (us):002 Indutancia de Armadura-La (uH):6.60
% tau_m = 0.124; % Constante de Tempo Mecanica (ms):124
% Corrente de Eixo Livre (A):0.158
% Velocidade de Eixo Livre (RPM):840
% Resistencia Mecanica de Movimento-Rh (Ohms):59.1 
% Constante do Motor (N*m/A):0.107

