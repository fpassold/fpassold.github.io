'''
Gera gráfico de f(x) (transfer funtion) e sua derivada, f´(x) -- disponíveis no Keras
Fernando Passold, em 18/03/2025
''' 
import numpy as np
import matplotlib.pyplot as plt

'''
As 2 linhas de código abaixo são para suprimiar mensagens do tipo:
---
2025-03-18 10:38:39.435028: I tensorflow/core/platform/cpu_feature_guard.cc:193] 
This TensorFlow binary is optimized with oneAPI Deep Neural Network Library (oneDNN) 
to use the following CPU instructions in performance-critical operations:  AVX2 FMA
---
'''
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'  # Oculta avisos e informações do TensorFlow

import tensorflow as tf
from tensorflow.keras import activations

def plot_activation_function():
    act_name = input("Digite o nome da função de ativação (ex: relu, sigmoid, tanh): ").strip().lower()
    
    # Lista de funções de ativação disponíveis no Keras
    available_activations = {
        'relu', 'sigmoid', 'tanh', 'softplus', 'softsign',
        'selu', 'elu', 'exponential', 'swish', 'gelu',
        'exponential', 'linear' #, 'softmax'
    }

    if act_name not in available_activations:
        print(f"Erro: '{act_name}' não é uma função de ativação válida.")
        print("Funções válidas:", ", ".join(available_activations))
        return
    
    x_range = (-3, 3)
    num_points = 500
    x = np.linspace(x_range[0], x_range[1], num_points)
    x_tf = tf.Variable(x, dtype=tf.float32)

    # Obtém a função de ativação do Keras
    act_func = getattr(activations, act_name)
    
    with tf.GradientTape() as tape:
        tape.watch(x_tf)
        y = act_func(x_tf)  # f(x)
    
    dy_dx = tape.gradient(y, x_tf)  # f'(x)

    # Plot
    plt.figure(figsize=(8, 5))
    plt.plot(x, y.numpy(), label=f'{act_name}(x)', color='blue', linewidth=2)
    plt.plot(x, dy_dx.numpy(), label=f"{act_name}'(x)", color='red', linestyle='dashed', linewidth=2)
    plt.axhline(0, color='black', linewidth=0.5, linestyle='dotted')
    plt.axvline(0, color='black', linewidth=0.5, linestyle='dotted')
    plt.legend()
    plt.title(f'Função de Ativação: {act_name} e sua Derivada')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.grid(True)
    plt.show()

# Chama a função para entrada do usuário
plot_activation_function()
