# Código Python para dados da Porta Serial

**Problema**:

Gostaria de um código feito em Python para rodar no MacOS capaz de ler um conjunto de dados à partir da porta serial/USB. Uma placa Arduino gera via porta serial, linhas de dados consistindo em 3 colunas de números float, separados por vírgula, tabulação e espaço em branco. A idéia é o código em Python capturar estes dados e ser capaz de atualizar um gráfico em "temo-real" ou ao menos um conjunto das 1500 amostras que recebeu. Espero um código simples, pequeno, legível, onde o usuário facilmente ainda indicar em que porta a placa Arduino está conectada.

**Solução** (Chat GPT 3.5):

Claro! Abaixo está um código Python que faz o que você precisa utilizando a biblioteca `serial` para ler os dados da porta serial e a biblioteca `matplotlib` para plotar o gráfico em tempo real.

Certifique-se de ter as bibliotecas `matplotlib` e `pyserial` instaladas no seu ambiente Python. Você pode instalá-las usando pip:

```
pip install matplotlib pyserial
```

Aqui está o código:

```python
import serial
import matplotlib.pyplot as plt

# Função para atualizar o gráfico em tempo real
def update_plot(data):
    plt.clf()  # Limpa o gráfico atual
    plt.plot(data)  # Plota os novos dados
    plt.pause(0.01)  # Pausa para permitir a atualização do gráfico

# Configurações da porta serial
port_name = input("Digite o nome da porta serial (ex: /dev/ttyUSB0): ")
baud_rate = 9600  # Taxa de transmissão da porta serial

# Inicializa a conexão serial
try:
    ser = serial.Serial(port_name, baud_rate)
    print("Conexão serial estabelecida.")
except serial.SerialException:
    print("Erro ao abrir a porta serial. Verifique se o dispositivo está conectado corretamente e se o nome da porta está correto.")
    exit()

# Configurações do gráfico
plt.ion()  # Modo interativo para atualizar o gráfico em tempo real
plt.figure(figsize=(10, 6))
plt.title('Dados Recebidos')
plt.xlabel('Amostras')
plt.ylabel('Valor')
data = []  # Lista para armazenar os dados recebidos

# Loop para receber e plotar os dados
try:
    while True:
        line = ser.readline().decode().strip()  # Lê uma linha da porta serial
        if line:
            # Divide a linha em valores float
            values = [float(val) for val in line.split(',')]
            data.extend(values)  # Adiciona os valores à lista de dados
            update_plot(data[-1500:])  # Atualiza o gráfico com as últimas 1500 amostras
except KeyboardInterrupt:
    print("Programa encerrado pelo usuário.")
finally:
    ser.close()  # Fecha a conexão serial
    plt.ioff()  # Desativa o modo interativo
    plt.show()  # Exibe o gráfico final
```

Este código solicitará ao usuário que insira o nome da porta serial onde o Arduino está conectado. Ele então abrirá uma janela do matplotlib para exibir o gráfico em tempo real dos dados recebidos. O gráfico será atualizado a cada vez que novos dados forem recebidos da porta serial. O programa pode ser encerrado pressionando `Ctrl + C`.

**Problema 2**:

Hum... existe uma forma do Python listar possíveis portas serias onde uma placa Arduíno possa estar conectada?

**Resposta**:

Sim, é possível listar as portas seriais disponíveis no sistema usando o módulo `serial.tools.list_ports`. Este módulo fornece uma função chamada `comports()` que retorna uma lista de objetos `SerialPortInfo` representando as portas seriais disponíveis.

Aqui está como você pode modificá-lo para listar as portas seriais disponíveis antes de solicitar ao usuário que escolha uma:

```python
import serial.tools.list_ports

# Função para listar as portas seriais disponíveis
def list_serial_ports():
    ports = serial.tools.list_ports.comports()
    if ports:
        print("Portas seriais disponíveis:")
        for port in ports:
            print(port.device)
    else:
        print("Nenhuma porta serial disponível.")

# Listar as portas seriais disponíveis
list_serial_ports()

# Agora, solicitar ao usuário que escolha uma porta serial
port_name = input("Digite o nome da porta serial (ex: /dev/ttyUSB0): ")
```

Este código irá listar todas as portas seriais disponíveis no sistema antes de solicitar ao usuário que insira o nome da porta serial onde o Arduino está conectado. Isso pode ajudar o usuário a identificar facilmente a porta correta.

---

Fernando Passold, em 14/05/2024

