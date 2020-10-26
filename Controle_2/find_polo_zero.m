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
% Fernando Passold, em 14/10/2020, 20/10/2020

A = exist('ftma_aux');
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
x(1) = -sigma; y(1) = wd;
x(2) = -sigma; y(2)= -wd;
polos_mf=complex(x, y);
fprintf('Pólos (desejados) de MF em: s = %g \\pm j %g\n', ...
    -sigma, wd)

% Note o valor negativo usado para signma em polos_mf

%% Desenhando RL mostrando contribuição angular
f=figure(); % abre nova figura;
pzmap(ftma_aux);
hold on;
plot(polos_mf, 'r+', 'MarkerSize', 14);
% Acrescenta texto info pólos MF
aux1=num2str(-sigma,'%4.2f');
aux2=num2str(wd,'%4.2f');
aux=[aux1 '+j' aux2];
text( real(polos_mf(1)), imag(polos_mf(1)), aux);
% calculando melhor axis() para o pzmap
ymax=1.1*wd;
ymin=-0.1*wd;

%% Calculando os ângulos
% Calculando ângulos para os pólos
Sum_th_p=0;
polo=pole(ftma_aux);
polos=length(polo); % descobre qtdade de pólos
clear th_p % limpa vetores de ângulos de pólos
disp('Calculando ângulos dos Pólos:')
for i=1:polos
    % destaca pólo no pzmap
    plot( real(polo(i)), imag(polo(i)), 'bx', ...
        'MarkerSize', 14);
    % cálculos
    delta_x = -sigma -polo(i);
    th_p(i) = atan2(wd, delta_x);
    Sum_th_p = Sum_th_p + th_p(i);
    aux = th_p(i)*180/pi;
    fprintf('  Pólo %i em s= %g --> Ângulo: %g^o\n', ...
        i, polo(i), aux);
    % mostrando ângulo na figura com pzmap
    xini = polo(i); yini = 0;
    xfim = -sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'b--', ...
        'LineWidth', 1);
    aux2 = num2str(aux,'%6.2f');
    aux2 = [aux2 '^o'];
    text( xini, 0, aux2);
end
fprintf('Soma ângulos dos pólos: %g^o\n\n', Sum_th_p*180/pi);

% Calculando ângulos para os zeros
Sum_th_z=0;
zzero=zero(ftma_aux);
zeros=length(zzero); % descobre qtdade de zeros
clear th_z % limpa vetores de ângulos de zeros
disp('Calculando ângulos dos Zeros:')
for i=1:zeros
    % destaca zero no pzmap
    plot( real(zzero(i)), imag(zzero(i)), 'mo', ...
        'MarkerSize', 14);
    delta_x = -sigma -zzero(i);
    th_z(i) = atan2(wd, delta_x);
    Sum_th_z = Sum_th_z + th_z(i);
    aux = th_z(i)*180/pi;
    fprintf('  Zero %i em s=%g --> Ângulo: %g^o\n', ...
        i, zzero(i), aux);
    % mostrando ângulo na figura com pzmap
    xini = zzero(i); yini = 0;
    xfim = -sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'm--', ...
         'LineWidth', 1);
    aux2 = num2str(aux,'%6.2f');
    aux2 = [aux2 '^o'];
    text( xini, 0, aux2);    
end
fprintf('Soma ângulos dos zeros: %g^o\n\n', Sum_th_z*180/pi);

%% Lembrando da lei da contribuição angular:
% angle(N(s)/D(s)) = +/- r*180^o, r = 1, 3, 5, ...
% ou seja:
% angle(N(s)/D(s)) = +/- 180^o (pi) ou
% angle(N(s)/D(s)) = +/- 540^o (3*pi)...

% calculando melhor axis() para o pzmap
xmin=min(polo);
xmax=max(polo);
axis([xmin xmax ymin ymax])

%% Determinando localização do pólo ou zero do controlador
escolha='n'; % string vazia;
while ((escolha ~= 'z')&(escolha ~= 'p'))
    escolha = input('Determinar: [p]=pólo ou [z]=zero do controlador: ? ', 's');
    escolha = lower(escolha);
end

falta=tf(1,1);

if escolha == 'z'
    % Angle(N(s)/D(s)) = pi
    % Sum_th_z + th_zero - Sum_th_p = pi
    % th_zero = pi - Sum_th_z + Sum_th_p
    th_zero = pi - Sum_th_z + Sum_th_p;
    aux = th_zero*180/pi;
    while aux > 360
        aux = aux - 360;
    end
    fprintf('\nÂngulo do zero do controlador: %g^o\n', aux);
    delta_x = wd/tan(th_zero);
    zero_c = -sigma - delta_x;
    fprintf('O zero do controlador deve estar em s = %g\n', ...
        zero_c)
    % plotando no pzmap anterior
    xini = zero_c; yini = 0;
    xfim = -sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'ro--', ...
        'MarkerSize', 14, 'LineWidth', 2);
    falta=tf([1 -zero_c], 1);
    % Acrescentando texto do ângulo
    aux = num2str(aux,'%4.2f');
    aux = [aux '^o'];
    text( zero_c, 0.01*wd, aux)
end
if escolha == 'p'
    % Angle(N(s)/D(s)) = pi
    % Sum_th_z - (Sum_th_p + th_polo) = pi
    % Sum_th_z - Sum_th_p - th_polo = pi
    % Sum_th_z - Sum_th_p - pi = th_polo
    th_polo = Sum_th_z - Sum_th_p - pi;
    aux = th_zero*180/pi;
    fprintf('\nÂngulo do pólo do controlador: %g^o\n', aux);
    delta_x = wd/tan(th_polo);
    polo_c = -sigma - delta_x;
    fprintf('O pólo do controlador deve estar em s = %g\n', ...
        polo_c)
    % plotando no pzmap anterior
    xini = polo_c; yini = 0;
    xfim = -sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'rx--', ...
        'MarkerSize', 14, 'LineWidth', 2);
    falta=tf(1, [1 -polo_c]);
end

%% Comprovando resultado final
ftma=falta*ftma_aux;
figure;
rlocus(ftma);
hold on;
sgrid(zeta,0);
plot(polos_mf, 'r+')
