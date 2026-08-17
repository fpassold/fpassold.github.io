% circuito_RC_Laplace_seno1.m
% Simula resposta à senoide
% usando Vout(t) calculado via transformada
% inversa de Laplace
% Solução analítica
% Fernando Passold, em 16/08/2026

clear;
close all;

R = 1e3;
C = 1e-6;

Vm = 5;
f = 100;
w = 2*pi*f;
T = 1/f;
t_fim = 2.5*T;
t = 0:1e-5:t_fim;

Vin = Vm*sin(w*t);

% Solucao completa, considerando Vout(0) = 0
A = Vm*R*C*w/(1+(R*C*w)^2);

V_trans = A*exp(-t/(R*C));

Vout = V_trans ...
     + Vm/sqrt(1+(R*C*w)^2) ...
     .* sin(w*t - atan(R*C*w));

plot(t, Vin, 'LineWidth', 1.5);
hold on;
plot(t, Vout, 'LineWidth', 1.5);
plot(t, V_trans, 'm--', 'LineWidth', 1,2);
xlim([0 t_fim])

grid on;
xlabel('Tempo (s)');
ylabel('Tensão (V)');
legend('V_{in}', 'V_{out}', 'V_{trans}', 'location', 'southeast');
title('Circuito RC - Senoidal, f = 100 Hz');
