% mostra_bode.m
% Fernando Passold, em 16/08/2026

clear;
close all;

R = 1e3;
C = 1e-6;

disp("Constante de tempo do circuito:")
tau = R*C
disp("Frequência de corte do circuito:")
fc = 1/(2*pi*tau)

disp("Função transferência do circuito:")
% H(s) = 1/(R*C*s + 1);
num = 1;           % numerador de H(s)
den = [R*C 1];     % denominador de H(s)
H = tf(num, den)   % cria a função transferência no plano-s
disp('ou:')
zpk(H)

disp("Segue gráfico do Diagrama de Bode")
figure;
bode(H)

%%%% Octave não permite especifica frequência em Hz na função bode()

% Obtém a resposta em frequência em rad/s
[mag, phase, w] = bode(H);
% O comando [mag, phase, w] = bode(sys) retorna as variáveis
% mag (magnitude) e phase (fase) como arrays de 3 dimensões (3D).
% - Dimensão 1: Número de saídas (1)
% - Dimensão 2: Número de entradas (1)
% - Dimensão 3: Quantidade de pontos de frequência gerados (ex: 500)

% Converte rad/s para Hz e a magnitude para dB
f = w / (2 * pi);
mag_db = 20 * log10(squeeze(mag));
phase_deg = squeeze(phase);
% A função `squeeze` reduz a dimensão de matrizes.
% Se você tentar plotar o vetor diretamente usando
% semilogx(f, mag), o Octave gerará um erro.
% Ele não aceita uma matriz de tamanho [1, 1, 500]
% para gerar um gráfico 2D comum.

figure; % Nova janela gráfica
% Plota o diagrama de Magnitude em Hz
subplot(2, 1, 1);
semilogx(f, mag_db, 'LineWidth', 1.5);
grid on;
title('Diagrama de Bode em Hz');
ylabel('Magnitude (dB)');

% Plota o diagrama de Fase em Hz
subplot(2, 1, 2);
semilogx(f, phase_deg, 'LineWidth', 1.5);
grid on;
xlabel('Frequência (Hz)');
ylabel('Fase (graus)');

% Destacando nos gráficos os pontos na freq de corte
% Note: s --> j*w,  w = 2*pi*f
wc = 2*pi*fc;               % Freq de corte em rad/s
s = 1i*wc;                  % define s como número completo jw
% H(s) = 1/(R*C*s + 1);
disp("Ganho absoluto na freq. de corte:");
H_fc = 1/(tau*s + 1);       % resulta um número complexo
G = abs( H_fc )
disp("Ganho em dB na freq. de corte:")
G_dB = 20*log10(G)
disp("Defasagem na freq. de corte:")
ph = angle( H_fc )*180/pi   % retorna valor em graus
subplot(2, 1, 1);
hold on                     % sobrepor no gráfico anterior
plot(fc, G_dB, 'om');
subplot(2, 1, 2);
hold on
plot(fc, ph, 'om')

