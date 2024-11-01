% detecta_picos_bag.m
% Algoritmo exemplo para tentar detectar picos máximos
% de sinal capturado real (e filtrado) de sensor foto-elétrico
% Fernando Passold, em 25/10/2024

T = 0.02; % taxa de amostragem adotada (esperada)
%% Leitura do arquivo "bag"
filename = input('Nome (e path) do arquivo (bag) de dados: ? ', 's');
dados = load(filename);
[pts, cols] = size(dados);  % esperadas 2 colunas
x=dados(:,1);    % separa x[n] = dados brutos
y=dados(:,2);    % separa y[n] = sinal filtrado
fprintf('Arquivo com %d amostras, ou %g segundos de dados\n', pts, pts*T);

%% PLotando dados filtrados
t=0:T:(pts-1)*T; % cria vetor t (em segundos)
figure; % abre nova janela gráfica
plot(t,y);
xlabel('Tempo (segundos)');
ylabel('Amplitude');
aux= [ 'Sinal filtrado [' filename ']' ];
title(aux)
H = gcf;
fprintf('Informe a "janela" de dados usada para testar algoritmo\n');
fprintf('Observe a Figure (%d) e indique:\n', H.Number);
ini = input('Instante de tempo inicial (em segundos): ? ');
fim = input('Instante final de tempo (em segundos): ? ');

%% Inicialização de variáveis
pico = NaN;  % Valor do último pico detectado
distancia = NaN; % Distância entre o último e o penúltimo pico (em amostras)
ultimoPicoIdx = NaN; % Índice do último pico detectado
anterior = 0;
anterior2 = 0;

%% Parâmetros de detecção
min_spacing = 10; % Espaçamento mínimo entre picos em número de amostras
% Estimasse medir BPM entre 30 à 300 BPM ==> 0.5 < f (Hz) < 5
% O sinal mais rápido, de 5 Hz, teria período de: 1/5 = 0,2
% o que equivale a uma "distância" entre os picos de: 0,2/0,02 = 10
% amostras
threshold = 0.1;  % Limite mínimo da derivada para ignorar ruídos

figure; % Abre nova janela gráfica
H = gcf; % returns the handle of the current figure
k_ini = ini/T;          % amostra inicial
k_fim = fim/T;      % amostra final
u = k_fim - k_ini;  % qtdade de dados à ser "percorrida"

%% Percorre dados da "janela"
for k = 1:u  % Loop varrendo os dadoa progressivamente
    novo_ponto = y(k_ini + k - 1);  % acessa dado real do "bag"
    
    % acumulando novos pontos num novo gráfico
    % atualizado em "tempo-real"
    tt(k) = t(k_ini + k -1);
    yy(k) = novo_ponto;
    figure(H);
    plot(tt, yy, 'b-');
    
    % if k > 2    % detectar só depois de anterior2 diferente de zero
        % Calcular primeira e segunda derivadas com os últimos três pontos
        dy = novo_ponto - anterior;         % "derivada" primeira
        dy_prev = anterior - anterior2;
        d2y = dy - dy_prev;                   % "derivada" segunda
        
        % Verificar se o ponto atual é um pico
        if dy_prev > 0 && dy < 0 && abs(dy_prev) > threshold && d2y < 0
            % Verificar espaçamento mínimo
            if isnan(ultimoPicoIdx) || (k - ultimoPicoIdx) >= min_spacing
                % Atualizar variáveis de pico e distância
                distancia = k - ultimoPicoIdx;
                pico = novo_ponto;
                ultimoPicoIdx = k;
                hold on;
                plot(tt(k-1), yy(k-1), 'ro')    % plotando marcador no pico detectado
                delta_t = distancia*T;
                freq = 1/delta_t;
                BPM = freq*60;
                aux=num2str(BPM, '%.1f');
                text(tt(k-1), yy(k-1)+0.2, aux);  % sobrepõe texto com valor em BPM
                fprintf('Pico detectado (valor = %4.2f, dist = %d): %.1f BPM\n', pico, distancia, BPM);
                aux = input('Tecle <ENTER> para continuar');
            end
        end
    % end
    
    % Atualizar os valores anteriores
    anterior2 = anterior;
    anterior = novo_ponto;
end
hold on;
x_ini=tt(u*0.8);
rectangle('Position', [x_ini, -12, min_spacing*T, 2.5], 'FaceColor',[0 0.8 0.95])
aux=num2str(min_spacing, '%d');
aux=[ 'min\_spacing = ' aux];
text(x_ini, -13, aux)
axis tight
xlabel('Tempo (segundos)')
ylabel('Amplitude');
aux= [ 'Sinal filtrado [' filename ']' ];
title(aux)
% ![detecta_picos_bag.png](detecta_picos_bag.png)