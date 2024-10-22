% Example 9.4 (pag. 483)
% Este script resolve o exemplo 9.5:
% PID Controller Design, do livro:
% Nise, Norman S., Control System Engineering,
% 6th ed. 2011, John Wiley & Sons, Inc. 
%
% Exige que o usuario edite as primeiras linhas
% contendo as variaveis 'num' e 'den' referentes
% a funcao transferencia da planta para a qual
% esta' sendo projetado o PID
%
% Note que seguindo o exemplo 9.5; primeiro e' realizado
% o projeto do Controlador Proporcional para ter
% acesso ao tempo de pico do mesmo. Este valor e'
% reduzido entao em 2/3 para o projeto do PID
%
% O restante do programa com excessao das variaveis
% 'num' e 'den' e' interativo.
% Varias janela graficas de RL serao abertas, o usuario
% deve realizar o zoom na regiao de interesse, orientado
% pelas mensagens geradas por este script durante sua
% execucao.

% Fernando Passold, verificado em 14.06.2021

format compact
disp ('Este script resolve o exemplo 9.5:');
disp ('PID Controller Design, do livro:')
disp ('Nise, Norman S., Control System Engineering,');
disp ('6th ed. 2011, John Wiley & Sons, Inc.'); 
% Recomenda-se executar as 2 linhas abaixo:
% clear all % apaga todas las variables anteriores
% close all % fecha todas las figuras

num=[1 8];
den=poly([-3 -6 -10]);
g=tf(num,den);
disp('Planta a ser compensada:')
zpk(g)

sobre=input('Maximo percentual overshoot tolerado (%OS): ? ');
% calculando zeta
zeta=(-log(sobre/100))/(sqrt(pi*pi+(log(sobre/100))^2));
fprintf('Fator de amortecimento (zeta): %.4f\n\n', zeta)

% plotando RL
fig = figure(); rlocus(g)
sgrid(zeta,0)
title(['Projeto Controlador Proporcional (%OS=', num2str(sobre), ...
   '%)'])

fprintf ('Observe o RL da FTMA(s) do Contr. Prop. + Planta... (Figure %i)...\n', fig.Number);
% disp('Do a zoom over the area of interest and press any bottom to continue...')
disp ('Realize um zoom sobre a area de interesse e');
disp ('pressione qualquer tecla para continuar ')
pause

% selecionando onto no RL...
figure(fig.Number); % voltando o foco para a janela correta
[k,poles]=rlocfind(g)

% Calculando t_s original...
t_s=4/abs(real(poles(2)));
% fprintf('Estimated settiling time (uncompensated system): %.4f\n', t_s)
fprintf('Estimando tempo de assentamento, t_s: %.4f\n', t_s)
t_p=pi/abs(imag(poles(2)));
% fprintf('Estimated peak time (uncompensated system): %.4f\n', t_p)
fprintf('Estimando tempo do pico, t_p: %.4f\n\n', t_p)

% calculando nuevo t_p?=t_p*2/3
new_t_p=t_p*2/3;
% fprintf('New peak time (desired) %.4f\n', new_t_p)
fprintf('Novo tempo de tipo (desejado), t_p: %.4f\n\n', new_t_p)
theta=acos(zeta);
fprintf('theta (cos(zeta)): %.4f^o\n', theta*180/pi)
% theta*180/pi  % se acordar que MATLAB trabaja en rad...
fprintf('180^o-theta: %.4f^o\n\n', 180-theta*180/pi)

% determinando parte real e imagin?ria para p?los desejados de MF
new_omega=pi/new_t_p;
% fprintf('Desired imaginary part of dominant pole (system compensated): %.4f\n', new_omega)
% fprintf('Parte imagin?ria para p?los de MF desejado: w_d: %.4f\n', new_omega)
new_sigma=new_omega/tan(theta);
% fprintf('Desired real part of dominant pole (system compensated): %.4f\n', new_sigma)
% fprintf('Parte real para polos de MF desejados: sigma: %.4f\n', new_sigma)

% disp ('So... Desired dominant pole (system compensated, closed looped): ')
fprintf ('Polos de MF desejados em: s = %.4f +j%.4f\n\n', -new_sigma, new_omega )
aux=[-new_sigma+j*new_omega];

