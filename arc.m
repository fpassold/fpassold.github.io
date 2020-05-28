% function arc.m
% Fernando Passold, em 25/05/2016
% baseado em: http://www.mathworks.com/matlabcentral/newsreader/view_thread/278048
%
% Parâmetros de entrada:
%   p1 = ponto de partida do arco;
%   p2 = ponto de chegada do arco;
%   center = ponto (centro) do arco;
% Detalhe: p1, p2, center envolvem vetor de 2 dimensões, contendo
% por exemplo: 
%    p1(1)=coordenada X (ou parte real de número complexo)
%    p1(2)=coordenada Y (ou parte imaginária de número complexo)
% esta função só gera saída gráfica, então se
% pressupõe que já foi enviado antes comando como
%    'hold on'
function arc(p1,p2,center)
    n=20; % numero de pontos dentro do arco
    v1=p1-center;
    v2=p2-center;
    % v3=[0 -1;1 0]*v1; % v1 rotated 90 degrees CCW
    c = det([v1,v2]); % "cross product" of v1 and v2
    v3 = [0, -c; c, 0]*v1; % v3 lies in plane of v1 and v2 and is orthog. to v1
    % a = linspace(0, mod(atan2(det([v1, v2]), dot(v1, v2)), 2*pi)); % Angle range
    a = linspace(0, atan2(abs(c), dot(v1,v2)), n); % Angle range
    % Note the absence of the 'abs' function in 'atan2'
    % v = v1*cos(a)+v3*sin(a);
    v = v1*cos(a)+((norm(v1)/norm(v3))*v3)*sin(a); % Arc, center at (0,0)
    plot(v(1,:)+center(1),v(2,:)+center(2),'m--'); % Plot arc, centered at 'center'
    axis equal
end