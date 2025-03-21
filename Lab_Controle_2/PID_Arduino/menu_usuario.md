# "Menu" de opções

A placa Arduino com o algoritmo do PID foi programada de tal forma a permitir interação com o usuário via porta serla (USB) usando o "monitor Serial" da própria interface de programação do Arduíno ou usando algum programa para comunicação serial como o Putty no Windows.

Para tanto, a placa reconhece alguns comandos enviados via porta serial. Seriam eles:

| Comando (String) | Significado (Observações) |
| :--- | :--- |
| v | Liga/Desliga **modo "verbouse"**, que dá retorno texto (ou não) sobre os comandos enviados à placa |
| s | **Status** = pedido de "Status" do sistema, isto é,<br>Publica informações sobre estado atual do sistema, ganhos do controlador, etc |
| a | Modo **Automático/Manual**: alterna entre modo manual ou modo automático<br>`a 0` = desliga modo automático, ou<br>`a 1` = liga modo automático. |
| u \<valor\> | Permite ajustar diretamente o **valor de $u[kT]$**, útil no modo manual para comandar o motor manualmente. Aceita `u 0` por exemplo, em qualquer instante de tempo. |
| r \<valor\> | Permite alterar diretamente (e manualmente) a referência (*set point*) ou $r[kT]$. |
| p \<valor\> | Permite ajustar o **Ganho Proporcional**, $K_p$ do controlador |
| d \<valor\> | Permite ajustar o **Ganho Derivativo**, $K_d$ do controlador |
| i \<valor\> | Permite ajustar o **Ganho Integrativo**, $K_d$ do controlador |
| l \<valor\> | Permite ajustar o **fator Alpha**, $\alpha$, do **filtro derivativo**.<br>*Obs*: Se $\alpha=0 \quad \Rightarrow$ **nada é filtrado** ($f[k]=e[k]$).<br>Se $\alpha=1 \quad \Rightarrow$ o sinal de entrada é ignorado ($f[k]=0$). |
| m | **Mute** = liga/desliga feedback sonoro (beep) gerado pela placa toda vez que recebe comando pela porta serial.<br>`m 0`= desativa mude |
| k | **Derivative Kick** (evita ou não).<br>Se ativado. o cálculo da ação derivativa ocorre sobre o sinal de saída da planta, $y[kT]$ e não sobre o sinal do erro, $e[kT]$.<br>Útil para evitar *kicks* da saída de controle, se o valor da referência é alterado de forma abrupta ("step's").<br>`k 0`= sem derivative kick;<br>`k 1`= evitando derivative kick. |
| f \<valor\> | **Frequência da onda quadrada**. Se $valor>0$ passa a gerar onda quadrada como sinal de referência, com o valor da frequencia igual a \<valor\> (em Hz). |
| ? \<valor\> | Alera valor do "pico superior" da onda quadrada. |
| ? \<valor\> | Alera valor do "pico inferior" da onda quadrada. |
| ? | **Guarda $K_u$**. Guarda (internamente) o valor atual do parâmetro $K_p$ como $K_u=$ *Ultimate Gain*, útil para usar no algoritmo de ajuste automático do PID |
| ? | Recarrega valores "default" para os parâmetros do PID |
| ? | Recalcula os novos valores dos parâmetros $K_p$, $K_i$ e $K_d$ com base no último valor guardado para o *Ultimate Gain*, $Ku$.<br>*Obs.:*Necessita a varíavel $T_u$ (período da oscilação) para completar os cálculos).<br>Opção ainda não implementada! |

Observações finais....

---

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("Fernando Passold, em " + LastUpdated); // End Hiding -->
</script>
