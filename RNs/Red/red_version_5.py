"""
Fernando Passold, em 18/03/2025

Parte 1: Inicializando rede do Chapeuzinho Vermelho (rede MLP> 6 x 3 x 7)

"""
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
import numpy as np
import time  # Importando a biblioteca time para medir o tempo
import matplotlib.pyplot as plt  # Importando a biblioteca para gráficos
# Eventualmente será necessário `conda install matplotlib`

# Acrescentando Função para exibir exibe uma barra de caracteres # proporcional ao valor de ativação
def bargraph(value, max_length=20):
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

# Calcula o comprimento máximo dos labels de saida
max_input_label_length = max_label_length(output_labels)
# Isso é usado para determinar quantos espaços em branco devem ser adicionados aos labels menores.

# Labels para os neurônios da camada oculta
hidden_layer_labels = ["1. Lobo", "2. Avó", "3. Lenhador"]

# Resumo do modelo
model.summary()

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
        self.loss_line, = self.ax1.plot([], [], 'm-', label='Loss')
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

# Solicita ao usuário o número de épocas
try:
    epochs = int(input("Digite o número de épocas desejadas: "))
except ValueError:
    print("Entrada inválida. Usando o valor padrão de 50 épocas.")
    epochs = 50  # Valor padrão caso o usuário insira algo inválido

# Medindo o tempo de processamento do treinamento
start_time = time.time()  # Captura o tempo inicial

# Treinando o modelo
# model.fit(X_train, y_train, epochs=100, batch_size=1)

# Treinando o modelo com o callback
model.fit(X_train, y_train, epochs=epochs, batch_size=1, verbose=0, callbacks=[plot_callback])

end_time = time.time()  # Captura o tempo final
training_time = end_time - start_time  # Calcula o tempo total de treinamento

# Exibindo o tempo de processamento
print(f"\nTempo de processamento do treinamento: {training_time:.2f} segundos")

# Fazendo previsões
predictions = model.predict(X_train)

## Exibindo resultados

""" Saída mais "simples"
# Exibindo previsões com labels
for i, pred in enumerate(predictions):
    print(f"Exemplo {i + 1}:")
    for j, value in enumerate(pred):
    	bar = bargraph(value)  # Gera a barra de caracteres
        # print(f"  {output_labels[j]}: {value:.4f}")
        print(f"  {output_labels[j]}: {value:.4f} | {bar}")
"""

# Exibindo as previsões com barras de caracteres e entradas ativadas
for i, (input_data, pred) in enumerate(zip(X_train, predictions)):
    print(f"Exemplo {i + 1}:")
    # Exibe os labels das entradas ativadas
    activated = activated_inputs(input_data, input_labels)
    print(f"  Entradas ativadas: {activated}")
    # Exibe as saídas com barras de caracteres e formatação alinhada
    for j, value in enumerate(pred):
        bar = bargraph(value)  # Gera a barra de caracteres
        # print(f"  {output_labels[j]}: {value:.4f} | {bar}")
        # Formata o label da saída para ocupar o mesmo espaço que o maior label de entrada
        formatted_label = output_labels[j].ljust(max_input_label_length)       
        print(f"  {formatted_label}: {value:.4f} | {bar}")

# Congelando a janela gráfica até que o usuário pressione Enter
plt.ioff()  # Desativa o modo interativo
'''
plt.show(block=True)  # Mantém a janela gráfica aberta

Erro:
plt.show(block=True) bloqueia a execução do código até que a janela gráfica seja 
fechada manualmente, e o input() não é alcançado até que isso aconteça.

A solução é usar plt.pause() em vez de plt.show(block=True) e garantir que o 
input() seja alcançado após o treinamento.

Durante o treinamento, plt.pause(0.1) é usado para atualizar a janela gráfica a cada época.
Após o treinamento, o modo interativo é desativado com plt.ioff().
'''
print("\nPressione Enter para fechar a janela gráfica...")
input()  # Aguarda o usuário pressionar Enter
plt.close()  # Fecha a janela gráfica
