% Programa para sintetizar um acorde do tipo aberto, maior, formado pela combinação
% das notas: Dó (oitava superior) + Mi (oitava inferior) + Sol (oitava superior):
%
% Mi = 164,81 Hz (~~E3~~ <-- E2); --> ou: E3 = 329.627533 Hz;
% Dó = 261,63 Hz (~~C4~~ <-- C3); --> ou: C4 = 523.251099 Hz;
% Sol= 392,00 Hz (~~G4~~ <-- C3). --> ou: G4 = 783.990845 Hz.
%
% Obs: amplitudes unitárias e defasagens nulas
%
% Versão #2:
% 
% Acrescenta harmônicas com decaimento logarítmico: 
% -20 db/década, ou 6 dB/oitava (10^(-6/20) = 0.50119/oitava)
% a partir da freq. superior à maior freq, das notas originais

% Fernando Passold, em 18/05/2026

clear all
clc % limpa janela de comandos

t_fim=7; % tempo de execução em segundos
% f=[164.81  261.63  392.00]; % freq's das notas: E3, C4 e G4
disp('Frequências originais das notas:')
f=[659.26  261.63  392.00] % freq's das notas: E4, C4 e G4
G=[1 1 1]; % amplitudes de cada nota
qtdade_freqs_originais = length(f);

% Gerando harmônicas extras:
% Amplitudes das harmônicas cai de forma logarítmica, 
% -20 db/década, ou 6 dB/oitava (10^(-6/20) = 0.50119/oitava)
% mas a partir da freq. superior à maior freq, das notas originais
fim = length(f);
har = 3; % quantidade de harmônicas extras
cont = fim;
for h = 1:har
    for componente = 1:fim
        cont = cont + 1;
        f(cont) = f(cont-fim)*2;
        G(cont) = G(cont-fim)*0.5;
    end
end
disp('Total frequências sintetizadas:')
cont
disp('Frequências x Ganhos')
[f' G']

% Gráfico do espectro do sinal
figure;
% plotanto linhas guias dos espectros originais
stem( f(1:qtdade_freqs_originais), G(1:qtdade_freqs_originais)*1.2, ':', 'Color', [1, 0.5, 0], 'LineWidth', 2);
hold on
% sobrepondo todas linhas do espectro
stem(f, G, 'b-', 'LineWidth', 3, 'MarkerSize', 8) % mas escala freq é linear
set(gca, 'XScale', 'log'); % Transforma o eixo X em logarítmico
grid on
title("Espectro do Acorde")
xlabel("log_{10}(Frequência) (Hz)");
ylabel("Ganho (abs)")

% monta string da legenda
% >> legenda=["1"; "22"; "333"]
% legenda = 
%  3×1 string array
%    "1"
%    "22"
%    "333"
% >>size(legenda)
% ans =
%     3     1
% >> legenda(2)
% ans = 
%    "22"
for freq = 1:length(f)
    msg1 = num2str( freq ); % transforma valor em string
    msg2 = num2str( f(freq) ); % transforma valor em string
    msg3 = ['f(', msg1, ') = ', msg2, ' Hz']; % 'f(1) = 659.26 Hz'
    legenda(freq) = string(msg3); % transforma cada pedaço numa string
end
legenda(freq+1)="Composição Final";
% legenda % apenas para verificação

fs=48E3; % freq. de amostragem
T=1/fs;
disp('Quantidade de pontos (amostras) geradas:')
pontos=t_fim/T % quantidade de pontos que serão gerados
y=zeros(pontos, length(f)+1); % gera um vetor de 240.000 pontos
% t=[0:T:t_fim]; % gera matriz 1 x 240001
t=[0:T:t_fim-T];
t=t'; % matriz de 240000 x 1

% y1=1*sin(2*pi*f*t+defasagem);
% y[]=1*sin(2*pi*f(1, k)*t);
% y=y1+y2+y3;
for tt = 1:length(t)
    for freq = 1:length(f)
        % y(tt, 1) = y(tt, 1) + 1*sin(2*pi*f(1, freq));
        y(tt, freq) = G(freq)*sin(2*pi*f(1, freq)*t(tt,1) ); % amplitude para cada nota no instante t
        y(tt, length(f)+1) = y(tt, length(f)+1) + y(tt, freq); % somar amplitudes das nota em cada instante t
    end
end

% Plotando as formas de onda
menor_freq=min(f);
intervalo_tempo=6*(1/menor_freq); % motrando 6 ciclos da menor freq
amostras=round(intervalo_tempo/T);
figure;
plot( t(1:amostras,1), y(1:amostras, 1));
hold on
for freq = 2:length(f)+1
    if freq < length(f)+1
        plot( t(1:amostras, 1), y(1:amostras, freq));
    else
        plot( t(1:amostras, 1), y(1:amostras, freq), 'LineWidth', 3);
    end
end
legend(legenda);
title("Síntese do Acorde")
xlim([0 intervalo_tempo]);

% Normalizando ampitude do sinal para faixa [-1 1]
disp('Picos de amplitudes sinal composto:')
maximo=max(y(:, length(f)+1)) %*1.1 % 10% a mais
minimo=min(y(:, length(f)+1)) % *1.1
if maximo > abs(minimo)
    maximo = maximo;
else
    maximo = abs(minimo);
end
yy=y(:, length(f)+1)*(1/maximo);

% Aplicando decaimento 
% ganho(t) = exp(=t/tau)
% ts = 4*tau
% ts = t_fim
disp('Constante de decaimento:')
tau = t_fim/5
for tt = 1:length(t)
    y1(tt) = exp(-t(tt,1)/tau);
    y2(tt) = -y1(tt);
    yy(tt) = yy(tt)*exp(-t(tt,1)/tau);
end
figure; % nova figura
plot(t,y1,'k--', t,y2,'k--', t,yy,'b-')
title("Sinal com Decaimento");
ylim([-1 1]);

sound(yy, fs)
disp('Se quiser ouvir novamente, digite:')
disp('  sound(yy,fs)')
