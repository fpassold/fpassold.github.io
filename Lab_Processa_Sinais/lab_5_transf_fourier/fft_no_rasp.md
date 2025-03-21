## FFT e Espectro de Sinal em Raspberry Pi

**Desafio**:</br>
Poderíamos tentar mostrar o algoritmo FFT sendo executado num Raspberry programado em Python, cuja rotina atualize constantemente o espectro de certo sinal numa janela gráfica (algo como 1 vez por segundo).

Vamos utilizar a biblioteca **numpy** para a computação e a biblioteca **matplotlib** para a visualização. Certifique-se de que essas bibliotecas estejam instaladas no seu Raspberry Pi.

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from scipy.fftpack import fft

# Parâmetros
fs = 1000  # Frequência de amostragem (1 kHz)
T = 1.0  # Duração do sinal em segundos
N = int(fs * T)  # Número de pontos no sinal
freq = 5.0  # Frequência do sinal em Hz
amplitude = 1.0  # Amplitude do sinal
update_interval = 1000  # Intervalo de atualização em milissegundos (1 segundo)

# Gere o sinal senoidal
t = np.linspace(0.0, N/fs, N, endpoint=False)
signal = amplitude * np.sin(2 * np.pi * freq * t)

# Inicialização da figura
fig, (ax1, ax2) = plt.subplots(2, 1)
x = np.linspace(0, fs/2, N//2)
line, = ax1.plot(x, np.zeros(N//2))
ax1.set_xlim(0, fs/2)
ax1.set_ylim(0, 2)
ax1.set_title('Espectro em Tempo Real')
ax1.set_xlabel('Frequência (Hz)')
ax1.set_ylabel('Amplitude')

ax2.plot(t, signal)
ax2.set_xlim(0, T)
ax2.set_ylim(-amplitude, amplitude)
ax2.set_title('Sinal de Entrada')
ax2.set_xlabel('Tempo (s)')
ax2.set_ylabel('Amplitude')

# Função de atualização para calcular a FFT em tempo real
def update(i):
    signal = amplitude * np.sin(2 * np.pi * freq * t)
    Y = fft(signal)
    Y = Y[:N//2]
    line.set_ydata(np.abs(Y) / N * 2)
    fig.canvas.flush_events()

# Crie uma animação para atualizar a FFT em tempo real
ani = animation.FuncAnimation(fig, update, blit=False, interval=update_interval)

# Exiba a janela gráfica
plt.show()
```

Neste código:

1. Um sinal senoidal é gerado com uma frequência de 5 Hz e uma amplitude de 1.0.
2. Uma janela gráfica é inicializada com duas subtramas: uma para o sinal de entrada e outra para o espectro em tempo real.
3. A função `update(i)` calcula a FFT em tempo real do sinal e atualiza o gráfico do espectro.
4. A animação é criada para atualizar o espectro a cada segundo.
5. A função `plt.show()` exibe a janela gráfica.
6. 
Você pode ajustar os parâmetros, como frequência, amplitude e frequência de amostragem, de acordo com suas necessidades e conectar seu sinal de entrada real ao lugar do sinal senoidal gerado para analisar o espectro em tempo real. Certifique-se de ter as bibliotecas **numpy** e **matplotlib** instaladas no seu Raspberry Pi.

---

Fernando Passold, em 02/11/2023