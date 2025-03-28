"""
Fernando Passold, em 17/03/2025

Inicializando rede do Chapeuzinho Vermlho - parte 1
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

# Resumo do modelo
model.summary()
