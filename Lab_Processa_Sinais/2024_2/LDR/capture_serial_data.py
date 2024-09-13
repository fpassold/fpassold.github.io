# Captura dados da porta serial, tal qual foram enviados
# e cria arqiuvo texto refletindo os dados capturados
# Realiza um "dump" dos dados sendo recebidos pela porta serial
# Fernando Passold, em 19/06/2024

import serial
import threading
import os

# Configurações da porta serial
porta_serial = '/dev/cu.usbmodem14201'  # Substitua pelo nome da porta serial correta no seu macOS
taxa_baude = 115200 #9600

# Função para parar a captura quando uma tecla for pressionada
def espera_tecla():
    input("Pressione Enter para parar a captura de dados...\n")
    global capturando
    capturando = False

# Função principal para ler da porta serial e escrever no arquivo
def captura_dados():
    try:
        with serial.Serial(porta_serial, taxa_baude, timeout=1) as ser:
            with open('dados_capturados.txt', 'w') as arquivo:
                while capturando:
                    linha = ser.readline().decode('utf-8').strip()
                    if linha:
                        print(linha)
                        arquivo.write(linha + '\n')
    except serial.SerialException as e:
        print(f"Erro ao acessar a porta serial: {e}")
    except OSError as e:
        print(f"Erro ao abrir o arquivo: {e}")

# Variável global para controlar a captura
capturando = True

# Inicia a captura de dados em uma thread separada
thread_captura = threading.Thread(target=captura_dados)
thread_captura.start()

# Espera o usuário pressionar uma tecla para parar a captura
espera_tecla()

# Aguarda a thread de captura finalizar
thread_captura.join()

print("Captura de dados finalizada.")
