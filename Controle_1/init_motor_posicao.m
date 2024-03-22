% init_motor_posicao.m
% Inicializada dados para Modelagem motor CC - posição
% Ref.: https://ctms.engin.umich.edu/CTMS/index.php?example=MotorPosition&section=SystemModeling
disp('Dados Motor CC - Posição angular:')
J = 3.2284E-6; % momento de inercia do motor
b = 3.5077E-6; % cte atrito viscoso do motor
K = 0.0274;    % cte força eletromotriz e de torque do motor (unidades S.I.)
R = 4;         % resistência elétrica do motor
L = 2.75E-6;   % indutância elétrica do motor
s = tf('s');
P_motor = K/(s*((J*s+b)*(L*s+R)+K^2))
