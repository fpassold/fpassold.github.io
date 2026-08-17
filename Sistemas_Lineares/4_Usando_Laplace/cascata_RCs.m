% cascata_RCs.m
% Simula cascateamento de 2 circuitos RC passa-baixa
% sem e com buffer isolador
% Fernando Passold, em 16/08/2026

pkg load control

s = tf('s');

R1 = 1e3;
C1 = 1e-6;

R2 = 1e3;
C2 = 1e-6;

% Dois RC diretamente conectados
H_casc = 1 / ...
    (1 + s*(R1*C1 + R1*C2 + R2*C2) ...
    + s^2*R1*R2*C1*C2);

% Dois RC isolados por buffer
H_buffer = 1 / ...
    ((1 + s*R1*C1)*(1 + s*R2*C2));


figure;
step(H_casc, H_buffer);
% hold on;
% step(H_buffer);
grid on;
legend('Cascata de RC sem buffer', ...
       'Cascata de RC com buffer', ...
       'location', 'southeast');
title('Respostas ao degrau');

disp("Aperte uma tecla para continuar...")
pause

%% 2a-parte
figure;
bode(H_casc, H_buffer);
% hold on;
% bode(H_buffer);
grid on;
legend('Sem buffer', 'Com buffer', 'location', 'southeast');

disp("Aperte uma tecla para continuar...")
pause

%% 3a-parte
f = 100;
Vm = 5;

T = 1/f; % periodo da senoide
t_fim=2.6*T;
t = 0:1e-5:t_fim;

Vin = Vm*sin(2*pi*f*t);

[Vout1, t] = lsim(H_casc, Vin, t);
[Vout2, t] = lsim(H_buffer, Vin, t);

figure;
plot(t, Vin, 'LineWidth', 1.5);
hold on;
plot(t, Vout1, 'LineWidth', 1.5);
plot(t, Vout2, 'LineWidth', 1.5);
grid on;
xlim([0 t_fim]);
legend('Vin', ...
       'Cascata sem buffer', ...
       'Cascata com buffer', ...
       'location', 'southeast');
xlabel('Tempo (s)');
ylabel('Tensão (V)');
title('Respostas a Senoide, f = 100 Hz');
