% teste_pade1.m
% Sistema original com atraso
% Sistema de 1a-ordem com atraso de 2 segundos, constante de tempo de 1
% minuto
%
% Fernando Passold, em 15/05/2025

s = tf('s');
G = 1 / (60*s + 1) * exp(-2*s);

% Aproxima��o de Pad� de 1� ordem
[num_pade, den_pade] = pade(2, 1);  % Atraso de 2s, ordem 1
Pade1 = tf(num_pade, den_pade);
G_approx1 = 1 / (60*s + 1) * Pade1;

% Aproxima��o de Pad� de 2� ordem
[num_pade2, den_pade2] = pade(2, 2);  % Atraso de 2s, ordem 2
Pade2 = tf(num_pade2, den_pade2);
G_approx2 = 1 / (60*s + 1) * Pade2;

% Simula��o da resposta ao degrau
figure;
step(G, 'r--', G_approx1, 'b', G_approx2, 'g--');
legend('Exato (com atraso)', 'Pad� 1� Ordem', 'Pad� 2� Ordem');
grid on;