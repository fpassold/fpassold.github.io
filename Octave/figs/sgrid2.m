function sgrid2 (zeta)
  % função para plotar linha guia do zeta na última janela gráfica ativa
  % a partir do valor de zetam calcula o angulo alpha e traça a reta
  % que corresponde a linha guia
  % Fernando Passold, em 29/12/2022
  alpha=acos(zeta); % angulo correspondente ao zeta
  % fig=gcf(); % descobre numero da última janela ativa atual - dá no mesmo que fazer:
  fig = get (0, "currentfigure"); % recupera número da última figura ativa
  % Capturando limite da figura atual
  xlim=get(gca(),"xlim");
  ylim=get(gca(),"ylim");
  min_x=min(xlim);
  x=[0 min_x]; % vetor pontos da reta
  y2=abs(min_x)*tan(alpha);
  y=[0 y2];
  hold on;
  plot(x,y,"color","cyan"); % ,"linestyle","--");
  % sobre propriedades de plot ver:
  % https://docs.octave.org/v6.3.0/Line-Properties.html
  y=[0 -y2];
  plot(x,y,"color","cyan");
  shg % show the graph window
  % Note: shg is equivalent to figure (gcf) assuming that a current figure exists.
end
