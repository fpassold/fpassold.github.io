% resposta_mag_freq.m
% Traça gráfico da resposta de magnitude (ganho) vs frequencia
% Fernando Passold, em 22/09/2026

R1 = 10E3;
R2 = 10E3;
C = 0.1E-6;

fc = 1/(2*pi*R1*C)

f = logspace(0, 4, 100);

w = 2*pi*f;
wc = 2*pi*fc
K=R2/R1;

s = 1i*w; % s --> jw
H = (-K*(s)./(s + wc));
% Hc = 1 ./ (1 + 1i*wc*R*C);  % H(f) na freq de corte
Hc = (-K*1i*wc)./(1i*wc + wc);  % H(f) na freq de corte

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
