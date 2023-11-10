function signal_fft3(t,sinal,tol)
% signal_fft.m
% Mostra o espectro de um sinal baseado na FFT do sinal
% Usa função `fft()` e `fftshift()` para obter o espectro
%
% Parâmetros de entrada
%   t = vetor tempo (em segundos): posição temporal de cada amostra
%   sinal = amplitude do sinal em cada instante de tempo
%   tol = tolerência (em %) usada para ainda considerar magnitudes
%         baixas como harmônica do sinal (sugerido 0.1%)
%
% Fernando Passold, em 02/11/2023


u = length(sinal);
fprintf('signal_fft >> Número original de amostras: %d\n', u);
k_ini = 1;
k_fim = u;
tt = t(k_fim) - t(k_ini);   % intervalo de tempo considerado (em segundos)
n = k_fim - k_ini + 1;      % número de amostras
I = sinal(k_ini:k_fim);     % separando a região de interesse
I2 = I;
t2 = t;

fprintf('signal_fft >> Número de amostras consideradas, n = %d\n', n);
fprintf('signal_fft >> Intervalo de tempo considerado, tt = %g\n', tt);
figure; subplot(2,1,1)
plot(t2, I2) % plot(I2) 
% I2 = vetor de n-linhas x 2 colunas !? para fins da função fft() !?
% Se é este o caso:
% n = número de amostras
% coluna 1 = instante de tempo da amostra
% coluna 2 = amplitude da amostra
title('Sinal analisado (domínio tempo)')
xlabel('t (segundos)')
grid

% Calculando a FFT
fft_result = fft(I2);    % DFT sobre o sinal, retorna n-pontos (n=length(I2))

% Fs = Taxa de amostragem (Hz)
% Calculo das frequencias correspondentes
% Fs = Taxa de amostragem (Hz)
Fs = 1/(t(2)-t(1));     % assumindo amostras equidistantes entre si
fprintf('signal_fft >> Freq. de amostragem original, Fs = %g Hz\n', Fs);
Fnyq = Fs/2;
freq_ini = -Fnyq;
freq_inc = 2*Fnyq/n;
freq_fim =  Fnyq - freq_inc;            % retrocede 1 ponto
freq = freq_ini: freq_inc : freq_fim;   % forma vetor frequencia (em Hz)
u = length(freq);
fprintf('signal_fft >> Frequências: [ %g : %g : %g] Hz (%d pontos)\n', freq_ini, freq_inc, freq_fim, u);
% Calculando a magnitude (descartando a fase)
mag = 2*abs(fftshift(fft_result))/n;    % desloca o componente da frequencia zero (nível DC) do sinal no centro do espectro obtido via fft()

subplot(2,1,2)
plot(freq, mag, 'bo-');
title('Sinal analisado (domínio Frequência)')
xlabel('Frequência (Hz)')
axis([0 freq_fim 0 max(mag)*1.1])
grid

% Encontrando frquencias correspondentes aos picos do sinal no dominio
% frequencia
% Varrendo vetor frequencia
% freq_central = freq(u/2+1); % eventualmente rende 0 Hz
tol2= tol/100;
[maior, last] = max(mag);
limiar = maior*tol2;
disp('signal_fft >> Harmônicas detectadas:');
fprintf('signal_fft >> [Freq\tMag]\n');
for index = u/2+1:u
    if mag(index)>=limiar;
       fprintf('signal_fft >> [%g\t%g]\n', freq(index), mag(index));
       last = index;
    end
end
% re-escalonando figura
freq_limite = freq(last)*2;
if freq_limite >= (freq_fim - freq_inc)
    freq_limite = -freq_ini;
end
axis([0 freq_limite 0 maior*1.1])