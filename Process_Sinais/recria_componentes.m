% Trabalha com componentes separados pelo script 'separa_componentes.m'
% e com base neles, tenta recriar o sinal sonoro, dentro do intervalo
% especificado pelo usuário
% Fernando Passold, 04/05/2024

duracao=0.87;
fprintf('Recriar sinal por quanto tempo (%.4f seg): ', duracao);
reply=input('? ');
if ~(isempty(reply))
    duracao=reply;
end 

tt=0:1/Fs:duracao; % cria outro vetor tempo
y2=zeros(length(tt),1);     % inicializa vetor y2 = sinal recriado
col=0;
fprintf('Recriando sinal:\n');
maior=0; menor=0;
for i=1:length(tt)
    % t = tt(i) tempo (valor em segundos);
    sum=0;      % soma das amplitudes em cada frequencia
    for j=1:length(P1) % varia o componente por frequencia
        if (P1_aux(j)>0)
            % existe componente válido em certa frequencia
            % freq atual = f(j)
            sum=sum+P1_aux(j)*sin(2*pi*f(j)*tt(i)+Y_phase(j));
        end
    end
    y2(i)=sum;
    col=col+1;
    fprintf('.');
    if (col>60)
        per=(i/length(tt))*100;
        fprintf(' %.2f%%\n', per); 
        col=0;
    end    
    % Descobrindo valor max e min
    if (sum>maior)
        maior=sum;    % detectando maior amplitude para escalonar sinal depois
    end
    if (sum<menor)
        menor=sum;
    end
end

% Escalonando sinal max --> 1,0
fprintf('\nEscalonando sinal...\n')
fator_escala=1/maior;
if (abs(menor)>maior)
    fator_escala=1/menor;
end
y2 = y2.*fator_escala;

figure; plot(tt,y2);
title('Sinal Recriado')
xlabel('Tempo (seg)');

sound(y2,Fs)    % torna audível