% init_motor_velocidade.m
% Inicializada dados para Modelagem motor CC - Velocidade
% Ref.: https://ctms.engin.umich.edu/CTMS/index.php?example=MotorSpeed&section=SystemModeling
disp('Dados Motor CC - Velocidade angular:')
J = 0.01; % momento de inercia do motor
b = 0.1;  % cte atrito viscoso do motor
K = 0.01; % cte força eletromotriz e de torque do motor (unidades S.I.)
R = 1;    % resistência elétrica do motor
L = 0.5;  % indutância elétrica do motor
s = tf('s');
V_motor = K/((J*s+b)*(L*s+R)+K^2)
