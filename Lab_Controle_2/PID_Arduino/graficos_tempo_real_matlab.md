# Gráficos em tempo-real

**Problema**: Suponha que uma placa microcontrolado gera na saída serial, um conjunto de dados numéricos separador por certo identificados (vírgula, tabulação, espaço em branco). Como poderia programar o Matlab (e que toolboxes seriam necessários) para que o mesmo consiga ler estes dados no mesmo instante em que estão sendo gerados (um streaming de dados) e seja então capaz de atualizar um gráfico numa interface gráfica em "tempo-real". Sugestões?

Para ler dados em tempo real de uma porta serial no MATLAB e atualizar um gráfico em tempo real, você pode usar a função `fscanf` para ler os dados da porta serial e a função `drawnow` para atualizar o gráfico. Aqui está um exemplo básico de como você poderia fazer isso:

```matlab
% Configuração da porta serial
serialPort = 'COM1'; % Altere para a porta serial que você está usando
baudRate = 9600; % Taxa de transmissão

% Abra a porta serial
s = serial(serialPort, 'BaudRate', baudRate);
fopen(s);

% Inicialize o gráfico
figure;
hLine = plot(NaN, NaN); % Inicialize o gráfico com dados vazios
xlabel('Tempo');
ylabel('Dados');
title('Dados em tempo real');
grid on;

% Loop para ler e plotar dados em tempo real
while ishandle(hLine)
    % Ler os dados da porta serial
    data = fscanf(s, '%f'); % Supondo que os dados são números de ponto flutuante
    
    % Atualizar o gráfico com os novos dados
    if ~isempty(data)
        x = 1:length(data); % Tempo
        set(hLine, 'XData', x, 'YData', data); % Atualize o gráfico
        drawnow; % Atualize a interface gráfica
    end
end

% Fechar a porta serial quando o loop terminar
fclose(s);
delete(s);
clear s;
```

Este código abre a porta serial, lê os dados em um loop enquanto atualiza o gráfico em tempo real e fecha a porta serial quando o gráfico é fechado. Certifique-se de substituir `'COM1'` pela porta serial que você está usando. Se você estiver em um sistema operacional diferente do Windows, pode ser necessário alterar o nome da porta serial.

Você não precisa de nenhuma toolbox adicional para fazer isso. Este é um exemplo básico e você pode expandi-lo conforme necessário, por exemplo, para lidar com diferentes formatos de dados ou adicionar mais funcionalidades ao gráfico.

---

**É fácil acrescentar um comando no Matlab para "pausar" a captura de dados e parar o gráfico?**

Sim, é relativamente fácil adicionar um comando para pausar a captura de dados e parar o gráfico. Você pode fazer isso adicionando uma verificação de flag dentro do loop while. Aqui está como você poderia modificar o código para incluir essa funcionalidade:

```matlab
% Configuração da porta serial
serialPort = 'COM1'; % Altere para a porta serial que você está usando
baudRate = 9600; % Taxa de transmissão

% Abra a porta serial
s = serial(serialPort, 'BaudRate', baudRate);
fopen(s);

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
```

Neste código, adicionei uma variável `paused` para controlar se a captura de dados está pausada ou não. Além disso, incluí uma verificação de teclado dentro do loop para verificar se a tecla 'p' foi pressionada para pausar e a tecla 'q' foi pressionada para parar completamente o loop e fechar o gráfico. Essas funcionalidades adicionais permitem que você controle melhor a captura de dados e a visualização em tempo real.

---

**HUm, faltou considerar que cada linha de dados recebido pela porta serial é organizada na forma de "colunas", com delimitadores usando ",", caracter TAB ou espaço em branco. Neste caso, 3 colunas. O que mudaria no código?**

Se os dados recebidos pela porta serial estão organizados em colunas com delimitadores como vírgula, tabulação ou espaço em branco, você precisará modificar a forma como os dados são processados dentro do loop. Aqui está uma versão modificada do código que considera essa estrutura de dados:

