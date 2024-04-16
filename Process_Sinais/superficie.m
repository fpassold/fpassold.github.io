t=[0:0.25:2*pi];
x=t;
y2=t;
z2=sin(t)'*sin(y2);
close all
surf(x,y2,z2)
axis off