% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright ï¿½ 2000 by John Wiley & Sons, Inc.
%
% Chapter 11: Design via Frequency Response
%
% (ch11p1) Example 11.1: We can design via gain adjustment on the Bode plot using 
% MATLAB. You will input the desired percent overshoot from the keyboard. MATLAB 
% will calculate the required phase margin and then search the Bode plot for that 
% phase margin. The magnitude at the phase-margin frequency is the reciprocal of 
% the required gain. MATLAB will then plot a step response for that gain. Let us 
% look at Example 11.1 in the text.
%
% Atualizado por fpassold em 21.10.2019

disp('(ch11p1) Example 11.1 - Controlador Proporcional')       % Display label.

%% ---- Entre com a função transferência da planta no bloco abaixo
%
numg=[100];                         % Define numerator of G(s).
deng=poly([0 -36 -100]);            % Define denominator of G(s).
G=tf(numg,deng)                     % Create and display G(s).

%% Seguem cálculos associados com o projeto
pos=input('Input %OS ?: ');          % Input desired percent overshoot.
z=(-log(pos/100))/(sqrt(pi^2+log(pos/100)^2));
                                    % Calculate required damping ratio.
fprintf('\nRequired damping ratio (zeta): %6.4f\n', z)
Pm=atan(2*z/(sqrt(-2*z^2+sqrt(1+4*z^4))))*(180/pi);
                                    % Calculate required phase margin.
fprintf('Required phase margin, Pm = %7.4f\n', Pm)

%% Criando vetores associados com Diagrama de Bode
w=0.1:0.01:100;                     % Set range of frequency from 0.01 to 
                                    % 1000 in steps of 0.01.
[Mag,P]=bode(numg,deng,w);          % Gets Bode data.

figure;                             % Plot Bode diagram
subplot(2,1,1)
h1 = semilogx(w, 20.*log10(Mag));   % h1: current figure handle
fig1 = gcf; % current figure handle
grid
title('Open Loop Freq. Response')
ylabel('Magnitude (dB)');

%% ajustando propriedades da figura
set(h1,'LineWidth', 2);
ax = gca; % current axes
ax.FontSize = 14;

subplot(2,1,2)                  % Diagrama de fase
h2 = semilogx(w, P);
grid
ylabel('Phase (deg)')
xlabel('Frequency (rad/sec)')

%% ajustando propriedades da figura
set(h2,'LineWidth', 2);
ax = gca; % current axes
ax.FontSize = 14;
escY=min(P);

Ph=-180+Pm;                         % Calculate required phase angle.
fprintf('Required phase angle: %7.2f^o\n', Ph)
u=length(P);
for k=1:1:u;                        % Search Bode data for required phase
                                    % angle.
  if P(k)-Ph<=0;                    % If required phase angle is found,
                                    % find the value of 
    M=Mag(k);                       % magnitude at the same frequency.
    fprintf('Found Pm at w = %5.2f (rad/s)\n', w(k))
    fprintf('with magnitude = %5.2f dB (%5.2g)\n', 20*log10(M), M)
    new_K=1/M;                      % Calculate the required gain.
    subplot(2,1,2)
    hold on
    % Marca no diagrama o ponto onde ocorre a Margem de Fase, Pm
    semilogx([w(1) w(u)], [-180 -180], 'k-.', 'LineWidth', 2)   % linha guia -180o
    semilogx([w(k) w(k)], [-180 Ph], 'm-', 'LineWidth', 6)     % mostra Pm
    aux=[num2str(Pm,'%4.1f') '^o'];
    aux2=-180+Pm/2;
    text((w(k)), aux2, aux, 'FontSize',14)    
    
    semilogx([w(k) w(k)], [Ph  0], 'm--', 'LineWidth', 2)
    semilogx([w(1) w(u)], [P(k) P(k)], 'm--', 'LineWidth', 2)
    aux=[num2str(w(k),'%3.2f') ' rad/s'];
    text((w(k)),0 , aux, 'FontSize',14)
    subplot(2,1,1)
    hold on
    % Marca no diagrama do ganho, os pontos que correspondem à Pm
    semilogx([w(k) w(k)], [0 20.*log10(Mag(k))], 'm-', 'LineWidth',6)  % Mostra altura ajuste do ganho
    semilogx([w(k) w(k)], [20.*log10(Mag(k)) 20.*log10(Mag(u))], 'm--', 'LineWidth',2)
    semilogx([w(1) w(u)], [20.*log10(Mag(k)) 20.*log10(Mag(k))], 'm--', 'LineWidth',2)
    aux=[num2str(-20*log10(M),'%5.2f') ' dB'];
    aux2=20.*log10(Mag(k))/2;
    text((w(k)), aux2, aux , 'FontSize',14)
    break                           % Stop the loop.
  end                               % End if.
end                                 % End for.

fprintf('Then, required K = %6.2f\n', new_K)
k_final=new_K;
fprintf('Then, final required K = %6.2f\n', k_final)
T=feedback(k_final*G,1);                  % Find T(s) using the calculated K.
figure; step(T);                          % Generate a step response.
title(['Closed-Loop Step Response for K= ',num2str(k_final)]) % Add title to step response.
ax = gca; % current axes
ax.FontSize = 14;

%% verificando diagrama de Bode compensado
adjusted_g=k_final*G;
figure; bode(G,adjusted_g)
hold on;    % sobrepondo dados de margens
margin(adjusted_g)