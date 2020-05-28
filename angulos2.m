% programa para determinar contribui??o de ?ngulos
% Fernando Passold, em 16/out/2015
% Baseado em "example_9_4.m" de /UCV/Control/ (2009)
% Lead Compensator Desing (NISE)
%
clc
fprintf('Lead Controller Design\n');
fprintf('In this version you should arbitrate the initial position of the pole of C(z)\n\n');
% entrando com dados da planta, no plano-s (transformada de Laplace):
% num=1;
% den=poly([-10 -2 -1]); % <-- estudo de caso
% den=42*poly([-0.6 -0.4 -0.1]);
% num=2.5*[1 4];
% den=poly([ -5  -2  -1 ]);
% G=tf(num,den);
% G=tf([1634.6],poly([-30.96 -9.261])); % prova de 2018.1
fprintf('Plant (in s-plan) informed, G(s):');
zpk(G)
% T=0.5; % informando per?odo de amostragem
% T=0.05;
% T = 12.5E-3; % prova 2018.1
fprintf('Sampling time informed: T=%g\n', T); 
BoG=c2d(G, T);
fprintf('Plant in discrete form, BoG(z):');
zpk(BoG)
[numd, dend, aux] = tfdata(BoG,'v');
OS=input('Maximum overshoot desired (%OS), in %: ? ');
% calculando fator de amortecimento em fun??o de %OS:
zeta=(-log(OS/100))/(sqrt(pi^2+(log(OS/100)^2)));
fprintf('zeta (damping factor) should be: %6.4f\n', zeta)
ts_d=input('Enter desired settling time, t_s: ? ');
% determinando wn em fun??o de zeta e ts:
wn=4/(zeta*ts_d);
fprintf('\nIt results in the natural oscillation frequency, wn = %7.4f (rad/s)\n', wn);
% calculando a posi??o desejado para p?los de malha-fechada:
% polos_MF em sigma +- jwd
sigma=wn*zeta;
wd=wn*sqrt(1-zeta^2);
fprintf('The MF poles (in the s-plane) should be located in:\n%6.4f +/- j%6.4f\n', ...
    sigma, wd);
% mas nosso controlador est? sendo projetado no mundo "digital" (plano-z),
% ent?o aplicando a defini??o da transformada Z: z = e^{-Ts}:
polo_MFs=sigma - j*wd;
polo_MFz=exp(-T*polo_MFs);
new_sigma = real(polo_MFz);
new_omega = abs(imag(polo_MFz));
fprintf('Localization of MF poles in the z-plane should be:\nz = %.4f +/- j%.4f\n', ...
    new_sigma, new_omega)

