% degrau_RC_varia_C.m
% Simples simulação degrau circuito RC
% variando valores de C

pkg load control

s = tf('s');

R = 1e3;

C1 = 100E-9;
C2 = 1E-6;
C3 = 10E-6;

H1 = 1/(R*C1*s + 1);
H2 = 1/(R*C2*s + 1);
H3 = 1/(R*C3*s + 1);

figure; % abre nova janela gráfica
step(5*H1, 5*H2, 5*H3, 0.03);
grid on;
legend('100 nF','1 uF','10 uF', "location", "southeast");
xlabel('Tempo (s)');
ylabel('Vout (V)');

