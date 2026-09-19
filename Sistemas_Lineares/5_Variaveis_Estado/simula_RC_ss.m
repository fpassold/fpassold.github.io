% simula_RC_ss.m
% Simula RC passa-baixa
% Usando equações do espaço de estado
% E aproximação de Euler
R = 10E3; % 10 KΩ
C = 100E-6; % 100 µF
tau = R*C;        % constante de tempo do sistema
ts = 4*tau        % tempo de assentamento previsto

Ts = 0.1;
ts=5*tau;         % tempo final da simulação (regime permanente)
t_fim=ts*(1+1/5)  % inclui parte inicial do degrau propositalemente

t=0:Ts:t_fim;     % cria vetor t, incremento Ts
pts=length(t);    % qtade de pontos gerados

% cria vetor de tensão de entrada
u=zeros(1,pts);               % inicialmente zerado
u(1,round(pts/5)-1:pts)=5;    % a partir de (1/5)*pts vale o degrau

% matrizes do espaço de estados (aproximação discreta)
A = -1/(R*C)
B = 1/(R*C)
C = 1
D = 0

x = zeros(1,pts);
size(x)
for k=1:pts-1
  dx = A*x(k) + B*u(k);       % Eq. Espaço de Estados
  x(k+1) = x(k) + Ts*dx;      % derivada aproximada (Euler)
end

figure
plot(t,u,'m--', t,x,'bo-')
xlim([0 t_fim])
ylim([0 5.2])
xlabel('Tempo (s)')
ylabel('Tensão (V)')
legend('u(k)', 'x(k)', 'Location', 'southeast');
title('Resposta de Circuito RC')
grid
