% programa para Projeto de Lead atrav??s de
% contribui????o angulas
% Fernando Passold, em 23/11/2019, revisado em 30/05/2020
% Baseado em "example_9_4.m" de /UCV/Control/ (2009)
% Lead Compensator Desing (NISE)
%
% Exige como entrada (para funcionar), as seguintes vari??veis:
%
% G=tf( , )
%
% Gera texto na tela compat??vel com Markdown

fprintf('\n\n\n');
fprintf('## Lead Controller Design\n\n');
fprintf('In this version you should arbitrate the initial position of the ZERO of C(z)\n\n');

% entrando com dados da planta, no plano-s (transformada de Laplace):
% num=1;
% den=poly([-10 -2 -1]); % <-- estudo de caso
% den=42*poly([-0.6 -0.4 -0.1]);
% num=2.5*[1 4];
% den=poly([ -5  -2  -1 ]);
% G=tf(num,den);
% G=tf([1634.6],poly([-30.96 -9.261]));

fprintf('Plant (in s-plane) informed, G(s):\n\n```matlab ');
zpk(G)
fprintf('\b``` \n\n');
% [num, den] = tfdata(G,'v');
OS = input('Maximum overshoot desired (*%OS*), in %: ? ');
% calculando fator de amortecimento em fun??o de %OS:
zeta = (-log(OS/100))/(sqrt(pi^2+(log(OS/100)^2)));
fprintf('\nThe damping factor should be: $\\zeta = %6.4f$\n', zeta)
new_t_s = input('\nEnter desired settling time, $t_s$: ? ');
% determinando wn em fun??o de zeta e ts:
wn = 4/(zeta*new_t_s);
fprintf('\nIt results in the natural oscillation frequency, $w_n = %7.4f$ (rad/s)\n\n', wn);
% calculando a posi??o desejado para p?los de malha-fechada:
% polos_MF em sigma +- jwd
sigma = -wn*zeta; % new_sigma= 4/new_t_s;
wd = wn*sqrt(1-zeta*zeta);
% alpha=acos(zeta);
% new_omega=new_sigma*tan(alpha); % wd
wd = wn*sqrt(1-zeta^2);
fprintf('The MF poles (in the s-plane) should be located in:\n$%6.4f \\pm j%6.4f$\n', ...
    sigma, wd);

clear j; % n??o pode existir vari??vel j na pr??xima linha
% evitar que alguma variavel j atrapalhe atribui????o para n??mero complexo
polos_MF= [sigma+j*wd sigma-j*wd]; % polos MF desejados

%% usu??rio arbitra posi????o inicial do zero.
% PD (ideal) --> C(s)=K(s+z_c)
% Lead --> C(s)=\dfrac{K(s+z_c)}{(s+p_c)}

zero_c=0; % PD! zero_c=1 <-- no plano-z !
fprintf('\nEnter the position of the controller ZERO ($z_c = %6.4f$)', zero_c); 
aux=input(': ? ');
if (aux==[])
    zero_c=0; % PD
else
    zero_c=aux;
end

