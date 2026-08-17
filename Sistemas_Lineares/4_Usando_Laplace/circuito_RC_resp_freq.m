% Circuito RC
% Curva de Resposta em Frequência
% Fernando Passold, em 12/08/2026

clear;
close all;
disp('Resposta em Freq. de circuito RC')

R = 1e3;
C = 1e-6;

disp('Constante de tempo do circuito:')
tau = R*C
disp('Frequência de corte (rad/s):')
wc=1/(R*C)
disp('Frequência de corte (Hz):')
fc = 1/(2*pi*tau)

Vm = 5;	% tensão de pico da senoide de entrada

f = logspace(0, 4, 400); % varia freq. de forma logaritmica entre 10^0 até 10^4 (em Hz), 400 pontos.

w = 2*pi*f;	% calcula em rad/s

H = 1 ./ (1 + 1i*w*R*C);	% calcula H(jw)

% Obs.: note que jw resulta um número complexo, assim H(jw) = número complexo

magnitude = abs(H);		% determina o módulo de H(jw)
fase = angle(H)*180/pi;	% determina a fase do número complexo h(jw)

figure;
semilogx(f, 20*log10(magnitude), 'LineWidth', 1.5);
grid on;

xlabel('Frequência (Hz)');
ylabel('|H(f)| (dB)');
title('Magnitude da resposta em frequência do circuito RC');
