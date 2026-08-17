% degrau_RC_1.m
% Simples simulação degrau circuito RC

pkg load control

R = 1e3;
C = 1e-6;

s = tf('s');

H = 1/(R*C*s + 1);

step(H);	% aplicação de defrau unitário
grid on;

