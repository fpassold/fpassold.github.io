% Simulando taxa de aprendizado decrescente simulando resposta ao impulso
% para filtro passa-baixas de 1a-ordem, ou tambpem dito filtro exponencial
% Fernando Passold, em 19/03/2025
initial_lr=0.3;
minimum_lr=1e-4;
alpha=[0.9 0.75 0.5 0.25 0.1];
passos=30;
clear x y

% Calculando...
k=length(alpha);
x=0:passos-1; % inicializa eixo x = épocas
for l=1:k,
    aux=['alpha=',num2str(alpha(l))]; % criar vetor legendas 
    msg(l,1:length(aux))=aux;
    lr(1)=initial_lr;
    y(1,l)=lr(1);
    for n=2:passos,
        lr(n)=alpha(l)*lr(n-1) + (1-alpha(l))*minimum_lr;
        y(n,l)=lr(n);
    end
end
% Gerando gráfico
for l=1:k,
    plot(x,y(:,l));
    if l==1 
        hold on
    end 
end
legend(msg)
xlabel('Épocas')
ylabel('lr (taxa aprendizado)')
title('Evolução Taxa Aprendizado')
