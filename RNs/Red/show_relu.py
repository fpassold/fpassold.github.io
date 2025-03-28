'''
Script para exibir gráficos da f(x) e f´(x) associadas com transfer functions no Kera
Usa MatlabPlotLib
Fernando Passold, em 18/03/2025
'''

import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras import activations

def plot_activation_function(act_name, x_range=(-3, 3), num_points=500):
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

# Exemplo: Plotando a função 'relu'
plot_activation_function('relu')

# print("\nPressione Enter para fechar a janela gráfica...")
# input()  # Aguarda o usuário pressionar Enter
# plt.close()  # Fecha a janela gráfica