fig = figure; 
rlocus(g); hold on; sgrid(zeta,0);
plot(real(aux),imag(aux),'mx')
plot(real(aux),-imag(aux),'mx')
plot([real(aux) 0],[imag(aux) imag(aux)],'m:')
plot([real(aux) real(aux)],[imag(aux) -imag(aux)],'m:')
plot([real(aux) 0],[-imag(aux) -imag(aux)],'m:')

% title('RL + Desired location of dominant pole (PD compensation phase):')
title('RL + Polos Desejados de MF (Etapa do PD)')

% considerando el sumatorio de los angulos...
% Sum(th_ceros)-Sum(th_polos)=180*(2*i+1)

open_poles=roots(den);
[num_poles aux2]=size(open_poles);
sum=0;
% disp ('Angle Contribution of each pole of the open loop system')
disp ('Contribuicoes angulares dos polos do sistema em malha-aberta:')

% Plota o gr?fico e sobrep?e no gr?fico as informa??es angulares
fig = figure();
rlocus(g); hold on; sgrid(zeta,0);
plot(real(aux),imag(aux),'mx')
plot(real(aux),-imag(aux),'mx')
plot([real(aux) 0],[imag(aux) imag(aux)],'m:')
plot([real(aux) real(aux)],[imag(aux) -imag(aux)],'m:')
plot([real(aux) 0],[-imag(aux) -imag(aux)],'m:')

% fprintf('No. Pole = Pole_position --> Angle Contribution\n')
for i=1:num_poles
    % open_poles(i)
    x(i)= -new_sigma -real(open_poles(i));
    y(i)=new_omega;
    th(i)=atan2(y(i),x(i)); % determinando contribuicao de cada polo
    sum=sum+th(i);
    % th(i)*180/pi
    % fprintf('No. Pole : Pole : Angle Contribution\n')
    fprintf('p(%1i) = %g --> %.4f^o\n', i,open_poles(i),th(i)*180/pi)
end
% fprintf('Sum of angular poles positions: %.4f^o\n', sum*180/pi)
fprintf('Soma das contribuicoes dos polos: %.4f^o\n\n', sum*180/pi)

% Atualiza gr?fico com informa??es angulares dos p?los:
% desenhando contribuicoes dos polos
for i=1:num_poles
    plot([real(open_poles(i)) -new_sigma], [imag(open_poles(i)) new_omega],'c:')
    text(real(open_poles(i))*1.05,imag(open_poles(i))*1.05,num2str((th(i)*180/pi)))
end

% considerando os zeros da planta
zeros=roots(num);
[num_zeros aux2]=size(zeros);
% fprintf('Angle Contribution of each zero of the system\n')
fprintf('Contribuicoes angulares dos zero do sistema em malha-aberta:\n')
for i=1:num_zeros
    x(i)=-new_sigma-real(zeros(i));
    y(i)=new_omega;
    th(i)=atan2(y(i),x(i));
    sum=sum-th(i);
    fprintf('z(%1i) = %.4g --> %.4f^o\n', i, zeros(i), th(i)*180/pi)
end

% fprintf('Sum of total angular contributions: %.4f^o\n', sum*180/pi)
fprintf('\nSomatorio total das contribuicoes angulares (polos e zeros): %.4f^o\n\n', sum*180/pi)
final_angle=abs(pi-sum);
% fprintf('Final Resulting angle for the PD pole-zero: %.4f^o\n', final_angle*180/pi)
fprintf('Angulo resultante para o zero do PD: %.4f^o\n', final_angle*180/pi)
zc=-new_sigma+new_omega/tan(final_angle);

% desenhando contribuicoes dos zeros
for i=1:num_zeros
    plot([real(zeros(i)) -new_sigma], [imag(zeros(i)) new_omega],'g:')
    text(real(zeros(i))*1.05,imag(zeros(i))*1.05,num2str((th(i)*180/pi)))
end
% plotando a linha ate o zero do PD (resultado da contribuicao angular)
plot(zc,0,'ro')
plot([-zc -new_sigma],[0 new_omega],'b:');
text(-zc*1.05,0.05,num2str((final_angle*180/pi)))

% fprintf('Position of PD zero: %.4f^o\n', zc)
fprintf('Posicao do zero do PD: em s = %.4f\n', -zc)

