function signal_fft(t,sinal,duplicar_amostras)
% signal_fft.m
% Mostra o espectro de um sinal baseado na FFT do sinal
% Usa função `fft()` e `fftshit()` para obter o espectro
% Baseado em rotina original Prof. Mikhail Polonskii
% Parâmetros de entrada
%   t = vetor tempo (em segundos): posição temporal de cada amostra
%   signal = amplitude do sinal em cada instante de tempo
%   k_ini = primeira amostra
%   k_fim = última amostra
%   duplicar_amostras = 1 (duplica) ou 0 (não duplicar)


u = length(sinal);
fprintf('signal_fft >> Número original de amostras: %d\n', u);
k_ini = 1;
k_fim = u;
tt = t(k_fim) - t(k_ini);   % intervalo de tempo considerado (em segundos)
n = k_fim - k_ini + 1;      % número de amostras
I = sinal(k_ini:k_fim);     % separando a região de interesse
% fprintf('signal_fft >> Intervalo de tempo considerado: [%g, %g]\n', t(k_ini), t(k_fim));
if duplicar_amostras == 1
    for k = 1:2*n   % duplicar número de amostras
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

Fnyq = n/tt;    % dobro da freq. de Nyquist
fprintf('signal_fft >> Fnyq: %d\n', Fnyq);
f = fft(I2);    % DFT sobre o sinal, retorna n-pontos (n=length(I2))
F_ini = -Fnyq/2;
F_fim = Fnyq/2-1/n;
F_inc = Fnyq/n;
Freq = F_ini: F_inc: F_fim;     % formar escala de frequencias
u = length(Freq);
fprintf('signal_fft >> Freq = [%g : %g : %g] (%g pontos)\n', F_ini, F_inc, F_fim, u);
zz = 2*abs(fftshift(f))/n;  % desloca o componente da frequencia zero (nível DC) do sinal no centro do espectro obtido via fft()

subplot(2,1,2)
plot(Freq, zz);
title('Sinal analisado (domínio Frequência)')
xlabel('Frequência (Hz)')
axis([0 F_fim 0 max(zz)*1.1])
grid






