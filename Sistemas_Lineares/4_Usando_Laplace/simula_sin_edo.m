# Simula saída de uma senoide na entrada de um circuito RC (filtro passa-baixas)
# Fernando Passold, em 12/08/2026

clear;			% limpa dados anteriores
close all;     	% fecha janelas gráficas (se houver)
clc;		    % limpa tela de comandos

R = 1e3;
C = 1e-6;
disp('Constante de tempo do sistema:')
tau = R*C		% contante de tempo do sistema

Vm = 5;
f = 100;
disp('Frequência angular da senóide:')
w = 2*pi*f

# Levantando alguns dados da onda para facilitar análise
disp('Periodo da onda senoidal:')
T = 1/f # período da onda senoidal
disp('Duração da simulação:')
t_fim = 2*T   		# vamos simular 2 ciclos da onda

t = 0:1e-5:t_fim;   # cria vetor tempo t com incremento de 1x10^{-5} = 10 ns

Vin = Vm*sin(w*t);	# cria vetor de entrada (simula a senóide)

% Solucao completa, considerando Vout(0) = 0
K  = Vm*R*C*w/(1+(R*C*w)^2);
y1 = K*exp(-t/tau); 								% vetor apenas do período transitório
y2 = Vm/sqrt(1+(R*C*w)^2).* sin(w*t - atan(R*C*w)); % vetor/saida regime permanente

Vout = y1 + y2; 	% compondo regime transitório, y1 + regime permanente, y2.

plot(t, Vin, 'b',  'LineWidth', 1.5);
hold on;
plot(t, Vout, 'r',  'LineWidth', 1.5);

% Plotando as curvas auxiliares
plot(t, y1,   'b--', 'LineWidth', 1.5);
plot(t, y2,   'm:',  'LineWidth', 1.5);
grid on;

xlabel('Tempo (s)');
ylabel('Tensão (V)');
legend('V_{in}', 'V_{out}', 'y_1(t)', 'y_2(t)');
title('Circuito RC - entrada senoidal');
