"""
Fernando Passold, em 17/03/2025

Parte 1: Inicializando rede do Chapeuzinho Vermelho (rede MLP> 6 x 3 x 7)

"""
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense

# Definindo o modelo
model = Sequential()

# Camada de entrada e única camada oculta
model.add(Dense(units=3, input_dim=6, activation='sigmoid'))  # 6 entradas e 3 neurônios na camada oculta

# Camada de saída
model.add(Dense(units=7, activation='sigmoid'))  # 7 neurônios na camada de saída

# Compilando o modelo
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

#### Parte 2: Associando labels (etiquetas) às entradas e saída da rede

# Dados de entrada com labels
input_labels = ["1. Grandes orelhas", "2. Grandes olhos", "3. Grandes dentes", "4. Gentil", "5. Enrugado", "6. Bonito"]

# Dados de saída com labels
output_labels = ["1. Fugir", "2. Gritar", "3. Procurar pelo lenhador", "4. Beijar na bochecha", "5. Aproximar-se", "6. Oferecer comida", "7. Flertar"]

# Labels para os neurônios da camada oculta
hidden_layer_labels = ["1. Lobo", "2. Avó", "3. Lenhador"]

# Resumo do modelo
model.summary()

## Treinando a rede...

# Dados de treinamento (exemplo)
X_train = [
#    1  2  3  4  5  6
    [1, 1, 1, 0, 0, 0],  # É o Lobo 1
	[1, 1, 1, 0, 0, 1],  # É o Lobo 2
	[1, 0, 1, 1, 0, 0],  # É o Lobo 3
    [0, 1, 0, 1, 1, 1],  # É a Vovó 1
    [0, 1, 0, 1, 1, 0],  # É a Vovó 2
    [0, 0, 0, 1, 1, 1],  # É a Vovó 3
    [1, 0, 0, 1, 1, 0],  # É a Vovó 4
    [1, 0, 0, 1, 1, 1],  # É a Vovó 5
    [0, 0, 0, 1, 0, 0],  # É o Lenhador 1
    [0, 0, 0, 1, 0, 1],  # É o Lenhador 2
    [0, 0, 0, 1, 1, 0]   # É o Lenhador 3
]

# Rótulos de treinamento (exemplo)
y_train = [
#    1  2  3  4  5  6  7
    [1, 1, 1, 0, 0, 0, 0],  # Rótulo para Lobo 1
    [1, 0, 1, 0, 0, 0, 0],  # Rótulo para Lobo 2
    [1, 1, 1, 0, 0, 0, 0],  # Rótulo para Lobo 3
    [0, 0, 0, 1, 1, 1, 0],  # Rótulo para Vovó 1
    [0, 0, 0, 0, 1, 1, 0],  # Rótulo para Vovó 2
    [0, 0, 0, 0, 1, 1, 0],  # Rótulo para Vovó 3
    [0, 0, 0, 0, 1, 1, 0],  # Rótulo para Vovó 4
    [0, 0, 0, 1, 1, 1, 0],  # Rótulo para Vovó 5
    [0, 0, 0, 0, 1, 0, 1],  # Rótulo para Lenhador 1
    [0, 0, 0, 1, 1, 1, 1],  # Rótulo para Lenhador 2
    [0, 0, 0, 0, 1, 0, 0]   # Rótulo para Lenhador 3
]

## Exibindo resultados

# Treinando o modelo
model.fit(X_train, y_train, epochs=10, batch_size=1)

# Fazendo previsões
predictions = model.predict(X_train)

# Exibindo previsões com labels
for i, pred in enumerate(predictions):
    print(f"Exemplo {i + 1}:")
    for j, value in enumerate(pred):
        print(f"  {output_labels[j]}: {value:.4f}")