% montando controlador (sem o p??lo, a ser calculando usando
% contribuicao angular
num_c=poly(zero_c); % <-- v??lido para Lead (n??o para PD)
% den_c=poly(polo_c); <-- caso o usu??rio arbitrasse o polo do Lead
den_c=1;
%fprintf('O controlador ficaria algo como (sem o zero ainda):');
disp('```matlab')
C_aux=tf(num_c, den_c)
disp('```');
% zpk(C_aux)
% fprintf('Working with the temporary FTMA(s)...\n');
ftma_aux=C_aux*G;
% zpk(ftma_aux)

% descobrindo polos e zeros de MA
open_poles = pole(ftma_aux);
% fprintf('Open poles = %g\n', open_poles)
[num_poles aux] = size(open_poles);

open_zeros = zero(ftma_aux);
% fprintf('Open zeros = %g\n', open_zeros)
[num_zeros aux] = size(open_zeros);

% Iniciando c?lculos e gr?ficos relacionados com contribui??o angular:
figure;

% plotando em cor azul p?los e zeros de BoG(z)
% [num_G, den_G] = tfdata(G, 'v');
polos_G = pole(G); % roots(den_G);
zeros_G = zero(G); % roots(num_G);
plot(real(zeros_G), imag(zeros_G), 'bo', 'MarkerSize', 10 ); % zeros de G(z)
hold on
plot(real(polos_G), imag(polos_G), 'bx', 'MarkerSize', 10 ); % p?los de G(z)

% plotando em cor vermelha o p?lo de C(z):
% plot(real(polo_c), 0,'rx');
plot(real(zero_c), 0, 'ro', 'MarkerSize', 10 );

% plotando posi??o desejado para p?los de MF:
plot(polos_MF, 'm+', 'MarkerSize', 10);

title('RL + Desired location of dominant pole (system being compensated):')
% Iniciando c?lculos das contribui??es angulares.

% linha pontilhada ligando p?los de MA ao p?lo de MF
for i=1:num_poles,
    plot(real( [open_poles(i) polos_MF(1)] ), imag( [open_poles(i) polos_MF(1)] ), 'k--') % , 'LineWidth', 1.5) 
    % tra?a linhas pontilhadas ligando cada p?lo de MA ao p?lo desejado em MF
end

sump = 0; % soma angulos dos p?los (contribui??o angular p?los)
fprintf('\nAngular contribution of each pole in the s-plane:\n\n')
sum_aux=0;
for i=1:num_poles
    x(i) = real(polos_MF(1)) - real(open_poles(i)); % verificar se n??o volta acrescentar um "offset"...
    y(i) = imag(polos_MF(1)) - imag(open_poles(i));
    theta(i) = atan2(y(i), x(i)); % determinando la contribuici?n de cada polo
    theta_deg(i)=(theta(i)*180)/pi; % angulo em graus
    sump = sump + theta(i);
    fprintf ('$p_%1i = %g \\rightarrow %.2f^{o}$\n', i, open_poles(i), theta_deg(i))
    sum_aux=sum_aux+sqrt(x(i)^2+y(i)^2); % calcula dist?ncias entre p?los
end
avg=(sum_aux/num_poles)/4; % valor m?dio raio arco das crontibui??es angulares
% plotando as contribui??es angulares:
for i=1:num_poles,
    p1=[real(open_poles(i))+avg; 0]; % matriz 2 x 1; [x; y]
    p2=[real(open_poles(i))+avg*cos(theta(i)); avg*sin(theta(i)) ];
    center=[real(open_poles(i)); 0];
    arc(p1, p2, center);
    aux=num2str(theta_deg(i),'%7.1f'); % transforma n?mero em string
    text(real(open_poles(i))+(avg/2)*cos( (theta(i)/1.5) ), ...
        (avg/2)*sin( (theta(i)/1.5) ), [aux '^o']);
end
fprintf('\nSum of angular contribution of poles, $\\sum {\\theta_{\\text{P??los}}} = %.2f^{o}$\n\n', sump*180/pi)

% linha pontilhada ligando zeros de MA ao p?lo de MF
for i=1:num_zeros,
    plot(real([open_zeros(i) polos_MF(1)]), imag([open_zeros(i) polos_MF(1)]), 'k--') 
    % tra?a linhas pontilhadas ligando cada p?lo de MA ao p?lo desejado em MF
end

v=axis;
% plota eixo real e eixo imagin??rio do plano-s
plot([v(1) v(2)], [0 0], 'k-');
v(3)=-0.5; v(4)=1.2*v(4);
axis(v);
plot([0 0], [v(3) v(4)], 'k-');
xlabel('Real Axis');
ylabel('Imaginary Axis');

