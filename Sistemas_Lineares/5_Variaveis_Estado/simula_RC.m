% simula_RC.m
% Simula circuito RC passa-baixas usando
% espaço de estados
% Não esquecer:
% >> pkg load control

R = 10E3; % 10 KΩ
C = 100E-6; % 100 µF
tau = R*C; % constante de tempo do sistema
ts = 4*tau % tempo de assentamento previsto

A = -1/(R*C);
B = 1/(R*C);
C = 1;
D = 0;
G = ss(A,B,C,D);

step(G)
grid on
legend off
xlabel('Tempo (s)')
ylabel('v_c(t)')
stepinfo(G)
xlim([0 5*tau])
