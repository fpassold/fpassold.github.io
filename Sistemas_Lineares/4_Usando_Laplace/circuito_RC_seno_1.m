% circuito_RC_seno_1.m
% Simula entrada senoidal num circuito TC passa-baixa

pkg load control

R = 1e3;
C = 1e-6;

s = tf('s');

H = 1/(R*C*s + 1);

f = 100;
Vm = 5;

T = 1/f;          % período da onda senoidal
t_fim = 2.5*T;    % simulando 2,5 periodos da onda
t = 0:1e-5:t_fim;

Vin = Vm*sin(2*pi*f*t);

[Vout, t] = lsim(H, Vin, t);

plot(t, Vin, 'LineWidth', 1.2);
hold on;
plot(t, Vout, 'LineWidth', 1.2);

grid on;

xlabel('Tempo (s)');
ylabel('Tensão (V)');

legend('V_{in}', 'V_{out}', "location", "southeast");

title('Circuito RC - entrada senoidal de 100 Hz');