fprintf('Angular contribution of each zero in the s-plane:\n\n')
sumz=0;
for i=1:num_zeros
    x(i) = real(polos_MF(1)) - real(open_zeros(i)); % verificar se n??o falta acrescentar um "offset"
    y(i) = imag(polos_MF(1)) - imag(open_zeros(i)); % new_omega;
    theta(i) = atan2(y(i), x(i)); % determinando la contribuici?n de cada zero
    theta_deg(i)=(theta(i)*180)/pi; % angulo em graus
    sumz = sumz + theta(i);
    fprintf ('\t$z_%1i = %g \\rightarrow %.2f^{o}$\n', i, open_zeros(i), theta_deg(i))
end
% plotando as contribui??es angulares dos zeros
for i=1:num_zeros,
    p1=[real(open_zeros(i))+avg; 0]; % matriz 2 x 1; [x; y]
    p2=[real(open_zeros(i))+avg*cos(theta(i)); avg*sin(theta(i)) ];
    center=[real(open_zeros(i)); 0];
    arc(p1, p2, center);
    aux=num2str(theta_deg(i),'%7.1f'); % transforma n?mero em string
    text(real(open_zeros(i))+(avg/2)*cos( (theta(i)/1.5) ), ...
        (avg/2)*sin( (theta(i)/1.5) ), [aux '^o']);
end

%% Calculando contribui????o angular final
fprintf('\nSum of angular contribution of zeros, $\\sum {\\theta_{\\text{Zeros}}} = %.2f^{o}$\n\n', sumz*180/pi)
final_angle = abs(pi - sump + sumz); % necess??rio abs() !?

fprintf('Final angle for the pole of $C(s)$, $\\theta_{z_{c}} = %.4f^o$\n\n', final_angle*180/pi)

% pode-se determinar agora a posi??o para o zero ou p?lo do Lead
% fprintf('\nOk, Determining the position for pole of C(s)...\n')
% pc = -(new_omega/tan(final_angle)-new_sigma);
% DeltaX=wd/tan(final_angle);
% pc = -(-sigma+DeltaX); ou
pc = -(wd/tan(final_angle)-sigma);
fprintf('Final position for the Lead pole: $p_c=%.4f$\n\n', pc)

% plotando o gr?fico com o zero resultante:
plot(real(pc), imag(pc),'ro', 'MarkerSize', 12);
plot(real([pc polos_MF(1)]), imag([pc polos_MF(1)]),'m--')
p1=[real(pc)+avg; 0]; % matriz 2 x 1; [x; y]
p2=[real(pc)+avg*cos(final_angle); avg*sin(final_angle) ];
center=[real(pc); 0];
arc(p1, p2, center);
aux=num2str( (final_angle*180/pi) ,'%7.2f'); % transforma n?mero em string
text(real(pc)+(avg/2)*cos( (final_angle/1.5) ), ...
  (avg/2)*sin( (final_angle/1.5) ), [aux '^o']);

if abs(pc) > abs(v(1))
  v(1)=pc*1.1;
end
axis(v)
axis normal

%% Montando o novo controlador
% num_c=poly(pc);
den_c=poly(pc);

C_Lead=tf(num_c, den_c);
fprintf('The Lead controller final result is (variable `C_Lead`):\n\n```matlab ');
zpk(C_Lead)
clear ftma
ftma_Lead=C_Lead*G;
fprintf('\b```\n\nThe $FTMA(s)$ (variable `ftma_Lead`):\n\n```matlab ');
zpk(ftma_Lead)

% Verificando RL final...
figure;
fprintf('\b```\n\nFinal RL graph:\n\n');
rlocus(ftma_Lead);
hold on
% zgrid(zeta, wn*T);
sgrid(zeta, wn);
% plotando posi??o desejado para p?lo de MF:
plot(polos_MF, 'm+', 'MarkerSize', 12);
disp('Fim do script, Favor observar janelas gr?ficas...')
