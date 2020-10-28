% find_polo_zero.m
% 
% Rotina de contribuição angular para descobrir onde
% localizar pólo ou zero dependendo do local desejado para
% os pólos de MF
%
% Uso:
%    Esta rotina já espera uma tf de nome "ftma_aux"
% onde: ftma_aux(s)=C(s)*G(s);
% e onde: C(s) está parcialmente fornecido, ou já contendo
% zero(s) ou já contendo pólo(s)
% 
% A rotina pergunta durante a execução se a idéia é
% determinar o local de um zero ou de um pólo
%
% Fernando Passold, em 14/10/2020

A = exist ftma_aux;
if A ~= 1
    disp('Erro: a tf "ftma_aux" não existe!');
    return
end

%% determinando a posição desejada para o pólo no plano-s
OS=input('Overshoot desejado (em %): ? ');
zeta = (-log(OS/100))/(sqrt(pi^2 + (log(OS/100)^2)));
ts_d=input('ts_d (desired settling time): ? ');
wn = 4 / (zeta*ts_d);
wd = wn*sqrt(1-zeta^2);
sigma = wn*zeta;
polos_mf=[-sigma+i*wd -sigma-i*wd]

% Note o valor negativo usado para signma em polos_mf

%% Desenhando RL mostrando contribuição angular
figure; pzmap(ftma_aux);
hold on;
plot(polos_mf, 'r+')

%% Calculando os ângulos
% Calculando ângulos para os pólos
Sum_th_p=0;
polo=pole(ftma_aux);
polos=length(polo); % descobre qtdade de pólos
clear th_p % limpa vetores de ângulos de pólos
disp('Calculando ângulos dos pólos:')
for i=1:polos
    delta_x = -sigma -polo(i);
    th_p(i) = atan2(wd, delta_x);
    Sum_th_p = Sum_th_p + th_p(i);
    fprintf('Pólo %1 em s=%g --> Ângulo: %g\n', ...
        i, polo(i), th_p(i)*180/pi);
end
fprintf('Soma ângulos dos pólos: %g\n', Sum_th_p);

% Calculando ângulos para os zeros
Sum_th_z=0;
zzero=zero(ftma_aux);
zeros=length(zzero); % descobre qtdade de zeros
clear th_z % limpa vetores de ângulos de zeros
disp('Calculando ângulos dos pólos:')
for i=1:zeros
    delta_x = -sigma -zzero(i);
    th_z(i) = atan2(wd, delta_x);
    Sum_th_z = Sum_th_z + th_z(i);
    fprintf('Zero %1 em s=%g --> Ângulo: %g\n', ...
        i, zzero(i), th_z(i)*180/pi);
end
fprintf('Soma ângulos dos zeros: %g\n', Sum_th_z);
