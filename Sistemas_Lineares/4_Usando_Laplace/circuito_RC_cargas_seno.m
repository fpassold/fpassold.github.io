% circuito_RC_cargas_seno.m
% Circuito RC pasa-baixa
% Variando carga e aplicanco senoide 100 Hz na entrada

f = 100;
Vm = 5;

T = 1/f;
t_fim = 2.5*T;
t = 0:1e-5:t_fim;

Vin = Vm*sin(2*pi*f*t);

[Vout1, t] = lsim(H1, Vin, t);
[Vout2, t] = lsim(H2, Vin, t);
[Vout3, t] = lsim(H3, Vin, t);

figure;
plot(t,Vin, t, Vout1, t, Vout2, t, Vout3, 'LineWidth', 1.5);

grid on;

xlabel('Tempo (s)');
ylabel('Tensão (V)');

legend('Vin', ...
       'RL = 1 Mohm', ...
       'RL = 10 kohm', ...
       'RL = 1 kohm', ...
       'location', 'southeast');

xlabel('Tempo (s)');
ylabel('Vout (V)');

title('Efeito da carga resistiva na resposta senoidal');
