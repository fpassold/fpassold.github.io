% Determinando faixa de polos em MF, 
% variando ganho para fig. 4.1 NISE 
% Fernando Passold, em 01.04.2019
K=[0 0.1 0.5 1 1.5 2 4 10 50 100]; 
u=length(K);
fprintf(' K | EC(s)=0 | Polo em (s=)\n'); 
for i=1:u
    EC = [(K(i) + 1) (2*K(i) + 5)]; % monta EC(s) 
    polo(i) = roots(EC);
    fprintf('%5.1f | %g s + %g = 0 | %7.2f\n', ...
        K(i), EC(1), EC(2), polo(i));
end
plot(real(polo), imag(polo), 'xb')
