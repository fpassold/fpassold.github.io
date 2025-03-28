'''
A função softmax é amplamente utilizada para transformar as saídas de uma rede neural em uma distribuição de probabilidade, o que é particularmente útil em tarefas de classificação multi-classe.
A Softmax é frequentemente usada na última camada de redes neurais para problemas de classificação multiclasse, pois converte logits em probabilidades normalizadas.
Atenção: O TensorFlow exige que a função softmax seja aplicada em tensores 2D ou superiores. Se for um vetor 1D, o comportamento pode ser inesperado.

Explicação
* `tf.reshape(x, (1, -1))` → Converte x para 2D (necessário para Softmax).
* `softmax(...)` → Aplica a Softmax corretamente.
* `tf.reshape(y, (-1,))` → Retorna o tensor para a forma 1D original.

Fernando Passold, em 18/03/2025
'''
import tensorflow as tf
from tensorflow.keras.activations import softmax

x = tf.constant([1.0, 2.0, 3.0])  # Tensor 1D

# Expande para 2D (batch_size=1, features=3), aplica softmax e depois reduz de volta
y = softmax(tf.reshape(x, (1, -1)))
y = tf.reshape(y, (-1,))  # Converte de volta para 1D

print(y.numpy())  # Saída correta

'''
Exemplo de saída gerada:
[0.09003057 0.24472848 0.66524094]
'''