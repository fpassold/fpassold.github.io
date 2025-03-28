'''
Rotina para demonstrar distribuição gaussiana
Fernando Passold, 21/03/2025
'''
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# Parâmetros da distribuição normal
mean = 0  # média nula
variances = [0.1, 0.5, 1, 3]  # variâncias
x = np.linspace(-5, 5, 1000)  # intervalo de valores para o eixo x

# Plotando as curvas de densidade para cada variância
plt.figure(figsize=(10, 6))
for var in variances:
    std_dev = np.sqrt(var)  # desvio padrão
    pdf = norm.pdf(x, mean, std_dev)  # função de densidade de probabilidade
    plt.plot(x, pdf, label=f'Variância = {var}, Desvio Padrão = {std_dev:.2f}')

# Configurações do gráfico
plt.title('Curvas de Densidade da Distribuição Normal (Média = 0)')
plt.xlabel('Valores')
plt.ylabel('Densidade de Probabilidade')
plt.legend()
plt.grid(True)
plt.show()
