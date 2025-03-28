'''
Rotina para demonstrar distribuição uniforme
Fernando Passold, 21/03/2025
'''
import numpy as np
import matplotlib.pyplot as plt

# Parâmetros da distribuição uniforme
a = -0.5  # limite inferior
b = 0.5  # limite superior
num_samples = 10000  # número de amostras

# Gerando amostras da distribuição uniforme
samples = np.random.uniform(a, b, num_samples)

# Calculando a média e a variância das amostras
mean = np.mean(samples)  # média
variance = np.var(samples)  # variância

# Plotando o histograma
plt.hist(samples, bins=50, density=True, alpha=0.6, color='b', label=f'Uniforme [{a}, {b}]')

# Adicionando texto com a média e a variância
text = f'Média = {mean:.4f}\nVariância = {variance:.4f}'
plt.text(0.5, 0.1, text, fontsize=12, ha='center', va='center', transform=plt.gca().transAxes, 
         color='black',  # Cor do texto (preto)
         alpha=1,  # Alpha do texto forçado em 1 (totalmente opaco)
         backgroundcolor=(1, 1, 1, 0.6))  # Cor de fundo (branco com 60% de transparência)
		 # O parâmetro alpha=0.6 foi adicionado para ajustar a transparência da cor de 
		 # fundo do texto. Você pode alterar o valor de alpha para controlar o nível 
		 # de transparência (0 = totalmente transparente, 1 = totalmente opaco).


# Configurações do gráfico
plt.title('Histograma da Distribuição Uniforme')
plt.xlabel('Valores')
plt.ylabel('Densidade de Probabilidade')
plt.legend()
plt.grid(True)
plt.show()