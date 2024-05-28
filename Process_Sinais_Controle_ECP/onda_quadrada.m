% Onda quadrada usando s�rie de Fourier
% Fernando Passold, em 28/05/2024

fprintf('\nOnda quadrada usando s�rie de Fourier\n\n');
f = input("Freq. da onda em Hz: ? ");
T = 1/f;
ciclos = 2;
fs = 100*f;     % 100 pts por ciclo da onda original
t_fim = ciclos*T;
t = 0:1/fs:t_fim;   % cria vetor tempo t[k]. incremento T=1/fs (valores em segundos)
amostras = length(t);

A = input('Amplitude: ? ');
a0 = input('N�vel DC: ? ');

h = input("At� que harm�nica: ? ");

y = zeros(amostras,1);  % inicializa vetor y[k]
handler=figure;
Freq=0:f:f*h;     % Freq de cada harm�nica (em Hz)
Mag=zeros(1,length(Freq));  % Mag de cada harm�mica (em Volts)
Freq(1)=0;
Mag(1)=a0;
y = a0*ones(1,amostras);     % inicializa y[k]=n�vel DC;
fprintf('Pausado na harm�nica:\n');
fprintf('n=  0');
for n=1:h     % incremento 2: onda quadrada s� harm�nicas �mpares
    % Deterctando se harm�nica n atual � �mpar:
    Mag(n+1)=0;
    maior=max(Mag);
    if mod(n,2)>0
        Mag(n+1)=A/n;
        y=y+(A/n)*sin(n*2*pi*f.*t);
        figure(handler)
        subplot(2,1,1)
        plot([0 t_fim], [a0 a0], 'c--', t,y, 'b-', 'LineWidth', 2)
        xlabel('Tempo (segundos)');
        ylabel('Amplitude (Volts)');
        title('S�rie Fourier Onda Quadrada');
        xlim([0 t_fim])
        subplot(2,1,2)
        stem(Freq, Mag, 'LineWidth', 2, 'MarkerSize', 8);
        xlabel('Frequ�ncia (Hz)');
        ylabel('Amplitude (Volts)');
        title('Componentes do Espectro');
        texto=['Harm�nicas = ' num2str(n)];
        text(0.7*h*f, maior*0.75, texto, 'FontSize', 14)
        %        12123
        fprintf('\b\b\b\b\b');  % retrocede apagando 5 espa�os.
        fprintf('n=%3i', n);
        pause
    end
end
fprintf('\n\t\tFreq\t\tMag\t\tMag(dB)\n');
disp([Freq' Mag' 20*log10(Mag)'])
fprintf('Fim\n');
    