% circuito_RC_seno_varia_C.m
% Simula entrada senoidal num circuito RC passa-baixa
% variando o C

pkg load control

R = 1e3;
C1 = 100e-9;
C2 = 1e-6;
C3 = 10e-6;

s = tf('s');

H1 = 1/(R*C1*s + 1);
H2 = 1/(R*C2*s + 1);
H3 = 1/(R*C3*s + 1);

f = 500;
Vm = 5;

T = 1/f;          % período da onda senoidal
t_fim = 3.5*T;    % simulando 3,5 periodos da onda
t = 0:1e-5:t_fim;

Vin = Vm*sin(2*pi*f*t);

[Vout, t] = lsim(H1, Vin, t);
plot(t, Vin, 'LineWidth', 1.5);
hold on;
plot(t, Vout, 'LineWidth', 1.5);
grid on;
xlabel('Tempo (s)');
ylabel('Tensão (V)');
legend('V_{in}', 'V_{out}', "location", "southeast");
title(['Circuito RC | Senoide: 500 Hz, C= 100 nF']);

figure;
clear Vout;
[Vout, t] = lsim(H2, Vin, t);
plot(t, Vin, 'LineWidth', 1.5);
hold on;
plot(t, Vout, 'LineWidth', 1.5);
grid on;
xlabel('Tempo (s)');
ylabel('Tensão (V)');
legend('V_{in}', 'V_{out}', "location", "southeast");
title(['Circuito RC | Senoide: 500 Hz, C= 1 µF']);

figure;
clear Vout;
[Vout, t] = lsim(H3, Vin, t);
plot(t, Vin, 'LineWidth', 1.5);
hold on;
plot(t, Vout, 'LineWidth', 1.5);
grid on;
xlabel('Tempo (s)');
ylabel('Tensão (V)');
legend('V_{in}', 'V_{out}', "location", "southeast");
title(['Circuito RC | Senoide: 500 Hz, C= 10 µF']);
