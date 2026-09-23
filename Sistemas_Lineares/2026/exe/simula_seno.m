% Simulando senoide na entrada deste circuito
f = input("Freq. da senoide: ? ");
T=1/f; % período do sinal
w=2*pi*f;
% calculando ganho nesta frequencia
clear s_aux ganho
s_aux=w*1i; % s --> jw
[ganho, phase] = bode(H, w);
ganho_dB = 20*log10(ganho);
% Ou fazer:
% ganho = abs(H(1i*w)); <-- resultou erro: error: freqresp: second argument 'w' must be a real-valued vector of frequencies
fprintf('Ganho = %g (= %g dB)\n\n', ganho, ganho_dB);

t_fim=2.5*T;
clear t Vin Vout
t=0:T/100:t_fim;
Vin=1*sin(2*pi*f*t);
[Vout, t]=lsim(H, Vin, t);
figure;
plot(t, Vin, 'LineWidth', 1.2);
hold on
plot(t, Vout, 'LineWidth', 1.2);
xlim([0 t_fim]);
grid on
xlabel('Tempo (s)');
ylabel('Tensão (V)');
legend('V_{in}', 'V_{out}', "location", "southeast");
title(['f = ', num2str(f), ' Hz']);

