% circuito_RC_cargas.m
% Circuito RC pasa-baixa
% Variando carga e aplicanco degrau

pkg load control

s = tf('s');

R = 1e3;
C = 1e-6;

RL1 = 1e6;
RL2 = 10e3;
RL3 = 1e3;

H1 = RL1 / (R + RL1 + s*R*RL1*C);
H2 = RL2 / (R + RL2 + s*R*RL2*C);
H3 = RL3 / (R + RL3 + s*R*RL3*C);

figure;

step(5*H1, 5*H2, 5*H3, 0.005);
% hold on;
% step(5*H2, 0.005);
% step(5*H3, 0.005);

grid on;

legend('RL = 1 Mohm', ...
       'RL = 10 kohm', ...
       'RL = 1 kohm', ...
       'location', 'southeast');

xlabel('Tempo (s)');
ylabel('Vout (V)');

title('Efeito da carga resistiva na resposta ao degrau');
