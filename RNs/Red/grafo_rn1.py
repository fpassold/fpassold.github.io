"""
A ideia aqui é criar um gráfico que represente as conexões entre os
neurônios de uma rede neural MLP, onde a espessura e a cor das linhas
são proporcionais aos pesos das conexões, diferenciando pesos
positivos (azul) e negativos (vermelho).

Serão usadas bibliotecas como matplotlib e networkx em Python para criar
esse tipo de visualização.

Eventualmente será necessário fazer: `% conda install networkx` 

Fernando Passold, em 02/04/2025
"""
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt

# Definir a arquitetura da rede
input_neurons = 6
hidden_neurons = 3
output_neurons = 7

# Criar um grafo direcionado
G = nx.DiGraph()

# Adicionar nós (neurônios) para cada camada
G.add_nodes_from([f'Input_{i}' for i in range(input_neurons)], layer=0)
G.add_nodes_from([f'Hidden_{i}' for i in range(hidden_neurons)], layer=1)
G.add_nodes_from([f'Output_{i}' for i in range(output_neurons)], layer=2)

# Gerar pesos aleatórios (substitua pelos seus pesos reais)
np.random.seed(42)
weights_input_hidden = np.random.randn(input_neurons, hidden_neurons)  # Pesos entre entrada e camada oculta
weights_hidden_output = np.random.randn(hidden_neurons, output_neurons)  # Pesos entre camada oculta e saída

# Adicionar arestas (conexões) com pesos
for i in range(input_neurons):
    for h in range(hidden_neurons):
        G.add_edge(f'Input_{i}', f'Hidden_{h}', weight=weights_input_hidden[i, h])

for h in range(hidden_neurons):
    for o in range(output_neurons):
        G.add_edge(f'Hidden_{h}', f'Output_{o}', weight=weights_hidden_output[h, o])

# Posicionar os nós em camadas verticais
pos = {}
for i in range(input_neurons):
    pos[f'Input_{i}'] = (0, -i)

for h in range(hidden_neurons):
    pos[f'Hidden_{h}'] = (1, -h)

for o in range(output_neurons):
    pos[f'Output_{o}'] = (2, -o)

# Plotar o grafo
plt.figure(figsize=(10, 8))

# Extrair pesos e cores das arestas
edges = G.edges()
weights = [G[u][v]['weight'] for u, v in edges]
colors = ['blue' if w > 0 else 'red' for w in weights]
widths = [abs(w) * 2 for w in weights]  # Ajuste o fator de escala para a espessura

# Desenhar o grafo
nx.draw(G, pos, with_labels=True, node_color='lightgray', 
       edge_color=colors, width=widths, node_size=800,
       arrows=True, arrowstyle='->', arrowsize=15)

# Adicionar uma barra de cores para indicar a escala dos pesos
sm = plt.cm.ScalarMappable(cmap=plt.cm.coolwarm, 
                           norm=plt.Normalize(vmin=min(weights), vmax=max(weights)))
sm.set_array([])
cbar = plt.colorbar(sm, ax=plt.gca(), orientation='vertical', fraction=0.02, pad=0.1)
cbar.set_label('Peso da Conexão')

plt.title("Visualização da Rede Neural MLP (Pesos das Conexões)")
plt.show()
