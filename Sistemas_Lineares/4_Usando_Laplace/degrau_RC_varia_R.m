% degrau_RC_varia_R.m
% Simples simulação degrau circuito RC
% variando valores de R

pkg load control

s = tf('s');

C = 1e-6;

R1 = 1e3;
R2 = 10e3;
R3 = 100e3;

H1 = 1/(R1*C*s + 1);
H2 = 1/(R2*C*s + 1);
H3 = 1/(R3*C*s + 1);

figure; % abre nova janela gráfica
step(5*H1, 5*H2, 5*H3, 0.5);
grid on;
legend('1 kOhm','10 kOhm','100 kOhm', "location", "southeast");
xlabel('Tempo (s)');
ylabel('Vout (V)');

