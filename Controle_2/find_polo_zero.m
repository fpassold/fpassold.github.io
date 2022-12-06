% find_polo_zero.m
% 
% Angular contribution routine to find out where to locate pole or zero 
% of the controller depending on the desired location for MF poles
%
% Use:
% This routine already expects a tf named "ftma_aux"
%   ftma_aux(s)=C(s)'*G(s);
% where: C(s)' is almost the full tf of the controller, 
%        except for the pole or zero that this routine is expected to 
%        determine using angular contribution.
% 
% This routine uses angular contribution to find the position of the pole
% or the zero that is necessary to complete the tf of the controller.
% It asks almost at the end, whether the user wants to find out the 
% position of the pole or the zero that is missing.
%
% Fernando Passold, 14/10/2020, 20/10/2020, 30/10/2022, 30/11/2022.

A = exist('ftma_aux');
if A ~= 1
    disp('Error: expected a tf named "ftma_aux"!');
    disp(' ');
    disp('ftma_aux: A partial transfer function, containing the TF plant,')
    disp('G(s), and the partial tf of the controller, C_aux(s).');
    disp(' ');
    disp('Example_1: You want to design a PI and want to find out')
    disp('           the best place for the zero of the pi, then:')
    disp('           >> c_aux = tf(1, [1 0]);')
    disp('           >> ftma_aux = c_aux * G;')
    disp(' ');
    disp('Example_2: You want to design a PD and want to find out')
    disp('           the best place for the zero of the PD, then:')
    disp('           >> c_aux = tf(1, 1);')
    disp('           >> ftma_aux = c_aux * G;') 
    disp(' ');
    disp('Aborting...');
    return
end

clear i j % erases these variables because matlab uses 'i' or 'j' to designate imaginary part of complex numbers

fprintf('\nRoutine to determine the position of the pole or zero\n')
fprintf('that is missing to complete controller design\n\n')
%% determining the desired position for the pole in the s-plane
OS = input('%OS$ (desired Overshoot, in %): ? ');
zeta = (-log(OS/100))/(sqrt(pi^2 + (log(OS/100)^2)));
ts_d=input('  ts_d (desired settling time): ? ');
wn = 4 / (zeta*ts_d);
wd = wn*sqrt(1-zeta^2);
sigma = wn*zeta;
x(1) = -sigma; y(1) = wd;
x(2) = -sigma; y(2)= -wd;
polos_mf=complex(x, y);
fprintf('Desired MF poles must be located at:\n\ts = %g ± j%g\n\n', ...
    -sigma, wd)

% Note the negative value used for signma in polos_mf

%% Draw RL showing angular contribution
f=figure();
pzmap(ftma_aux);
hold on;
plot(polos_mf, 'r+', 'MarkerSize', 14);
% adds text to the MF poles
aux1=num2str(-sigma,'%4.2f');
aux2=num2str(wd,'%4.2f');
aux=[aux1 '+j' aux2];
text( real(polos_mf(1)), imag(polos_mf(1)), aux);

%% calculating the angles
%% Calculating angles for poles
Sum_th_p=0;
polo=pole(ftma_aux);
polos=length(polo); % discovers amount of poles
clear th_p % Cleans vector of poles angles
disp('Evaluating the pole(s) contribution angle(s):')
for p=1:polos
    % highlights poles on pzmap
    plot( real(polo(p)), imag(polo(p)), 'bx', ...
        'MarkerSize', 14);
    % evaluating angles
    delta_x = -sigma -real(polo(p));
    delta_y = wd -imag(polo(p));
    th_p(p) = atan2(delta_y, delta_x);
    Sum_th_p = Sum_th_p + th_p(p);
    aux = th_p(p)*180/pi;
    fprintf('  Pole %i) in s=%g + j(%g)\t| angle: %.2f^o\n', ...
        p, real(polo(p)), imag(polo(p)), aux);
    % showing angle(s) in pzmap figure
    xini = real(polo(p)); yini = imag(polo(p));
    xfim = -sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'b--', ...
        'LineWidth', 1);
    aux2 = num2str(aux,'%6.2f');
    aux2 = [aux2 '^o'];
    text( xini, yini, aux2);
end
% disp('Sum of the angle(s) of pole(s):')
fprintf('\t\t\tSum(angle{poles}) = %.2f^o\n\n', Sum_th_p*180/pi);

