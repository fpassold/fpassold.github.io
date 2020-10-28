# Implementando rotindas de controle digital

Seja um controlador digital:



cuja equação genérica seja dada por:
$$
C(z)=\dfrac{K(z-a)}{(z-b)}
$$

```
          +------+
E(z) ---> | C(z) | ---> U(z)
          +------+
```

$$
C(z)=\dfrac{U(z)}{E(z)}
$$

$U(z)=E(z)\cdot C(z)$

$\dfrac{U(z)}{E(z)}=\dfrac{K(z-a)}{(z-b)}$

$\dfrac{U(z)}{E(z)}=\dfrac{K(z-a)}{(z-b)} \cdot \dfrac{z^{-1}}{z^{-1}}$

$\dfrac{U(z)}{E(z)}=\dfrac{K(1-a\cdot z^{-1})}{(1-b\cdot z^{-1})}$

$U(z)(1-b\cdot z^{-1})=E(z)\cdot K(1-a\cdot z^{-1})$

$U(z)=E(z)\cdot K -K\cdot a \cdot z^{-1}E(z) +b\cdot z^{-1}U(z)$

Transformando eq. anterior em ea. de diferenças teremos:

$u[k]=K \cdot e[k] - K \cdot a \cdot e[k-1] + b \cdot u[k-1]$

Onde:

$u[k]$: sinal de controle atual;

$u[k-1]$ = amostra passada do sinal de controle; $\rightarrow$ u1 (variável que guarda valor de 1 amostra passada de u);

$e[k]$=sinal do erro (instantêneo):

$e[k]=r[k]-y[k]$ $\quad \leftarrow$ calculado pelo $\mu$C.

$e[k-1]$= 1 amostra passada do erro.



No $\mu$C:



* Rontina de "Init()"

  ```c
  void Init(){
  	// inicializando amostras passadas
  	u1=0;
  	e1=0;
  }
  ```

  

* Rotina do Algoritmo de Controle:

  ```c
  void isr_AlgoCtrl(){
  	// Rotina do algoritmo de controle
  	// Lê sensor da planta --> y[k]
  	y = le_sensor(canal_AD);
  	// calculando erro instântaneo
  	e = r - y;
  	u = K*e - K*a*e1 + b*u1;
  	// saida_motor(u);
  	set_pwm(u);
  	// atualiza amostras atrasadas
  	u1 = u;
  	e1 = e;
  }
  ```

Note:

* as variáveis: y, e, u, r, K, a, b, u1 e e1 $\leftarrow$ **globais**

Como se usa?



Programa em C $\rightarrow$ main():

```c
void main(){
  // prepara variaveis 
  Init();
  // inicializa interrupção por software
  // associa um timmer do uC para gerar o meu "T" (periodo de amostragem)
  set_timmer0=20000; // gerar overflow a cada 100 ms
  isr_AlgoCtr(timmer0); // associo rotina de tratamento de interrupção com
  // overflow do timmer0
  start_isr_AlgoCtrl(); // efetivamente libera timmer0 e interrupção associada
  // para funcionar
  while(not("ESC")){
    // lê teclado
    tecla=le_teclado();
    if tecla=="↑" K++;
    if tecla=="↓" K--;
    if tecla=="r↑" r++;
    if tecla=="r↓" r--;
    // atualiza display
    update_display();
  }
}
```

