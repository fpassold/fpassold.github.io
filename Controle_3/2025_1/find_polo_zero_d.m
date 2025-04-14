% find_polo_zero_d.m
% 
% Rotina de contribuicao angular para descobrir onde
% localizar polo ou zero dependendo do local desejado para
% os polos de MF - no plano-z (controle digital)
%
% Uso:
%    Esta rotina ja' espera uma tf de nome "ftma_aux"
% onde: ftma_aux(z)=C(z)*BoG(z);
% e onde: C(z) esta' parcialmente fornecido, ou ja' contendo
% zero(s) ou ja' contendo polo(s)
% 
% A rotina pergunta durante a execucao se a ideia e'
% determinar o local de um zero ou de um polo do controlador.
%
% Fernando Passold, em 14/10/2020, 20/10/2020

A = exist('ftma_aux');
if A ~= 1
    disp('Erro: a variavel tf `ftma_aux` nao existe!');
    return
end
A = exist('T');
if A ~= 1
    disp('Erro: a variavel `T` (periodo de amostragem) nao foi definida!');
    return
end

%% determinando a posicao desejada para o polo no plano-s
OS=input('Overshoot desejado (em %): ? ');
zeta = (-log(OS/100))/(sqrt(pi^2 + (log(OS/100)^2)));
ts_d=input('ts_d (settling time desejado): ? ');
wn = 4 / (zeta*ts_d);
wd = wn*sqrt(1-zeta^2);
sigma = wn*zeta;
clear x y
x(1) = -sigma; y(1) = wd;
x(2) = -sigma; y(2)= -wd;
polos_mf_s=complex(x, y);   % Estes polos ainda estao no plano-s
% Aplicando definicao da transformada-Z: z=e^{s*T}
polos_mf_z=exp(polos_mf_s*T);
sigma=real(polos_mf_z(1)); % novo valor no plano-z
wd=imag(polos_mf_z(1)); % ovo valor no plano-z
fprintf('Polos (desejados) de MF em:\n  $z = %g \\pm j%g$ (ou $%.2f \\angle \\pm %.2f^o$)\n', ...
    sigma, wd, abs(polos_mf_z(1)), angle(polos_mf_z(1))*180/pi )
% Note o valor negativo usado para signma em polos_mf

%% Desenhando RL mostrando contribuicao angular
f=figure(); % abre nova figura;
pzmap(ftma_aux);
hold on;
plot(polos_mf_z, 'rs', 'MarkerSize', 8);
% Acrescenta texto info p??los MF
aux1=num2str(sigma,'%4.2f');
aux2=num2str(wd,'%4.2f');
aux=[aux1 '+j' aux2];
text( real(polos_mf_z(1)), imag(polos_mf_z(1)), aux);
% Acrescentando circulo unitário no plano-z:
cont=0;
for a=0:(5*pi/180):2*pi,    % varendo angulo de 0 à 360 graus
    cont=cont+1;
    x(cont)=cos(a); y(cont)=sin(a);
end
plot(x,y, 'k:')
title('Contribuicoes angulares')
axis equal


%% Calculando os angulos
% Calculando angulos para os polos
Sum_th_p=0;
polo=pole(ftma_aux);
polos=length(polo); % descobre qtdade de polos
clear th_p % limpa vetores de angulos de polos
disp('Calculando angulos dos polos:')
for i=1:polos
    % destaca polo no pzmap
    plot( real(polo(i)), imag(polo(i)), 'bx', ...
        'MarkerSize', 14);
    % calculos
    delta_x = sigma -real(polo(i));
    th_p(i) = atan2(wd - imag(polo(i)), delta_x);
    Sum_th_p = Sum_th_p + th_p(i);
    aux = th_p(i)*180/pi;
    fprintf('  Polo %i em $z= %g$ ', i, real(polo(i)));
    if isreal(polo(i))~=1
        fprintf(' %gj ', imag(polo(i))); 
    end
    fprintf('--> angulo: $%.2f^o$\n', aux);
    % mostrando ??ngulo na figura com pzmap
    xini = real(polo(i)); yini = imag(polo(i));
    xfim = sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'b--', ...
        'LineWidth', 1);
    aux2 = num2str(aux,'%.2f');
    aux2 = [aux2 '^o'];
    text( xini, yini, aux2);
end
fprintf('Soma angular dos polos: $%.2f^o$\n\n', Sum_th_p*180/pi);

