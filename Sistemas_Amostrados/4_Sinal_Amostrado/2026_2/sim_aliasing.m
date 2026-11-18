% sim_aliasing.m

clear; close all; clc;

% Senoide original
f0 = 1000;          % Frequencia original (Hz)
T = 0.5;            % Duracao (s)
fase = deg2rad(45);         % Fase inicial, 45?o

% Frequencia de reproducao do audio
Fa = 44100;

% Frequencias de amostragem a experimentar
% Fs_list = [800 1000 1500 2000 4000 10000];
  Fs_list = [10000 4000 2000 1500 1000 800];

% Sinal original em alta resolucao
ta = (0:1/Fa:T-1/Fa)';
x_original = sin(2*pi*f0*ta + fase);

% Reproducao da senoide original
disp('Senoide original: 1 kHz');
sound(x_original, Fa);
pause(T+0.3);

% Graficos
figure;

for i = 1:length(Fs_list)

    Fs = Fs_list(i);

    % Amostragem
    n = 0:ceil(T*Fs)-1;
    ts = n/Fs;
    xs = sin(2*pi*f0*ts + fase);

    % Frequencia aparente (alias)
    f_alias = abs(mod(f0 + Fs/2, Fs) - Fs/2);

    fprintf('Fs = %5d Hz | Alias = %7.1f Hz\n', ...
             Fs, f_alias);

    % Reconstrucao por Zero-Order Hold
    % Cada amostra permanece constante ate a proxima
    idx = floor(ta*Fs) + 1;
    idx(idx > length(xs)) = length(xs);

    x_audio = xs(idx);

    % Graficos: primeiros 10 ms
    subplot(3,2,i);

    tplot = (0:1/Fa:0.01)';
    xplot = sin(2*pi*f0*tplot + fase);

    plot(tplot*1000, xplot, 'k');
    hold on;
    stem(ts(ts <= 0.01)*1000, ...
         xs(ts <= 0.01), 'filled');

    grid on;
    axis([0 10 -1.1 1.1]);

    title(sprintf('Fs = %d Hz | Alias = %.0f Hz', ...
                  Fs, f_alias));

    xlabel('Tempo (ms)');
    ylabel('Amplitude');

    % Reproducao do sinal amostrado
    fprintf('Reproduzindo Fs = %d Hz...\n', Fs);

    sound(x_audio, Fa);
    pause(T+0.3);

end