%% Calculating angles for zeros
Sum_th_z=0;
zzero=zero(ftma_aux);
zeros=length(zzero); % discovers amount of zeros
clear th_z % cleans vector of zero angles
disp('Evaluating the zero(s) contribution angle(s):')
for z=1:zeros
    % highlights zeros on pzmap
    plot( real(zzero(z)), imag(zzero(z)), 'mo', ...
        'MarkerSize', 14);
    delta_x = -sigma -real(zzero(z));
    delta_y = wd - imag(zzero(z));
    th_z(z) = atan2(delta_y, delta_x);
    Sum_th_z = Sum_th_z + th_z(z);
    aux = th_z(z)*180/pi;
    fprintf('  Zero %i) in s=%g + j(%g)\t| angle: %.2f^o\n', ...
        z, real(zzero(z)), imag(zzero(z)), aux);
    % showing angle(s) in pzmap figure
    xini = real(zzero(z)); yini = imag(zzero(z));
    xfim = -sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'm--', ...
         'LineWidth', 1);
    aux2 = num2str(aux,'%6.2f');
    aux2 = [aux2 '^o'];
    text( xini, yini, aux2);    
end
%disp('Sum of the angle(s) of zero(s):')
fprintf('\t\t\tSum(angle{zeros}) = %.2f^o\n\n', Sum_th_z*180/pi);

%% Remembering the RL law of angular contribution:
% angle(N(s)/D(s)) = +/- r*180^o, r = 1, 3, 5, ...
% ou seja:
% angle(N(s)/D(s)) = +/- 180^o (pi) ou
% angle(N(s)/D(s)) = +/- 540^o (3*pi)...

% calculating better axis() for pzmap
higher_y = max( [wd max(imag(polo)) max(imag(zzero)) ] );
ymax = 1.1*higher_y; % +10% of the higher value
lower_y = min( [-wd min(imag(polo)) min(imag(zzero)) ]); % lower negative part (higher negative niumero)
ymin = 1.1*lower_y;
inc_x= 0.1*min(real(polo));
xmin= min(real(polo)) + inc_x;
xmax= max(real(polo)) - inc_x;
axis([xmin xmax ymin ymax])
title('Angle contribution graph')

%% Determining pole or zero location of the controller
disp('Determining pole or zero location of the controller:')
escolha='n'; % string vazia;
while ((escolha ~= 'z')&(escolha ~= 'p'))
    escolha = input('Select: [p]=pole or [z]=zero, for the controller ? ', 's');
    escolha = lower(escolha);
end

falta=tf(1,1);

if escolha == 'z'
    % Angle(N(s)/D(s)) = pi
    % Sum_th_z + th_zero - Sum_th_p = pi
    % th_zero = pi - Sum_th_z + Sum_th_p
    th_zero = pi - Sum_th_z + Sum_th_p;
    aux = th_zero*180/pi;
    while aux > 360
        aux = aux - 360;
    end
    fprintf('\nAngle contribution required for controller: %.2f^o\n', aux);
    delta_x = wd/tan(th_zero);
    zero_c = -sigma - delta_x;
    disp('This means that the controller ')
    fprintf('\tZERO must be at s = %g\n', zero_c)
    % adding in the previous pzmap
    xini = zero_c; yini = 0;
    xfim = -sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'ro--', ...
        'MarkerSize', 14, 'LineWidth', 2);
    falta=tf([1 -zero_c], 1);
    % adding text with angle value
    aux = num2str(aux,'%4.2f');
    aux = [aux '^o'];
    text( zero_c, 0.01*wd, aux)
end
if escolha == 'p'
    % Angle(N(s)/D(s)) = pi
    % Sum_th_z - (Sum_th_p + th_polo) = pi
    % Sum_th_z - Sum_th_p - th_polo = pi
    % Sum_th_z - Sum_th_p - pi = th_polo
    th_polo = Sum_th_z - Sum_th_p - pi;
    aux = th_polo*180/pi;
    fprintf('\nAngle contribution required for controller: %.2f^o\n', aux);
    delta_x = wd/tan(th_polo);
    polo_c = -sigma - delta_x;
    disp('This means that the controller ')
    fprintf('\tPOLE must be at s = %g\n', polo_c)
    % adding in the previous pzmap
    xini = polo_c; yini = 0;
    xfim = -sigma; yfim = wd;
    plot( [xini xfim], [yini yfim], 'rx--', ...
        'MarkerSize', 14, 'LineWidth', 2);
    falta=tf(1, [1 -polo_c]);
    % adding text with angle value
    aux = num2str(aux,'%4.2f');
    aux = [aux '^o'];
    text( polo_c, 0.01*wd, aux)
end

%% Proving final results
fprintf('\nTo finish the project, note that:\n')
ftma=falta*ftma_aux;
ftma=zpk(ftma)
figure;
rlocus(ftma);
hold on;
sgrid(zeta,0);
plot(polos_mf, 'm*')
disp('Find the controller gain with the command:')
fprintf('\n\t>> K_ = rlocfind(ftma)\n\n')
