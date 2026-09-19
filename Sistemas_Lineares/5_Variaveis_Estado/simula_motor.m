% simula_motor.m
% simula motor-CC no espaço de estados
% Não esquecer antes: > pkg load control
R  = 2;
L  = 0.5;
Ke = 0.1;
Kt = 0.1;
J  = 0.02;
b  = 0.01;

%% Montandos as matrizes
A = [-R/L   -Ke/L;
      Kt/J  -b/J];

B = [1/L;
     0];

C = [0 1];
D = 0;

%% Simulando
sys = ss(A,B,C,D);

step(sys)
grid on
legend off