% usu?rio deve agora arbitrar uma posi??o para o p?lo do controlador por
% avan?o de fase:
polo_c=input('\nEnter the position of the controller pole (z-plane): ? ');
% montando controlador digital (sem o zero, ? ser calculando usando
% contribui??o angular
num_c=1;
den_c=poly(polo_c);
%fprintf('O controlador ficaria algo como (sem o zero ainda):');
C=tf(num_c, den_c, T);
% zpk(C)
fprintf('Working with the temporary FTMA(z)...\n');
ftma=C*BoG;
% zpk(ftma)
[num,den,aux]=tfdata(ftma,'v');
% determinando n?mero de p?los de MA:
open_poles = roots(den);
fprintf('Open poles = %g\n', open_poles)
[num_poles aux] = size(open_poles);
% determinando n?mero de zeros de MA:
open_zeros = roots(num);
fprintf('Open zeros = %g\n', open_zeros)
[num_zeros aux] = size(open_zeros);

% Iniciando c?lculos e gr?ficos relacionados com contribui??o angular:
figure;
% plotando o c?rculo unit?rio (refer?ncia):
th=0: (2*pi)/360 : 2*pi;
x=1*cos(th);
y=1*sin(th);
plot(x,y,'k:');
axis ('equal');
hold on
% plotando em cor azul p?los e zeros de BoG(z)
[num_BoG, den_BoG, aux] = tfdata(BoG, 'v');
polos_BoG=roots(den_BoG);
zeros_BoG=roots(num_BoG);
plot(real(zeros_BoG), imag(zeros_BoG),'bo'); % zeros de BoG(z)
plot(real(polos_BoG), imag(polos_BoG),'bx'); % p?los de BoG(z)
% plotando em cor vermelha o p?lo de C(z):
plot(real(polo_c), 0,'rx');
% plotando posi??o desejado para p?lo de MF:
plot(real(polo_MFz), imag(polo_MFz),'r+');

% Iniciando c?lculos das contribui??es angulares.

% linha pontilhada ligando p?los de MA ao p?lo de MF
for i=1:num_poles,
    plot(real([open_poles(i) polo_MFz]), imag([open_poles(i) polo_MFz]),'k:') % tra?a linhas pontilhadas ligando cada p?lo de MA ao p?lo desejado em MF
end
sump = 0; % soma angulos dos p?los (contribui??o angular p?los)
fprintf('Angular contribution of each pole in the z-plane:\n')
sum_aux=0;
for i=1:num_poles
    x(i) = real(polo_MFz) - real(open_poles(i));
    y(i) = imag(polo_MFz) - imag(open_poles(i));
    theta(i) = atan2(y(i), x(i)); % determinando la contribuici?n de cada polo
    theta_deg(i)=(theta(i)*180)/pi; % angulo em graus
    sump = sump + theta(i);
    fprintf (' p%1i = %.4f --> %.2f^o\n', i, open_poles(i), theta_deg(i))
    sum_aux=sum_aux+sqrt(x(i)^2+y(i)^2); % calcula dist?ncias entre p?los
end
avg=(sum_aux/num_poles)/4; % valor m?dio raio arco das crontibui??es angulares
% plotando as contribui??es angulares:
for i=1:num_poles,
    p1=[real(open_poles(i))+avg; 0]; % matriz 2 x 1; [x; y]
    p2=[real(open_poles(i))+avg*cos(theta(i)); avg*sin(theta(i)) ];
    center=[real(open_poles(i)); 0];
    arc(p1, p2, center);
    aux=num2str(theta_deg(i),'%7.2f'); % transforma n?mero em string
    text(real(open_poles(i))+(avg/2)*cos( (theta(i)/1.5) ), ...
        (avg/2)*sin( (theta(i)/1.5) ), [aux '^o']);
end
fprintf('Sum of angular contribution of poles: %.2f^o\n', sump*180/pi)

n=input('Check the figure window -> Paused (enter to continue)...','s');

% linha pontilhada ligando zeros de MA ao p?lo de MF
for i=1:num_zeros,
    plot(real([open_zeros(i) polo_MFz]), imag([open_zeros(i) polo_MFz]),'k:') % tra?a linhas pontilhadas ligando cada p?lo de MA ao p?lo desejado em MF
end
fprintf('\nAngular contribution of each zero in the z-plane:\n')
sumz=0;
for i=1:num_zeros
    x(i) = real(polo_MFz) - real(open_zeros(i));
    y(i) = imag(polo_MFz) - imag(open_zeros(i));% new_omega;
    theta(i) = atan2(y(i), x(i)); % determinando la contribuici?n de cada zero
    theta_deg(i)=(theta(i)*180)/pi; % angulo em graus
    sumz = sumz + theta(i);
    fprintf (' z%1i = %.4f --> %.2f^o\n', i, open_zeros(i), theta_deg(i))
end
% plotando as contribui??es angulares dos zeros
for i=1:num_zeros,
    p1=[real(open_zeros(i))+avg; 0]; % matriz 2 x 1; [x; y]
    p2=[real(open_zeros(i))+avg*cos(theta(i)); avg*sin(theta(i)) ];
    center=[real(open_zeros(i)); 0];
    arc(p1, p2, center);
    aux=num2str(theta_deg(i),'%7.2f'); % transforma n?mero em string
    text(real(open_zeros(i))+(avg/2)*cos( (theta(i)/1.5) ), ...
        (avg/2)*sin( (theta(i)/1.5) ), [aux '^o']);
end
fprintf('Sum of angular contribution of zeros: %.2f^o\n', sumz*180/pi)

final_angle = abs(pi - sump + sumz);
fprintf('Final angle for the zero of C(z): %.4f^o\n', final_angle*180/pi)

% pode-se determinar agora a posi??o para o zero ou p?lo do Lead
fprintf('\nOk, determining the position for zero of C (z)...\n')
zc=-(new_omega/tan(final_angle)-new_sigma); 
fprintf('Final position for the Lead zero: z_c=%.4f\n', zc)
fprintf('Updating final RL graph...\n');
% plotando o gr?fico com o zero resultante:
plot(real(zc), imag(zc),'ro');
plot(real([zc polo_MFz]), imag([zc polo_MFz]),'r--')
p1=[real(zc)+avg; 0]; % matriz 2 x 1; [x; y]
p2=[real(zc)+avg*cos(final_angle); avg*sin(final_angle) ];
center=[real(zc); 0];
arc(p1, p2, center);
aux=num2str( (final_angle*180/pi) ,'%7.2f'); % transforma n?mero em string
text(real(zc)+(avg/2)*cos( (final_angle/1.5) ), ...
(avg/2)*sin( (final_angle/1.5) ), [aux '^o']);
num_c=poly(zc);
C=tf(num_c, den_c, T);
fprintf('The Lead controller final result is (variable C):');
zpk(C)
% Verificando...
figure;
ftma=C*BoG;
rlocus(ftma);
hold on
zgrid(zeta, wn*T);
% plotando posi??o desejado para p?lo de MF:
plot(real(polo_MFz), imag(polo_MFz),'r+');
