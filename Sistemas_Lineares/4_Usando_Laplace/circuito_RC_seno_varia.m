% circuito_RC_seno_varia.m
% Simula senoides freq. variável na entrada de
% um circuito RC passa-baixas

pkg load control

R = 1e3;
C = 1e-6;
disp("Frequência de corte deste circuito:")
fc=1/(2*pi*R*C)

s = tf('s');

H = 1/(R*C*s + 1);

Vm = 5;

frequencias = [10 32 100 316 1000 3162 10000 fc/10 fc 10*fc];

for f = frequencias

    T = 1/f; % período da onda
    t_fim = 3.5*T;
    t_sampling = T/50; % 50 pontos por ciclo
    clear t Vin Vout;  % recomeça vetores
    t = 0:t_sampling:t_fim;

    Vin = Vm*sin(2*pi*f*t);

    [Vout, t] = lsim(H, Vin, t);

    figure;

    plot(t, Vin, 'LineWidth', 1.2);
    hold on;
    plot(t, Vout, 'LineWidth', 1.2);
    xlim([0 t_fim]);  % para não deixar eventual espaço em branco no final

    grid on;

    xlabel('Tempo (s)');
    ylabel('Tensão (V)');

    legend('V_{in}', 'V_{out}', "location", "southeast");

    title(['f = ', num2str(f), ' Hz']);

end

figure; bode(H)

