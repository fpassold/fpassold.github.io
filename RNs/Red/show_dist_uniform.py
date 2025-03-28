'''
Rotina para demonstrar distribuição uniforme
Fernando Passold, 21/03/2025
'''
import numpy as np
import matplotlib.pyplot as plt

# Parâmetros da distribuição uniforme
a = -0.5 # limite inferior
b = 0.5  # limite superior
num_samples = 50  # número de amostras
# k = np.linspace(0, num_samples-1, num_samples) # gerando vetor k correspondente ao index das amostras
k = np.arange(num_samples)
# print("10 primeiros valores:", k[0:10])

# Gerando amostras da distribuição uniforme
samples = np.random.uniform(a, b, num_samples)
# print("10 primeiros amostras:", samples[0:10])

# Calculando a média e a variância das amostras
mean = np.mean(samples)  # média, μ
variance = np.var(samples)  # variância, σ^2 
desvio_padrao = np.sqrt(variance) # desvio padrão, σ
'''
Quando você escreve μ ± σ, está dizendo que, para uma distribuição normal 
(Gaussiana), aproximadamente 68% dos dados estão dentro do intervalo 
[μ−σ, μ+σ]. Isso ajuda a entender em torno de quais valores a média oscila.
'''

# Criando a janela gráfica com 1 linha e 2 colunas
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

# Gráfico da esquerda: Valores das amostras em função do número da amostra
ax1.plot(k, samples, 'bo-', markersize=4, label='Amostras')  # Marcadores das amostras
ax1.axhline(mean, color='m', linestyle='--', label=f'Média = {mean:.4f}')  # Linha da média
ax1.set_title('Amostras Geradas')
ax1.set_xlabel('No. da Amostra')
ax1.set_ylabel('Valor da Amostra')
# ax1.legend()
ax1.grid(True)

# Adicionando texto com o valor da média
ax1.text(0.5, 0.06, f'Média = {mean:.4f} ± {desvio_padrao:.4f}', fontsize=12, ha='center', va='center', 
         transform=ax1.transAxes, color='black', alpha=1, 
         backgroundcolor=(1, 1, 1, 0.6))  # Texto com fundo semitransparente

# Gráfico da direita: Histograma da distribuição uniforme
ax2.hist(samples, bins=10, density=True, alpha=0.6, color='b', label=f'Dist. Uniforme [{a}, {b}]')
ax2.set_title('Histograma da Distribuição Uniforme')
ax2.set_xlabel('Valores')
ax2.set_ylabel('Densidade de Probabilidade')
ax2.legend()
ax2.grid(True)

# Adicionando texto com a média e a variância
ax2.text(0.5, 0.1, f'Média = {mean:.4f}\nVariância = {variance:.4f}', fontsize=12, 
         ha='center', va='center', transform=ax2.transAxes, color='black', alpha=1, 
         backgroundcolor=(1, 1, 1, 0.6))  # Texto com fundo semitransparente

# Ajustando o layout para evitar sobreposição
plt.tight_layout()
plt.show()