num_c=[1 zc];
den_c=1;
c=tf(num_c,den_c);
% disp('So... the PD controller:')
disp('Equacao do PD (variavel "c"):')
zpk(c)

% title('Contributing angles (PD compensation phase):')
title('Contribuicoes angulares (Etapa projeto PD):')

% formando nuevo sistema - a?adindo PD:
cg=series(g,c); % da igual fazer: cg=c*g
% disp('PD Controller + System:')
disp('Levantando RL da FTMA(s) do sistema com o PD...')
zpk(cg);
% comprovando respuesta transitoria
fig = figure;
rlocus(cg); hold on; sgrid(zeta,0);
% plotando polos desejados de MF
plot([-new_sigma -new_sigma],[new_omega -new_omega],'m*')
aux2=['t_p=' num2str(new_t_p)];
text(-new_sigma*1.05,new_sigma*0.05,aux2)
% title('RL of system + PD (1st-stage design)')
title('RL da FTMA(s) com PD (1a-etapa projeto)')

fprintf ('Observe o RL da FTMA(s) do PD + planta (Figure %i)...\n', fig.Number);
% disp('Do a zoom over the area of interest and press any bottom to continue...')
disp ('Realize um zoom sobre a area de interesse e');
disp ('pressione qualquer tecla para continuar ')
pause

figure(fig.Number); % voltando foco para a janela correta
[K_pd,poles_pd]=rlocfind(cg)
% title('RL of system + PD (1st-stage design)')
title('RL da FTMA(s) com PD (1a-etapa projeto)')

PD = K_pd*c;
disp('Equacao do PD:')
zpk(PD)

% Fechando malha com ganho escolhido para o PD
% Verificar t_p atingido...
t_pd=feedback(K_pd*cg,1); % variavel original adotada por NISE
% disp('Lazo cerado Sistema con PD:')
% zpk(t_pd)

% malha fechada para sistema com Contr. Proporcional
t_g=feedback(k*g,1);
figure; step(t_g,t_pd) % ltiview(t_g,t_pd)
legend ('Contr. Prop.', 'PD');

% Acrescentando o PI (polo na origem e zero)...

zero_PI = -0.5; % valor arbitrado originalmente por NISE
% Neste ponto do codigo, NISE poderia ter incorporado contribuicao angular
% para determinar posicao exata do zero do PI
fprintf ('Selecione uma posicao para o zero do PI (em: %g <= s < 0) [%g]', max(pole(g)), zero_PI);
aux = input (': ? ');
if ~(isempty(aux))
    zero_PI = aux;
end
num_PID=conv([1 zc],[1 -zero_PI]); % note que o zero do PD ja esta sendo considerado
den_PID=([1 0]);
PID=tf(num_PID,den_PID);
% disp('Complete PID transfer function:')
disp('Equacao do PID (ainda sem ganho):')
zpk(PID)

% deduzindo FTMA(s) com PID
PIDg=PID*g;
% disp('PID + Plant transfer function:')
disp('FTMA(s) do PID + Planta (variavel "PIDg"): ')
zpk(PIDg)

fig = figure(); 
rlocus(PIDg); hold on; zgrid(zeta,0)
% plotando polos desejados de MF
plot([-new_sigma -new_sigma],[new_omega -new_omega],'m*')
title('RL FTMA(s): PID + planta')

% disp('Do a zoom over the area of interest and press any bottom to
% continue...')
fprintf ('Observe o RL da FTMA(s) do PID + planta (Figure %i)...\n', fig.Number);
disp ('Realize um zoom sobre a area de interesse e');
disp ('pressione qualquer tecla para continuar ')
pause

figure(fig.Number); 
[k_PIDg,poles_PIDg]=rlocfind(PIDg)

disp('Equacao final (completa) do PID (variaval "PID2"):');
PID2 = k_PIDg*PID
% zpk(PID2);
[num_PID,den_PID] = tfdata(PID2, 'v');
Kp = num_PID(2)
Ki = num_PID(3)
Kd = num_PID(1)

t_PIDg=feedback(k_PIDg*PIDg,1); % fechando malha com PID
% disp('Sistema PID + Planta, lazo cerrado:')
% zpk(t_PIDg)

figure; step (t_g,t_pd,t_PIDg); % ltiview(t_g,t_pd,t_PIDg)
legend('Contr. Prop.', 'PD', 'PID');
