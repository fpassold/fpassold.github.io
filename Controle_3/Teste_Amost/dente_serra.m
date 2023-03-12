% Gera dente de serra
% Fernando Passold, em 11/03/2023

clear t y % limpa estas variaveis da memória

disp('Gerador de Dente de Serra')

n = input('Qtdade de termos desejados   (n=)  ? ');
f = input('Freq. desejada para a onda (f= Hz) ? ');

T=1/f;
t_final=2*T; % periodo de tempo para 2 ciclos do sinal

t=0:T/100:t_final; % cria vetor tempo.

nn = 1:n; % termos
A=(1/pi)*(1./nn); % amplitude de cada termo isolado

index = 0; % indice para cada termo calculado de y=f(t)
num_termos = length(t); % tamanho do vetor t

while index < num_termos
  index = index + 1; % instante tempo atual == t(index)
  % lembrar que matlab inicia indices vetores em 1 
  % Calculando amplitudes em cada instante de tempo
  sum = 0;
  for k=1:n % calculando composição dos n-termos
    sum = sum + A(k)*sin( (2*k*pi*t(index))/T );
  end
  y(index) = 1/2 - sum;
end

figure; % abre nova janela gráfica
plot(t,y)
y_max=1.1*max(y);
aux=num2str(f);
titulo=['Dente de Serra ' aux ' (Hz)'];
title(titulo)
xlabel('tempo (s)')
ylabel('Amplitude (Volts)')

figure; % novo gráfico com espectro do sinal
nn=f*nn; % termos em Hz
stem(nn,A);
axis([0 (n+1)*f 0 y_max])
title('Espectro parcial')
xlabel('Freq. (Hz)')
ylabel('Amplitude (Vp)')
aux=num2str([nn' A']);
[lin,col]=size(aux);
% matlab deixa 4 espacos em branco entre nn e A
%     1234
msg='f    A(f)';
% então falta completar string com m espacos
u=length(msg);
m=col-u;
for k=1:m
  msg=[msg ' ']; % agregando espaco extra faltante
end
% acrescentando um "divisor" na tabela
msg2='-'; % traço divisor
for k=1:col-1
  msg2=[msg2 '-'];
end
% colunas_size(msg) == colunas_size(aux)
aux=[msg; msg2; aux];
text(0.7*n*f,0.7,aux)