% Calculando angulos para os zeros
Sum_th_z=0;
zzero=zero(ftma_aux);
zeros=length(zzero); % descobre qtdade de zeros
clear th_z % limpa vetores de angulos de zeros
disp('Calculando angulos dos zeros:')
for i=1:zeros
    % destaca zero no pzmap
    plot( real(zzero(i)), imag(zzero(i)), 'mo', ...
        'MarkerSize', 14);
    delta_x = sigma -real(zzero(i));
    th_z(i) = atan2(wd - imag(zzero(i)), delta_x);
    Sum_th_z = Sum_th_z + th_z(i);
    aux = th_z(i)*180/pi;
    fprintf('  Zero %i em $z=%g$ ', i, real(zzero(i)));
    if isreal(zzero(i))~=1
        fprintf(' %gj ', imag(zzero(i))); 
    end    
    fprintf(' --> angulo: $%.2f^o$\n', aux);
    % mostrando angulo na figura com pzmap
    xini = real(zzero(i)); yini = imag(zzero(i));
    xfim = sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'm--', ...
         'LineWidth', 1);
    aux2 = num2str(aux,'%.2f');
    aux2 = [aux2 '^o'];
    text( xini, yini, aux2);    
end
fprintf('Soma angular dos zeros: $%.2f^o$\n\n', Sum_th_z*180/pi);

%% Lembrando da lei da contribuicao angular:
% angle(N(s)/D(s)) = +/- r*180^o, r = 1, 3, 5, ...
% ou seja:
% angle(N(s)/D(s)) = +/- 180^o (pi) ou
% angle(N(s)/D(s)) = +/- 540^o (3*pi)...

% calculando melhor axis() para o pzmap
% xmin=min(real(polo))*1.1;
% xmax=-max(real(polo))*1.1;
% ymin=-wd*1.2;
% ymax=wd*1.2;
% axis([xmin xmax ymin ymax])

%% Determinando localizacao do polo ou zero do controlador
escolha='n'; % string vazia;
while ((escolha ~= 'z')&(escolha ~= 'p'))
    escolha = input('Determinar: [p]=polo ou [z]=zero do controlador: ? ', 's');
    escolha = lower(escolha);
end

% falta=tf(1,1);

if escolha == 'z'
    % Angle(N(s)/D(s)) = pi
    % Sum_th_z + th_zero - Sum_th_p = pi
    % th_zero = pi - Sum_th_z + Sum_th_p
    th_zero = pi - Sum_th_z + Sum_th_p;
    aux = th_zero*180/pi;
    while aux > 360
        aux = aux - 360;
    end
    while aux < -360
        aux = aux + 360;
    end
    fprintf('\nAngulo requerido para zero do controlador: $%.2f^o$\n', aux);
    delta_x = wd/tan(th_zero);
    zero_c = sigma - delta_x;
    fprintf('O zero do controlador deve estar em:\n`zero_c` em $z = %g$\n', ...
        zero_c)
    % plotando no pzmap anterior
    xini = zero_c; yini = 0;
    xfim = sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'ro--', ...
        'MarkerSize', 8, 'LineWidth', 2);
    falta=tf([1 -zero_c], 1, T);
    % Acrescentando texto do angulo
    aux = num2str(aux,'%.2f');
    aux = [aux '^o'];
    text( zero_c, 0.01*wd, aux)
    title('Contribuicoes angulares')
end

if escolha == 'p'
    % Angle(N(s)/D(s)) = pi
    % Sum_th_z - (Sum_th_p + th_polo) = pi
    % Sum_th_z - Sum_th_p - th_polo = pi
    % Sum_th_z - Sum_th_p - pi = th_polo
    th_polo = Sum_th_z - Sum_th_p - pi;
    aux = th_polo*180/pi;
    while aux > 360
        aux = aux - 360;
    end
    while aux < -360
        aux = aux + 360;
    end
    fprintf('\nAngulo requerido para polo do controlador: $%.2f^o$\n', aux);
    delta_x = wd/tan(th_polo);
    polo_c = sigma - delta_x;
    fprintf('O polo do controlador deve estar em:\n`polo_c` em $z = %g$\n', ...
        polo_c)
    % plotando no pzmap anterior
    xini = polo_c; yini = 0;
    xfim = sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'rx--', ...
        'MarkerSize', 8, 'LineWidth', 2);
    falta=tf(1, [1 -polo_c], T);
    % Acrescentando texto do angulo
    aux = num2str(aux,'%.2f');
    aux = [aux '^o'];
    text( polo_c, 0.01*wd, aux)
    title('Contribuicoes angulares')
end

%% Comprovando resultado final
ftma=falta*ftma_aux;
figure;
rlocus(ftma);
hold on;
sgrid(zeta,0);
plot(polos_mf_z, 'rs')

fprintf('\nEq. da ftma(z) com controlador --> `ftma`:')
zpk(ftma)
