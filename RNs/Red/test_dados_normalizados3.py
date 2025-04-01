import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler

# Configurações iniciais
np.random.seed(42)  # Para reproduzibilidade
plt.style.use('seaborn')  # Estilo visual moderno

# 1. Geração de dados aleatórios
n_samples = 150  # Número aumentado para melhor visualização
X = np.column_stack([
    np.random.uniform(low=-10, high=20, size=n_samples),  # Feature 1
    np.random.uniform(low=-0.5, high=0.75, size=n_samples)  # Feature 2
])

# 2. Cálculo das estatísticas originais
mean_f1, mean_f2 = np.mean(X, axis=0)
std_f1, std_f2 = np.std(X, axis=0)

# 3. Normalização
scaler = StandardScaler()
X_norm = scaler.fit_transform(X)

# 4. Visualização aprimorada
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6), sharey=True)

# Gráfico original
scatter1 = ax1.scatter(X[:,0], X[:,1], c='#E74C3C', alpha=0.7, edgecolors='w', s=80)
ax1.axhline(mean_f2, color='#3498DB', linestyle='--', linewidth=2, 
           label=f'Média F2 = {mean_f2:.2f}')
ax1.axvline(mean_f1, color='#2ECC71', linestyle='--', linewidth=2,
           label=f'Média F1 = {mean_f1:.2f}')
ax1.set_title('Dados Originais', fontsize=14, pad=20)
ax1.set_xlabel('Feature 1 (Escala: -10 a 20)', fontsize=12)
ax1.set_ylabel('Feature 2 (Escala: -0.5 a 0.75)', fontsize=12)
ax1.grid(True, alpha=0.3)
ax1.legend(frameon=True, facecolor='white')

# Gráfico normalizado
scatter2 = ax2.scatter(X_norm[:,0], X_norm[:,1], c='#9B59B6', alpha=0.7, edgecolors='w', s=80)
ax2.axhline(0, color='black', linestyle='--', linewidth=1.5)
ax2.axvline(0, color='black', linestyle='--', linewidth=1.5)
ax2.set_title('Dados Normalizados (StandardScaler)', fontsize=14, pad=20)
ax2.set_xlabel('Feature 1 (Média=0, DP=1)', fontsize=12)
ax2.grid(True, alpha=0.3)

# Adicionando caixa de texto com estatísticas
stats_text = (f'Estatísticas Originais:\n'
              f'Feature 1: μ = {mean_f1:.2f}, σ = {std_f1:.2f}\n'
              f'Feature 2: μ = {mean_f2:.2f}, σ = {std_f2:.2f}')
fig.text(0.5, 0.02, stats_text, ha='center', fontsize=11,
         bbox=dict(facecolor='white', alpha=0.8))

plt.tight_layout()
plt.show()
