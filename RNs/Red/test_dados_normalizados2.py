"""
Importância de dados com média zero e desvio padrão unitário
Fernando Passold, em 30/03/2025
"""
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler

# Dados de exemplo (2 features com escalas diferentes)
# - Coluna 1: valores entre -10 e 20
# - Coluna 2: valores entre -0.5 e 0.75
n_samples = 100  # Número de pontos
X = np.column_stack([
    np.random.uniform(low=-10, high=20, size=n_samples),  # Coluna 1
    np.random.uniform(low=-0.5, high=0.75, size=n_samples)  # Coluna 2
])

# Calculando as médias antes da normalização
mean_feature1 = np.mean(X[:, 0])
mean_feature2 = np.mean(X[:, 1])

# Visualização dos dados originais
plt.figure(figsize=(12, 5))

plt.subplot(1, 2, 1)

plt.scatter(X[:, 0], X[:, 1], c='red', alpha=0.6, label='Dados')
plt.axhline(y=mean_feature2, color='blue', linestyle='--', linewidth=1.5, 
            label=f'Média Feature 2 = {mean_feature2:.2f}')
plt.axvline(x=mean_feature1, color='blue', linestyle='--', linewidth=1.5, 
            label=f'Média Feature 1 = {mean_feature1:.2f}')
plt.title("Dados Originais com Linhas de Média")
plt.xlabel("Feature 1 (Faixa: -10 a 20)")
plt.ylabel("Feature 2 (Faixa: -0.5 a 0.75)")
plt.grid(True, linestyle='--', alpha=0.5)
plt.legend()

# (b) Dados Normalizados (StandardScaler)
scaler = StandardScaler()
X_normalized = scaler.fit_transform(X)

plt.subplot(1, 2, 2)

plt.scatter(X_normalized[:, 0], X_normalized[:, 1], c='blue', alpha=0.6)
plt.title("Dados Normalizados\n(Média=0, Desvio Padrão=1)")
plt.xlabel("Feature 1 (Normalizada)")
plt.ylabel("Feature 2 (Normalizada)")
plt.grid(True, linestyle='--', alpha=0.7)
plt.axhline(0, color='black', linewidth=0.5)
plt.axvline(0, color='black', linewidth=0.5)

plt.tight_layout()
plt.show()

# Mostrando Histogramas

plt.figure(figsize=(12, 5))

# Histograma dos dados originais
plt.subplot(1, 2, 1)
plt.hist(X[:, 0], bins=20, alpha=0.7, label='Feature 1', color='red')
plt.hist(X[:, 1], bins=20, alpha=0.7, label='Feature 2', color='green')
plt.title("Distribuição Original")
plt.xlabel("Valores")
plt.ylabel("Frequência")
plt.legend()

# Histograma dos dados normalizados
plt.subplot(1, 2, 2)
plt.hist(X_normalized[:, 0], bins=20, alpha=0.7, label='Feature 1', color='red')
plt.hist(X_normalized[:, 1], bins=20, alpha=0.7, label='Feature 2', color='green')
plt.title("Distribuição Normalizada")
plt.xlabel("Valores (Média=0, Desvio=1)")
plt.legend()

plt.tight_layout()
plt.show()
