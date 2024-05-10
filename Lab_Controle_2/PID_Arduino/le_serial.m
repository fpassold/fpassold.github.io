% Configuração da porta serial
% ATENÇÃO: eventualmente é necessário o "Instrument Control Toolbox"
% Eventualmente a IDE, NÃO pode estar sendo executada.
% Além disto:
% This feature requires the MATLAB Support Package for Arduino Hardware
% add-on, ver
% >> matlab.internal.addons.showAddon('ML_ARDUINO');
% https://www.mathworks.com/help/matlab/arduinoio.html
% Instalar buscando ícone "Add-Ons" na Aba "Home", ícone "Add-Ons" >> selecione a seta para baixo!!!
% https://www.mathworks.com/help/matlab/arduinoio.html
% seguir instruções acima, só disponível para Matlab registrado e recente!
% 
% Fernando Passold, em 10/05/2024
%
% Note msg quando se tenta instalar este Add-On:
% matlab.internal.addons.showAddon('ML_ARDUINO');
% Unable to resolve the name matlab.internal.addons.showAddon. 
% Unable to detect connection to the serialport device. Ensure that the device is plugged in and create a new serialport object.

clear s ports
disp("---")
disp("Portas Encontradas:")

% serialPort = 'COM1'; % Altere para a porta serial que você está usando
% serialPort="/dev/tty.usbmodem14201"; % como aparece num Mac, para TX
% serialPort="/dev/cu.submodem14201"; % para RX (dados do Arduino)cl
baudRate = 115200; % 9600 = deafult; Taxa de transmissão

% instrfind           % mostra portas seriais disponíveis
ports = serialportlist("available");
disp(ports')

% Abra a porta serial
sarduinoObj = serialport(ports(4),baudRate)
% s = serialport(serialPort, baudRate);

configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);
arduinoObj.UserData = struct("Data",[],"Count",1)
% Ver: https://www.mathworks.com/help/instrument/read-streaming-data-from-arduino.html
% Ver também: https://www.mathworks.com/help/matlab/supportpkg/matlabshared.serial.device.html
% https://www.mathworks.com/discovery/arduino-programming-matlab-simulink.html

fopen(arduinoObj);

% Inicialize o gráfico
figure;
hLine = plot(NaN, NaN); % Inicialize o gráfico com dados vazios
xlabel('Tempo');
ylabel('Dados');
title('Dados em tempo real');
grid on;

% Variável de controle de pausa
paused = false;

% Loop para ler e plotar dados em tempo real
while ishandle(hLine)
    % Ler os dados da porta serial se não estiver pausado
    if ~paused
        data = fscanf(s, '%f'); % Supondo que os dados são números de ponto flutuante

        % Atualizar o gráfico com os novos dados
        if ~isempty(data)
            x = 1:length(data); % Tempo
            set(hLine, 'XData', x, 'YData', data); % Atualize o gráfico
            drawnow; % Atualize a interface gráfica
        end
    end
    
    % Verifique se uma tecla foi pressionada para pausar ou parar o gráfico
    if kbhit
        key = getkey;
        switch key
            case 'p' % Tecla 'p' para pausar
                paused = ~paused;
            case 'q' % Tecla 'q' para parar
                break;
        end
    end
end

% Fechar a porta serial quando o loop terminar
fclose(s);
delete(s);
clear s;
