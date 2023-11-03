function signal_fft2(t,sinal,duplicar_amostras)
% signal_fft.m
% Mostra o espectro de um sinal baseado na FFT do sinal
% Usa fun��o `fft()` e `fftshift()` para obter o espectro
%
% Par�metros de entrada
%   t = vetor tempo (em segundos): posi��o temporal de cada amostra
%   signal = amplitude do sinal em cada instante de tempo
%   k_ini = primeira amostra
%   k_fim = �ltima amostra
%   duplicar_amostras = 1 (duplica) ou 0 (n�o duplicar)


u = length(sinal);
fprintf('signal_fft >> N�mero original de amostras: %d\n', u);
k_ini = 1;
k_fim = u;
tt = t(k_fim) - t(k_ini);   % intervalo de tempo considerado (em segundos)
n = k_fim - k_ini + 1;      % n�mero de amostras
I = sinal(k_ini:k_fim);     % separando a regi�o de interesse
% fprintf('signal_fft >> Intervalo de tempo considerado: [%g, %g]\n', t(k_ini), t(k_fim));
if duplicar_amostras == 1
    for k = 1:2*n   % duplicar n�mero de amostras
        if (k <= n)
            I2(k) = I(k); % I2(k,2) = I(k);
            t2(k) = t(k); % t2(k,1) = t(k);
        else
            I2(k) = I(k-n);             % I2(k,2) = I(k-n);
            t2(k) = t(k_fim) + t(k-n);  % t2(k,1) = t(k_fim) + t(k-n);
        end
    end
    n = 2*n;    % dobrou numero de amostras
    tt = 2*tt;
else
    I2 = I;
    t2 = t;
end

fprintf('signal_fft >> N�mero de amostras consideradas, n = %d\n', n);
fprintf('signal_fft >> Intervalo de tempo considerado, tt = %g\n', tt);
figure; subplot(2,1,1)
plot(t2, I2) % plot(I2) 
% I2 = vetor de n-linhas x 2 colunas !? para fins da fun��o fft() !?
% Se � este o caso:
% n = n�mero de amostras
% coluna 1 = instante de tempo da amostra
% coluna 2 = amplitude da amostra
title('Sinal analisado (dom�nio tempo)')
xlabel('t (segundos)')
grid

% Calculando a FFT
fft_result = fft(I2);    % DFT sobre o sinal, retorna n-pontos (n=length(I2))

% Fs = Taxa de amostragem (Hz)
% Calculo das frequencias correspondentes
Fs = 1/(t(2)-t(1));     % assumindo amostras equidistantes entre si
fprintf('signal_fft >> Freq. de amostragem original, Fs = %g\n', Fs);
% Fs = Taxa de amostragem (Hz)
freq = (0:n-1) * (Fs/n); % Frequ�ncias correspondentes
% N�o deveria ser: (0:n) * (Fs/n); ?
u = length(freq);
freq_inc = freq(2)-freq(1);
fprintf('signal_fft >> Frequ�ncias: [ %g : %g : %g] Hz (%d pontos)\n', freq(1), freq_inc, freq(u), u);
% Calculando a magnitude (descartando a fase)
mag = 2*abs(fftshift(fft_result))/n;

subplot(2,1,2)
plot(freq, mag);
title('Sinal analisado (dom�nio Frequ�ncia)')
xlabel('Frequ�ncia (Hz)')
axis([0 freq(u) 0 max(mag)*1.1])
grid