```matlab
% Configuração da porta serial
serialPort = 'COM1'; % Altere para a porta serial que você está usando
baudRate = 9600; % Taxa de transmissão

% Abra a porta serial
s = serial(serialPort, 'BaudRate', baudRate);
fopen(s);

% Inicialize o gráfico
figure;
hLine = plot(NaN, NaN, '-o'); % Inicialize o gráfico com dados vazios
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
        % Ler uma linha de dados da porta serial
        data = fgetl(s);
        
        % Se os dados não estiverem vazios
        if ~isempty(data)
            % Separar os dados usando delimitadores ',' ou tabulação ou espaço em branco
            parsedData = strsplit(data, {',', '\t', ' '});
            
            % Converter os dados para números de ponto flutuante
            parsedData = str2double(parsedData);
            
            % Se o número de elementos for igual ao número de colunas esperado
            if numel(parsedData) == 3
                x = 1:numel(parsedData); % Tempo
                set(hLine, 'XData', x, 'YData', parsedData); % Atualize o gráfico
                drawnow; % Atualize a interface gráfica
            end
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
```

Nesta versão modificada do código, eu uso a função `fgetl` para ler uma linha de dados da porta serial. Em seguida, uso a função `strsplit` para dividir os dados usando os delimitadores especificados (',', '\t' para tabulação e ' ' para espaço em branco). Os dados são então convertidos para números de ponto flutuante usando `str2double`. Finalmente, verificamos se o número de elementos corresponde ao número esperado de colunas antes de atualizar o gráfico.

---

**A rotina anterior poderia ser melhorada para ignorar linhas contendo caracteres alfabéticos? A idéia é o Matlab ignorar linhas que contenham dados alfanuméricos. Isto é, não se quer que o Matlab tente plotar linhas de dados contendo caracteres alfanuméricos.**

Sim, você pode modificar a rotina para ignorar linhas que contenham caracteres alfabéticos. Aqui está como você pode fazer isso:

```matlab
% Configuração da porta serial
serialPort = 'COM1'; % Altere para a porta serial que você está usando
baudRate = 9600; % Taxa de transmissão

% Abra a porta serial
s = serial(serialPort, 'BaudRate', baudRate);
fopen(s);

% Inicialize o gráfico
figure;
hLine = plot(NaN, NaN, '-o'); % Inicialize o gráfico com dados vazios
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
        % Ler uma linha de dados da porta serial
        data = fgetl(s);
        
        % Se os dados não estiverem vazios
        if ~isempty(data)
            % Verificar se a linha contém caracteres alfabéticos
            if any(isletter(data))
                % Ignorar a linha e continuar para a próxima iteração
                continue;
            end
            
            % Separar os dados usando delimitadores ',' ou tabulação ou espaço em branco
            parsedData = strsplit(data, {',', '\t', ' '});
            
            % Converter os dados para números de ponto flutuante
            parsedData = str2double(parsedData);
            
            % Se o número de elementos for igual ao número de colunas esperado
            if numel(parsedData) == 3
                x = 1:numel(parsedData); % Tempo
                set(hLine, 'XData', x, 'YData', parsedData); % Atualize o gráfico
                drawnow; % Atualize a interface gráfica
            end
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
```

Neste código, eu adicionei uma verificação usando `any(isletter(data))` para verificar se a linha contém caracteres alfabéticos. Se a linha contiver caracteres alfabéticos, o código usará `continue` para pular o restante do loop e passar para a próxima iteração, ignorando essa linha de dados. Isso garantirá que apenas linhas contendo dados numéricos sejam processadas e plotadas.

---

**E seria fácil criar uma interface gráfica com botão de "Pause" dentro do Matlab?**

Sim, é bastante simples criar uma interface gráfica com um botão de "Pause" dentro do MATLAB. Você pode usar a função `uicontrol` para criar botões e outros elementos de interface gráfica. Aqui está um exemplo de como você pode modificar o código para incluir um botão de pausa:

