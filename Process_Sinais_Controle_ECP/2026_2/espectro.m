function [f, Xmag, X_fase]=espectro(x, fs, N)
% function [f, X_mag, X_fase]=espectro(x, fs, N)
% Gera Gráfico Espectral do sinal x, realizando FFT do sinal X(s)=FFT(x[k])
% Parametros entrada
% x = x[k] = vetor das amostras
% fs = freq. de amostragem original
% N = pontos para a FFT (parâmetro opcional)
%     se nao informado N, usa todos os pontos de x
% Retorna:
% f = vetor de frequencias (em Hz)
% Mag = vetor da Magnitude (valor abs)
% Fase = vetor das Fases
% Fernando Passold, em 05/11/2026

if nargin < 1
    % Nenhum argumento
    disp('Erro: nao informado vetor do sinal de entrada')
    return
end
if nargin < 2
    % faltou especificar fs
    disp('Erro: nao informada freq. de amostragem')
    return
end
if nargin < 3
    % não especificado N
    N = length(x);
end

% Executa a rotina
fprintf('> Vetor de entrada x com %i pontos\n', length(x));

% Notar que N deve ser um valor par para N/2 resultar valor int!
N_inferior = fix(N);     % se float converte para inferior int
N_inferior = N_inferior - mod(N_inferior, 2); % garante numero par
N = N_inferior;

fprintf('> Realizando FFT de N = %i pontos\n', N);

if (length(x) == N)
    X = fft(x);
else
    X = fft(x, N);
end

bins_f = fs/N;
f = bins_f*(0:(N/2)); % gera N pontos de f(1)=0 até f(N-1)=
f_Nyq = fs/2;
fprintf('> Freq. de Nyquist = %g (Hz)\n', f_Nyq);
fprintf('> Número de bins válidos (unilateral) = %g\n', length(f));
index_maximo = N/2 + 1; % matlab/Octave inicia vetores em 1 e não em 0.
fprintf('> Freq. Máxima do Espectro = %g (Hz) em f(%i)\n', f(index_maximo), index_maximo)
fprintf('> Resolução frequencial = %g (Hz)\n', bins_f)

% size(f) % N/2, N chega aqui como número par!

% ERRO na linha abaixo
% X_mag=2*abs(X)/N; % não podemos duplicar tudo, duplica X(f=0) também!

% Ainda espectro bi-lateral
P2 = abs(X/N); % 1a-parte: re-escalona magnitude pelo fator N pontos

% Estamos interessados apenas na 1a-metada do espectro (unilateral)
Xmag = P2(1:N/2+1);

% converte amplitude para espectro unilateral
Xmag(2:end-1) = 2*Xmag(2:end-1);
% Note que o primeiro favor X(1) para f=0 (nível DC) não deve ser duplicado!

% size(f)
% size(Xmag)

% Fase (em rads) já com correção pi necessária (espectro lateral esquerdo)
X_fase=angle(X(1:index_maximo))/pi; 
X_fase=rad2deg(X_fase); % Fase em graus

h=figure; 
% stem(f, Xmag)
plot(f,Xmag)
xlim([0 f(index_maximo)]);
grid
ylabel('|Magnitude| (Volts)')
xlabel('Frequência (Hz)')
title('Espectro do Sinal')

% Separando principais componentes
media = mean( Xmag(2:end) ); % X_mag(1)= valor DC em freq = 0 Hz
[maior, indice] = max( Xmag(2:end) ); % maior magnitude excetuando nível DC
indice = indice + 1; % somar para compensar que varremos X_mag à partir de 2
V_base = maior;
fprintf('\nMagnitude usada como referência = %g (Volts) em f(%i)=%g (Hz)\n',...
    V_base, indice-1, f(indice))

% [f(indice) P2(indice) abs(P2(indice))] % Apenas para debug...

X_per=(Xmag/V_base)*100;
X_dB=20*log10(Xmag/V_base);

V_limiar = mean(Xmag(2:end));
fprintf('Magnitude usada como limiar <= %g (mean)\n', V_limiar)

figure(h);
hold on
% pt1=[0, V_limiar];
% pt2=[f(floor(N/2)), V_limiar]
plot( [0, f(index_maximo)],[V_limiar, V_limiar], 'm--'); % linha do limiar

[rows,cols,vals] = find(Xmag >= V_limiar);

% Fazendo um sort de |X(w)|
[B, index]=sort(Xmag,'descend');

% indice que importa normalmente é rows
n = length(rows);
fprintf('Encontradas %i frequências dominantes\n', n);

if n>20
    n=20;
    fprintf('Serão mostradas apenas as 20 maiores contribuições\n')
end

%     |     1 |    16.00 | 0.65593 | 100.000 |   0.00 |  -146.08 | | <-- Valor base (referência)
disp('|     # |    Freq  |  |X(w)|  |    %    |    dB  |   Fase  |')

% Atenção:
% size(f) % = 1 x N
% size(X_mag) % = N x 1
% size(X_per) % = N x 1
% size(X_dB) % = N x 1
% size(X_fase) % = N x 1
% [f(rows)' X_mag(rows) X_per(rows) X_dB(rows) X_fase(rows)]
for k=1:n
    %fprintf('| %5i | %8.2f | %8.5f | %7.3f | %6.2f | %7.2f |', ...
    %    k, f(k), X_mag(k), X_per(k), X_dB(k), X_fase(k))
    fprintf('| %5i | %8.2f | %8.5f | %7.3f | %6.2f | %7.2f |', ...
        index(k)-1, f(index(k)), Xmag(index(k)), X_per(index(k)), ...
        X_dB(index(k)), X_fase(index(k)))
    % if k==indice
    if index(k)==indice
        fprintf(' <-- Valor base (referência)')
    end
    if index(k)==1
        fprintf(' <-- Nível DC do sinal')
    end
    fprintf('\n')
end
