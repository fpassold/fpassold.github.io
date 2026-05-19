import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, lfilter

# 1. Configurações do sinal (Alta taxa para amostragem temporal suave)
fs = 16000        # Taxa de amostragem (Hz)
duration = 0.03   # 30 milissegundos (janela curta para enxergar a forma da onda)
t = np.linspace(0, duration, int(fs * duration), endpoint=False)

# 2. Geração do sinal original (Acorde C Major com harmônicos)
fundamentals = [164.81, 261.63, 392.00]  # Mi3, Dó4, Sol4
y_original = np.zeros_like(t)

for f_fund in fundamentals:
    for n in range(1, 10):  # 1 (fundamental) até 9º harmônico
        f_harmonic = f_fund * n
        if f_harmonic < fs / 2:
            amplitude = 1.0 / n  # Decaimento harmônico natural (1/n)
            y_original += amplitude * np.sin(2 * np.pi * f_harmonic * t)

# 3. Projeto e aplicação do Filtro Butterworth de 3ª Ordem
fc = 440.0  # Frequência de corte (Hz)
nyq = 0.5 * fs
b, a = butter(3, fc / nyq, btype='low')
y_filtered = lfilter(b, a, y_original)

# 4. Plotagem das Formas de Onda (Domínio do Tempo)
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 6), sharex=True)

# Gráfico 1: Sinal Original (Antes do Filtro)
ax1.plot(t * 1000, y_original, color='crimson', linewidth=1.5)
ax1.set_title('Sinal do Acorde Original (Rico em Harmônicos - Domínio do Tempo)')
ax1.set_ylabel('Amplitude')
ax1.grid(True, linestyle=':', alpha=0.6)

# Gráfico 2: Sinal Filtrado (Depois do Filtro)
ax2.plot(t * 1000, y_filtered, color='dodgerblue', linewidth=2)
ax2.set_title('Sinal do Acorde Filtrado (Butterworth 3ª Ordem / Fc = 440 Hz)')
ax2.set_xlabel('Tempo (ms)')
ax2.set_ylabel('Amplitude')
ax2.grid(True, linestyle=':', alpha=0.6)

plt.tight_layout()
plt.show()