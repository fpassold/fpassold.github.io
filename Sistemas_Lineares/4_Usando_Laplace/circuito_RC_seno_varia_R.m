% circuito_RC_seno_varia_R.m
% Simula entrada senoidal num circuito RC passa-baixa
% variando o R

pkg load control

R1 = 100;
R2 = 1e3;
R3 = 10e3;
C = 1e-6;

s = tf('s');

H1 = 1/(R1*C*s + 1);
H2 = 1/(R2*C*s + 1);
H3 = 1/(R3*C*s + 1);

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
msg=num2str(R1);
title(['Circuito RC | Senoide: 500 Hz, R=', num2str(R1), ' Ω']);

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
msg=num2str(R1);
title(['Circuito RC | Senoide: 500 Hz, R=', num2str(R2), ' Ω']);

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
msg=num2str(R1);
title(['Circuito RC | Senoide: 500 Hz, R=', num2str(R3), ' Ω']);
