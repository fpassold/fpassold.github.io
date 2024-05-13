% Rotina para tentar realizar gráfico de superfície de H(z)
% Ref.: [Matlab 3D Plot of transfer function magnitude](https://stackoverflow.com/questions/21264968/matlab-3d-plot-of-transfer-function-magnitude)
%
% Exemplo:
% H(z)=(6 -10z^{-1} +2z^{-2})/(1 -3z^{-1} +2z^{-2})

b = [6 -10 2];  % den
a = [1 -3 2];   % num

[x, y] = meshgrid(-3:0.25:3);
z = x+y*j;

% res = (polyval(b, z))./(polyval(a,z)); % calcula H(z^{-1})
res = (polyval(fliplr(b), z))./(polyval(fliplr(a),z));
surf(x,y, abs(res));

% Acrescentando o círculo unitário - vista superior:
% Problema: transforma gráfico 3D em 2D
% imagesc(-3:0.1:3,-3:0.1:3, abs(res));
% hold on
% rectangle('curvature', [1 1], 'position', [-1 -1 2 2], 'edgecolor', 'w');
% axis equal

% Gráfico equivalente ao Diagrama de Bode
% sys = tf(b,a,0.1,'variable','z^-1') 
% figure
% bode(sys)
