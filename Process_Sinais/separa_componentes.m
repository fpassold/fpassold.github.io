% Isola os compontes mais relevantes de uma FFT (amgnitude), comparando
% a maior amplitude obtida e separado amplitudes que alcançam até certo 
% percentual deste valor
% Fernando Passold, 04/05/2024

u = length(P1);
maximo=max(P1);
limiar=2;           % threshould em porcentagem
fprintf('Entre com limiar para separação em % (%.2f): ', limiar);
reply=input('? ');
if ~(isempty(reply))
    limiar=reply;
end 

threshould=maximo*(limiar/100);
P1_aux=zeros(u,1);  % inicializa outro vetor que conterá copia dos valores selecionados

% se não existe vetor das fases, cria:
if ~(exist('Y_phase','var'))
    Y_phase = angle(Y);  % calcula o ângulo (defasagem) em cada freq. mas em radianos
    Y_phase_deg = Y_phase.*(180/pi); % transforma de rad para graus
end

fprintf('Componentes relevantes:\n');
fprintf('| #  | Freq (Hz) | Amplitude |  %%  | Fase (graus) |\n');
fprintf('|---:|:----------|----------:|:---:|-------------:|\n');
maior_freq=f(1);
cont=0;
for i=1:u
    if (P1(i)>=threshould)
        cont=cont+1;
        per=(P1(i)*100)/maximo;
        P1_aux(i)=P1(i);
        fprintf('| %u | %.2f | %.5f | %.1f | %.2f |\n', cont, f(i), P1(i), per, Y_phase_deg(i)); 
        % Seperando dados para eventual futura série de Fourier
        maior_freq=f(i);
        g(cont)=P1(i);
        ff(cont)=f(i);
        phase(cont)=Y_phase(i);
    end
end
fprintf('Encontrados %u componentes\n', cont)

figure;
stem(f,P1_aux)
title('Espectro do sinal y(t)')
xlabel('Frequência (Hz)')
ylabel('Magnitude')
axis([0 maior_freq*1.1 0 maximo*1.1])
