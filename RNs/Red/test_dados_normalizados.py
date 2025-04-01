"""
Importância de dados com média zero e desvio padrão unitário
Fernando Passold, em 30/03/2025
"""
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler

# Dados de exemplo (2 features com escalas diferentes)
'''
X = np.array([
    [1000, 0.1], 
    [2000, 0.2], 
    [3000, 0.3], 
    [4000, 0.4]
])
'''

X = np.array([
    [10, 0.1], 
    [20, 0.2], 
    [30, 0.3], 
    [40, 0.4]
])

# Caso (a) Dados Originais (Não Normalizados)
plt.scatter(X[:, 0], X[:, 1], c='red', label="Dados Originais")
plt.xlabel("Feature 1 (Escala ~1000s)")
plt.ylabel("Feature 2 (Escala ~0.1s)")
plt.title("Dados Não Normalizados")
plt.grid()
plt.legend()
plt.show()

# (b) Dados Normalizados (StandardScaler)
scaler = StandardScaler()
X_normalized = scaler.fit_transform(X)

plt.scatter(X_normalized[:, 0], X_normalized[:, 1], c='blue', label="Dados Normalizados")
plt.xlabel("Feature 1 (Média = 0)")
plt.ylabel("Feature 2 (DP = 1)")
plt.title("Dados Normalizados (StandardScaler)")
plt.grid()
plt.axhline(0, color='black', linestyle='--')
plt.axvline(0, color='black', linestyle='--')
plt.legend()
plt.show()