```matlab
% Configuração da porta serial
serialPort = 'COM1'; % Altere para a porta serial que você está usando
baudRate = 9600; % Taxa de transmissão

% Abra a porta serial
s = serial(serialPort, 'BaudRate', baudRate);
fopen(s);

% Inicialize o gráfico
figure;
hLine = plot(NaN, NaN, '-o'); % Inicialize o gráfico com dados vazios
xlabel('Tempo');
ylabel('Dados');
title('Dados em tempo real');
grid on;

% Botão de pausa
pauseButton = uicontrol('Style', 'pushbutton', 'String', 'Pause', 'Position', [20 20 50 20], 'Callback', @pauseCallback);

% Variável de controle de pausa
paused = false;

% Loop para ler e plotar dados em tempo real
while ishandle(hLine)
    % Ler os dados da porta serial se não estiver pausado
    if ~paused
        % Ler uma linha de dados da porta serial
        data = fgetl(s);
        
        % Se os dados não estiverem vazios
        if ~isempty(data)
            % Verificar se a linha contém caracteres alfabéticos
            if any(isletter(data))
                % Ignorar a linha e continuar para a próxima iteração
                continue;
            end
            
            % Separar os dados usando delimitadores ',' ou tabulação ou espaço em branco
            parsedData = strsplit(data, {',', '\t', ' '});
            
            % Converter os dados para números de ponto flutuante
            parsedData = str2double(parsedData);
            
            % Se o número de elementos for igual ao número de colunas esperado
            if numel(parsedData) == 3
                x = 1:numel(parsedData); % Tempo
                set(hLine, 'XData', x, 'YData', parsedData); % Atualize o gráfico
                drawnow; % Atualize a interface gráfica
            end
        end
    end
    
    % Verifique se uma tecla foi pressionada para parar o gráfico
    if kbhit
        key = getkey;
        if key == 'q' % Tecla 'q' para parar
            break;
        end
    end
end

% Fechar a porta serial quando o loop terminar
fclose(s);
delete(s);
clear s;

% Função de callback para o botão de pausa
function pauseCallback(hObject, eventdata)
    global paused;
    paused = ~paused; % Inverte o estado de pausa
end
```

Neste código, eu adicionei um botão de pausa usando a função `uicontrol`. O botão chama a função de callback `pauseCallback` quando é clicado. Dentro desta função de callback, a variável global `paused` é invertida, o que permite pausar e retomar a leitura dos dados da porta serial. Certifique-se de definir a posição e o tamanho do botão de pausa conforme necessário.

---

**Ah.. mas o botão de pause é para estar na mesma janela do gráfico.**

Entendi, você quer que o botão de pausa esteja na mesma janela do gráfico. Nesse caso, você pode usar a função `uicontrol` com `'Parent'` definido como a figura onde o gráfico está sendo plotado. Aqui está como você pode fazer isso:

```matlab
% Configuração da porta serial
serialPort = 'COM1'; % Altere para a porta serial que você está usando
baudRate = 9600; % Taxa de transmissão

% Abra a porta serial
s = serial(serialPort, 'BaudRate', baudRate);
fopen(s);

% Inicialize a figura e o gráfico
hFig = figure;
hLine = plot(NaN, NaN, '-o'); % Inicialize o gráfico com dados vazios
xlabel('Tempo');
ylabel('Dados');
title('Dados em tempo real');
grid on;

% Botão de pausa na mesma janela do gráfico
pauseButton = uicontrol('Style', 'pushbutton', 'String', 'Pause', 'Position', [20 20 50 20], 'Callback', @pauseCallback, 'Parent', hFig);

% Variável de controle de pausa
paused = false;

% Loop para ler e plotar dados em tempo real
while ishandle(hLine)
    % Ler os dados da porta serial se não estiver pausado
    if ~paused
        % Ler uma linha de dados da porta serial
        data = fgetl(s);
        
        % Se os dados não estiverem vazios
        if ~isempty(data)
            % Verificar se a linha contém caracteres alfabéticos
            if any(isletter(data))
                % Ignorar a linha e continuar para a próxima iteração
                continue;
            end
            
            % Separar os dados usando delimitadores ',' ou tabulação ou espaço em branco
            parsedData = strsplit(data, {',', '\t', ' '});
            
            % Converter os dados para números de ponto flutuante
            parsedData = str2double(parsedData);
            
            % Se o número de elementos for igual ao número de colunas esperado
            if numel(parsedData) == 3
                x = 1:numel(parsedData); % Tempo
                set(hLine, 'XData', x, 'YData', parsedData); % Atualize o gráfico
                drawnow; % Atualize a interface gráfica
            end
        end
    end
    
    % Verifique se uma tecla foi pressionada para parar o gráfico
    if kbhit
        key = getkey;
        if key == 'q' % Tecla 'q' para parar
            break;
        end
    end
end

% Fechar a porta serial quando o loop terminar
fclose(s);
delete(s);
clear s;

% Função de callback para o botão de pausa
function pauseCallback(hObject, eventdata)
    global paused;
    paused = ~paused; % Inverte o estado de pausa
end
```

Neste código, `hFig` armazena o identificador da figura onde o gráfico é plotado. O botão de pausa é criado com `Parent` definido como `hFig`, para que ele apareça na mesma janela do gráfico. Certifique-se de ajustar a posição e o tamanho do botão conforme necessário.

---

