# Ver versão_5.md

import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
import numpy as np
import time
import matplotlib.pyplot as plt  # Importando a biblioteca para gráficos

# Função para exibir a barra de caracteres
def bargraph(value, max_length=10):
    """
    Retorna uma string com caracteres '#' proporcional ao valor.
    - value: Valor de ativação (entre 0 e 1).
    - max_length: Número máximo de caracteres '#' (padrão é 10).
    """
    num_hashes = round(value * max_length)  # Arredonda para o número inteiro mais próximo
    return '#' * num_hashes

# Função para exibir os labels das entradas ativadas
def activated_inputs(input_data, input_labels):
    """
    Retorna uma string com os labels das entradas ativadas (valor = 1).
    - input_data: Dados de entrada (array binário).
    - input_labels: Lista de labels correspondentes às entradas.
    """
    activated = [input_labels[i] for i, value in enumerate(input_data) if value == 1]
    return ', '.join(activated)

# Função para calcular o comprimento máximo dos labels
def max_label_length(labels):
    """
    Retorna o comprimento da maior string em uma lista de labels.
    - labels: Lista de strings.
    """
    return max(len(label) for label in labels)

# Definindo o modelo
model = Sequential()

# Camada de entrada e única camada oculta
model.add(Dense(units=3, input_dim=6, activation='sigmoid', name='hidden_layer'))  # 6 entradas e 3 neurônios na camada oculta

# Camada de saída
model.add(Dense(units=7, activation='sigmoid', name='output_layer'))  # 7 neurônios na camada de saída

# Compilando o modelo
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

# Resumo do modelo
model.summary()

# Dados de exemplo (6 características binárias)
X_train = np.array([
    [0, 1, 0, 1, 0, 1],  # Exemplo 1
    [1, 0, 1, 0, 1, 0],  # Exemplo 2
    [0, 0, 1, 1, 0, 0]   # Exemplo 3
])

# Rótulos de treinamento (exemplo)
y_train = np.array([
    [0, 1, 0, 1, 0, 1, 0],  # Rótulo para o Exemplo 1
    [1, 0, 1, 0, 1, 0, 1],  # Rótulo para o Exemplo 2
    [0, 0, 1, 1, 0, 0, 1]    # Rótulo para o Exemplo 3
])

# Labels para as entradas
input_labels = ["Entrada 1", "Entrada 2", "Entrada 3", "Entrada 4", "Entrada 5", "Entrada 6"]

# Labels para as saídas
output_labels = ["Saída 1", "Saída 2", "Saída 3", "Saída 4", "Saída 5", "Saída 6", "Saída 7"]

# Calcula o comprimento máximo dos labels de entrada e saída
max_input_label_length = max_label_length(input_labels)
max_output_label_length = max_label_length(output_labels)
max_label_length_total = max(max_input_label_length, max_output_label_length)

# Listas para armazenar as métricas de treinamento
loss_history = []
accuracy_history = []

# Função de callback para atualizar o gráfico a cada época
class TrainingPlot(tf.keras.callbacks.Callback):
    def on_train_begin(self, logs={}):
        # Inicializa a figura
        plt.ion()  # Ativa o modo interativo do matplotlib
        self.fig, (self.ax1, self.ax2) = plt.subplots(2, 1, figsize=(8, 6))
        self.fig.suptitle('Evolução do Treinamento')
        self.ax1.set_ylabel('Loss')
        self.ax2.set_ylabel('Accuracy')
        self.ax2.set_xlabel('Epoch')
        self.loss_line, = self.ax1.plot([], [], 'r-', label='Loss')
        self.accuracy_line, = self.ax2.plot([], [], 'b-', label='Accuracy')
        self.ax1.legend()
        self.ax2.legend()
        plt.show()

    def on_epoch_end(self, epoch, logs={}):
        # Atualiza as listas de métricas
        loss_history.append(logs.get('loss'))
        accuracy_history.append(logs.get('accuracy'))

        # Atualiza os dados do gráfico
        self.loss_line.set_data(range(len(loss_history)), loss_history)
        self.accuracy_line.set_data(range(len(accuracy_history)), accuracy_history)

        # Ajusta os limites dos eixos
        self.ax1.relim()
        self.ax1.autoscale_view()
        self.ax2.relim()
        self.ax2.autoscale_view()

        # Redesenha a figura
        self.fig.canvas.draw()
        plt.pause(0.1)  # Pausa para atualizar a janela gráfica

# Criando uma instância do callback
plot_callback = TrainingPlot()

# Medindo o tempo de processamento do treinamento
start_time = time.time()  # Captura o tempo inicial

# Treinando o modelo com o callback
model.fit(X_train, y_train, epochs=50, batch_size=1, verbose=0, callbacks=[plot_callback])

end_time = time.time()  # Captura o tempo final
training_time = end_time - start_time  # Calcula o tempo total de treinamento

# Exibindo o tempo de processamento
print(f"\nTempo de processamento do treinamento: {training_time:.2f} segundos")

# Fazendo previsões
predictions = model.predict(X_train)

# Exibindo as previsões com barras de caracteres e entradas ativadas
for i, (input_data, pred) in enumerate(zip(X_train, predictions)):
    print(f"\nExemplo {i + 1}:")
    # Exibe os labels das entradas ativadas
    activated = activated_inputs(input_data, input_labels)
    print(f"  Entradas ativadas: {activated}")
    # Exibe as saídas com barras de caracteres e formatação alinhada
    for j, value in enumerate(pred):
        # Formata o label da saída para ocupar o mesmo espaço que o maior label
        formatted_label = output_labels[j].ljust(max_label_length_total)
        bar = bargraph(value)  # Gera a barra de caracteres
        print(f"  {formatted_label}: {value:.4f} | {bar}")
