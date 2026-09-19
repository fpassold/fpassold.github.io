% Simula aproximação circuito RC passa-baixa
% como filtro diital de 1a-ordem

format shortg % imprime só casas decimais necessárias

R=10E3;
C=100E-6;
Ts=0.1; % periodo de amostragem, incremento de tempo

tau=1/(R*C) % constante de tempo
ts=5*tau % tempo final da simulação (regime permanente)
t_fim=ts*(1+1/5) % inclui parte inicial do degrau propositalemente
% nulo (1/5 do ts).

alpha=Ts/(R*C)

t=0:Ts:t_fim; % cria vetor t, incremento Ts
pts=length(t); % qtade de pontos gerados
kk=0:pts-1; % vetor que simula o "k"

% cria vetor de tensão de entrada
u=zeros(1,pts); % inicialmente zerado
u(1,round(pts/5)-1:pts)=5; % a partir de (1/5)*pts vale o degrau

x(1)=0; % equivale à x(0); Octave/Matlab iniciam índices em zero
for k=1:pts-1
  x(k+1) = (1-alpha)*x(k)+alpha*u(k);
end

% gera "tabela" na tela
disp('            k            t            u            x')
disp([kk' t' u' x'])

figure
plot(t,u,'m--', t,x,'bo-')
xlim([0 t_fim])
ylim([0 5.2])
xlabel('Tempo (s)')
ylabel('Tensão (V)')
legend('u(k)', 'x(k)', 'Location', 'southeast');
title('Resposta de Circuito RC')
grid
