% teste_sonar2
% Fernando Passold 21/09/2018
%   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16
d=[255 255 255 255 255 182  87  23  26  27  27 255 255 181  56 255];
u=length(d); % caso o tamanho do vetor varie
step=2*pi/u;
angle=0;
range=15; % leque de abertura;
range_rad=(pi*range)/180;
step_r=pi/180; % passo para gerar o plot -15^o ? +15^o
%%%
step_color=64/u; % colormap<=>cmap:64x3
color=step_color;
cmap=colormap(jet); % winter
for index=1:u
    cont=2;
    range_sup=angle+range_rad;
    range_inf=angle-range_rad;
    x(1)=0; y(1)=0;
    for theta=range_inf:step_r:range_sup
        x(cont)=d(index)*cos(theta);
        y(cont)=d(index)*sin(theta);
        cont=cont+1;
    end
    msg=num2str(index);
    x_msg=d(index)*1.05*cos(angle);
    y_msg=d(index)*1.05*sin(angle);
    text(x_msg, y_msg, msg);
    x(cont)=0; y(cont)=0;
    plot(x,y,'Color',cmap(color,1:3)); 
    if index==1
        hold on; % para pr?ximos gr?ficos
    end
    angle=angle+step;
    color=color+step_color;
end
hold off
axis equal
title('sonar\_test2')

