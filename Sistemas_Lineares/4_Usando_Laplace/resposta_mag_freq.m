% resposta_mag_freq.m
% Traça gráfico da resposta de magnitude (ganho) vs frequencia
% Fernando Passold, em 16/08/2026

clear;
close all;

R = 1e3;
C = 1e-6;

fc = 1/(2*pi*R*C);

Vm = 5;

f = logspace(0, 5, 500);

w = 2*pi*f;
wc = 2*pi*fc;

H = 1 ./ (1 + 1i*w*R*C);
Hc = 1 ./ (1 + 1i*wc*R*C);  % H(f) na freq de corte

magnitude = abs(H);
mag_c = abs(Hc);
fase = angle(H)*180/pi;

figure;
semilogx(f, 20*log10(magnitude), 'LineWidth', 1.5);
hold on;
plot(fc, 20*log10(mag_c), "om", 'LineWidth', 1.5); % exibe um marcador em fc
str = num2str(fc);
str = ['f_c = ' str ' (Hz)'];
text(fc*1.2, 20*log10(mag_c)*0.8, str);
grid on;

xlabel('Frequência (Hz)');
ylabel('|H(f)| (dB)');
title('Magnitude da resposta em frequência do circuito RC');
