% convol2.m
% Fernando Passold, em 31/08/2023
clear x h x_mono h_mono

%% Carregar um sinal de áudio e uma resposta ao impulso
disp('Teste de convolução (reverberação) de sinais')
disp(' ');
file_x = input('Informe nome arquivo audio de entrada ? ', 's');
% audio_signal = audioread('audio_file.wav');
[x, Fs_x] = audioread(file_x);
fprintf('Freq. de amostragem adotada: %.2f [KHz]\n\n', Fs_x/1000);

%% Eventualmente o arquivo de entrada é stereo (2 canais)
% se faz necessário converter de stereo --> mono
% Ref.: https://la.mathworks.com/matlabcentral/answers/345155-how-to-check-number-of-channels-of-a-sound-file-and-convert-stereo-file-in-mono-in-matlab
[L_x, n_x] = size(x); % n_x = numero de canais
if n_x >= 2
    % trabalha apenas com os 2 primeiros canais, supondo sinal stereo
    fprintf('Sinal de entrada possui %i canais. Convertendo para mono...\n\n', n_x);
    x_mono = x(:, 1) + x(:, 2);
    peakAmp = max(abs(x_mono));
    x_mono = x_mono/peakAmp;
    %  check the L/R channels for orig. peak Amplitudes
    peakL = max(abs(x(:, 1)));
    peakR = max(abs(x(:, 2))); 
    maxPeak = max([peakL peakR]);
    % apply x's original peak amplitude to the normalized mono mixdown 
    x_mono = x_mono*maxPeak;
else
    x_mono = x;
end

%% Carrega arquivo IR
file_h = input('Informe nome arquivo audio de IR ? ', 's');
% impulse_response = audioread('impulse_response.wav');
% impulse_response = audioread(file_h);
[h, Fs_h] = audioread(file_h);
fprintf('Freq. de amostragem adotada: %.2f [KHz]\n\n', Fs_h/1000);

%% Eventualmente o arquivo de entrada é stereo (2 canais)
% se faz necessário converter de stereo --> mono
% Ref.: https://la.mathworks.com/matlabcentral/answers/345155-how-to-check-number-of-channels-of-a-sound-file-and-convert-stereo-file-in-mono-in-matlab
[L_h, n_h] = size(h); % n_h = numero de canais
if n_h >= 2
    % trabalha apenas com os 2 primeiros canais, supondo sinal stereo
    fprintf('Sinal IR possui %i canais. Convertendo para mono...\n\n', n_h);
    h_mono = h(:, 1) + h(:, 2);
    peakAmp = max(abs(h_mono));
    h_mono = h_mono/peakAmp;
    %  check the L/R channels for orig. peak Amplitudes
    peakL = max(abs(h(:, 1)));
    peakR = max(abs(h(:, 2))); 
    maxPeak = max([peakL peakR]);
    % apply x's original peak amplitude to the normalized mono mixdown 
    h_mono = h_mono*maxPeak;
else
    h_mono = h;
end

%% Compatibiliza Fs's se diferentes...
if Fs_x ~= Fs_h
    fprintf('ATENÇÃO: Freq. de amostragem do sinal de entrada\n');
    disp('é diferente do sinal de IR');
    fprintf('Reduzindo Sampling rate do sinal ');
    menor_Fs = min([Fs_x Fs_h]);
    maior_Fs = max([Fs_x Fs_h]);
    % Ref.: https://la.mathworks.com/help/signal/ug/changing-signal-sample-rate.html#
    [P, Q] = rat(maior_Fs/menor_Fs);
    % descobre qual sinal deve ser re-sampleado
    if maior_Fs == Fs_h
        disp('IR');
        h_mono = resample(h_mono, P, Q);
        [L_h, n_h] = size(h_mono);
    else
        disp('de entrada');
        x_mono = resample(x_mono, P, Q);
        [L_x, n_x] = size(x_mono);
    end
    fprintf('Para nova taxa de amostragem: %.2f [KHz]\n\n', menor_Fs/1000);
end

%% Realizar a convolução em tempo real
% output_signal = conv(audio_signal, impulse_response);
disp('Realizando convolução... ')
L = max([L_x+L_h-1, L_x, L_h]); % estimando qtdade de amostras geradas...
fprintf('%i amostras serão geradas (%.2f segundos).\nAguarde...\n', L, L/menor_Fs);
output_signal = conv(x_mono, h_mono);

% Normalizando o vetor de saida obtido, senão ocorre eventualmente:
% Warning: Data clipped when writing file.
% Ocasionado porque:
% For 16 bit precision, the values are limited to –1.0 <= y < +1.0, 
% when the signal is provided as floating point format. 
% A workaround is to convert the data manually before calling wavwrite()

output_signal = output_signal ./ max(abs(output_signal(:)));

%% Reproduzir o sinal de saída
disp('Normalizando amplitudes vetor de saída...')
sound(output_signal, menor_Fs);  % 'Fs' é a taxa de amostragem do áudio

filename = 'output_signal.wav';
audiowrite(filename, output_signal, menor_Fs);
fprintf('\nGravado arquivo <<%s>>...\n', filename);
disp('Para repetir saída gerada, digite:');
fprintf('\tsound(output_signal, menor_Fs);\n\n')
