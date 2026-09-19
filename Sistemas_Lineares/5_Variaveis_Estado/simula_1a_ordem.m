% simula_1a_ordem.m
% Simulando discretamente sistema 1a-ordem
Ts = 0.01; % incremento de tempo usado
K = 1; % ganho DC do sistema
tau = 0.5; % cte de tempo do sistema
N = 500; % simulando 500 amostras
y = zeros(1,N); % inicializando saída com zeros
u = ones(1,N); % simulando entrada degrau
for k=1:N-1
  dy=(-y(k) + K*u(k))/tau;
  y(k+1)=y(k)+Ts*dy;
end
t = (0:N-1)*Ts; % construindo vetor tempo em segundos
plot(t,y,'b-')
grid on
xlabel('Tempo(s)')
ylabel('y(t)')

