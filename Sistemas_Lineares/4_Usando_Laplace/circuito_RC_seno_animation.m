% baseado em circuito_RC_seno_varia.m
% Simula senoides freq. variável na entrada de
% um circuito RC passa-baixas

pkg load control

R = 1e3;
C = 1e-6;
disp("Frequência de corte deste circuito:")
fc=1/(2*pi*R*C)

s = tf('s');

H = 1/(R*C*s + 1);

Vm = 5;

% frequencias = [10 32 100 316 1000 3162 10000 fc/10 fc 10*fc];
frequencias = logspace(1,4,30); % 30 pts (10 em cada decada, entre 10 - 10Khz)

pts = length(frequencias); % total de pontos
azul_claro = [0.2, 0.6, 1.0]; % Código RGB para azul celeste

cont = 0;
for f = frequencias

    cont = cont + 1;
    per = (cont/pts);

    T = 1/f; % período da onda
    t_fim = 3.5*T;
    t_sampling = T/50; % 50 pontos por ciclo
    clear t Vin Vout;  % recomeça vetores
    t = 0:t_sampling:t_fim;

    Vin = Vm*sin(2*pi*f*t);

    [Vout, t] = lsim(H, Vin, t);

    figure;

    plot(t, Vin, 'LineWidth', 1.5);
    hold on;
    plot(t, Vout, 'LineWidth', 1.5);
    xlim([0 t_fim]);  % para não deixar eventual espaço em branco no final
    grid on;

    % Sobrepondo barra de avanço em frequencia...
    x_ini = 0.505*t_fim;
    x_fim = 0.98*t_fim;
    largura = x_fim - x_ini;
    y_fim = 1.13*Vm;
    y_ini = 1.07*Vm;
    altura = y_fim - y_ini;
    rectangle("Position", [x_ini, y_ini, largura, altura], ...
          "FaceColor", "none", ...       % Vazado por dentro
          "EdgeColor", [0.5, 0.5, 0.5], ... % Cor cinza (RGB)
          "LineWidth", 1);               % Espessura de 1 ponto
    % calcula barra de avanço
    avanco = per*largura;
    x_atual = x_ini + avanco;
    rectangle("Position", [x_ini, y_ini, avanco, altura], ...
          "FaceColor", azul_claro, ...       % Cor interna azul
          "EdgeColor", "blue", ...      % Cor da borda
          "LineWidth", 1.2);

    % Completa gráfico
    xlabel('Tempo (s)');
    ylabel('Tensão (V)');
    legend('V_{in}', 'V_{out}', "location", "southeast");

    aux = num2str(round(f));
    % title(['f = ', num2str(aux), ' Hz']);
    texto = ["Freq = ", aux, " Hz"];

    y_text = Vm*1.1; % .6180;
    x_text = t_fim*0.02; % 0.1618;
    text(x_text, y_text, texto, ...
      "FontSize", 16, ...
      "Color", "blue")

    filename = ['circuito_RC_seno_', aux, 'Hz.gif'];
    print(filename, "-dgif");
    fprintf("%2d. Gerado o arquivo: %s\n", cont, filename)

end
disp("Fim")

