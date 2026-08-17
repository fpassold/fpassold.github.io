"""
Script python para renderizar arquivo .mmd Mermaid

Eventualmente necessário instalar biblioteca:
$ pip install requests

Fernando Passold, em 16/08/2026
"""
import base64
import requests

def renderizar_mmd_para_png(arquivo_entrada, arquivo_saida):
    try:
        # 1. Lê o código do arquivo .mmd
        with open(arquivo_entrada, "r", encoding="utf-8") as f:
            codigo_mermaid = f.read()
        
        # 2. Transforma o texto em Base64 para enviar via URL
        codigo_bytes = codigo_mermaid.encode("utf-8")
        base64_bytes = base64.b64encode(codigo_bytes)
        base64_string = base64_bytes.decode("utf-8")
        
        # 3. Monta a URL de requisição para o servidor oficial do Mermaid
        url = f"https://mermaid.ink{base64_string}"
        
        # 4. Faz o download da imagem gerada
        print(f"Enviando '{arquivo_entrada}' para renderização...")
        resposta = requests.get(url)
        
        if resposta.status_code == 200:
            with open(arquivo_saida, "wb") as f_img:
                f_img.write(resposta.content)
            print(f"Sucesso! Arquivo gerado em: {arquivo_saida}")
        else:
            print(f"Erro no servidor: Código {resposta.status_code}. Verifique a sintaxe do seu Mermaid.")
            
    except FileNotFoundError:
        print(f"Erro: O arquivo '{arquivo_entrada}' não foi encontrado.")
    except Exception as e:
        print(f"Ocorreu um erro inesperado: {e}")

if __name__ == "__main__":
    # Ajuste os nomes dos arquivos conforme sua necessidade
    renderizar_mmd_para_png("resumo_final_laplace.mmd", "resumo_final_laplace.png")
