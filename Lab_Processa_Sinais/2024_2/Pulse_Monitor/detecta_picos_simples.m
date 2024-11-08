% detecta_picos_simples.m
% Algoritmo exemplo para tentar detectar picos máximos
% de sinal capturado real (e filtrado) de sensor foto-elétrico
% baseado em cálculos de derivadas
% Fernando Passold, em 25/10/2024; 07/11/2024

disp('Rotina para testar algoritmo detector picos...')
T = 0.02; % taxa de amostragem adotada (esperada) ou 50 Hz
%% Leitura do arquivo "bag"
filename = 'captura_com_dedo.txt';
fprintf('Nome (e path) do arquivo (bag) de dados: [%s] ', filename);
aux = input('? ', 's');
if (aux ~= '')
    filename = aux;
end
dados = load(filename);
[amostras, cols] = size(dados);  % espera 2 colunas de dados
x=dados(:,1);    % separa x[n] = dados brutos
yy=dados(:,2);    % separa y[n] = sinal filtrado

fprintf('Arquivo com %d amostras, ou %g segundos de dados\n', amostras, amostras*T);

%% PLotando dados filtrados
t=0:T:(amostras-1)*T; % cria vetor t (em segundos)
figure; % abre nova janela gráfica
plot(t,yy);
xlabel('Tempo (segundos)');
ylabel('Amplitude');
aux= [ 'Sinal filtrado [Arquivo: ' filename ']' ];
title(aux)
H = gcf;
fprintf('Informe a "janela" de dados à ser usada para testar algoritmo\n');
fprintf('Observe a Figure (%d) e indique:\n', H.Number);
t_ini = input('Instante de tempo inicial (em segundos): ? ');
t_fim = input('Instante final de tempo (em segundos): ? ');
% calculando pontos iniciais e finais em instante de amostragem
k_ini = t_ini/T + 1;    % +1 pq indices Matlab iniciam em 1 e não em zero
k_fim = t_fim/T + 1;
u = k_fim - k_ini;
max_y = max(yy(k_ini:k_fim));
min_y = min(yy(k_ini:k_fim));
fprintf('Serão analizadas %d amostras\n', u);
fprintf('Com y[k] variando na faixa: [%.2f, %.2f]\n', min_y, max_y);
figure(H.Number)
hold on
x_aux = [t_ini   t_fim  t_fim    t_ini    t_ini];
y_aux = [min_y min_y  max_y  max_y min_y];
plot(x_aux, y_aux, 'g-');

%% Inicialização de variáveis
anterior = 0;
prev_dy = 0;

figure; % Abre nova janela gráfica
H = gcf; % returns the handle of the nwe current figure
clear yyy tt x_aux y_aux

%% varrendo janela de dados
for k = 1:u  % Loop varrendo os dados progressivamente
    novo_ponto = yy(k_ini + k - 1);  % novo valor de amostra
    
    % guarda pontos para gerar gráfico em "tempo-real":
    % plot(tt, yyy)
    if (k == 1)
        yyy(1) = novo_ponto;
        tt(1) = t(k_ini);
    else
        yyy = [yyy novo_ponto];  % faz um "append" de dados ao vetor yyy
        tt = [tt t(k_ini + k - 1)];
    end
    
    % Calcular a derivada primeira (aproximação)
    dy = (novo_ponto - anterior) / T;
    
    % Calcular a derivada segunda (aproximação)
    ddy = (dy - prev_dy) / T;
    
    % Verificar condições para máximo local
    if (prev_dy > 0) && (dy < 0)
        fprintf('[k=%d] Máximo local encontrado em k = %d, com valor: %5.2f\n', k, k-1, anterior);
        Atualiza_Grafico(H.Number, tt, yyy, min_y, max_y, 'ro');
    end
    
    % Verificar condições para mínimo local
    if (prev_dy < 0) && (dy > 0)
        fprintf('[k=%d] Mínimo local encontrado em k = %d, com valor: %5.2f\n', k, k-1, anterior);
        Atualiza_Grafico(H.Number, tt, yyy, min_y, max_y, 'sb');
    end
    
    % atualizando variáveis para próxima interação
    anterior = novo_ponto;
    prev_dy = dy;
end

function Atualiza_Grafico(num_fig, t, y, min_y, max_y, option);
    % Atualiza gráfico na tela
    figure(num_fig);
    plot(t, y, 'b-');
    hold on;
    plot(t(end-1), y(end-1), option, 'MarkerSize', 12);
    grid;
    ylim([min_y*1.1  max_y*1.1]);
    pause;
end
