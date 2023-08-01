# Exercícios Sistemas de Codificação

## Convertendo bases:

### Ex$_5$: $453_{(5)}=?_{(10)}$

<details><summary>Resposta:</summary>
<p>

$=4\times 5^2 + \cancel{5}^{\text{não existe}}\times5^1 + 3\times5^0 \quad \leftarrow$ Obs.: Este número não existe na base "5"

Note: base 5: 0, 1, 2, 3 e 4...

</p>
</details>

&nbsp;

### Ex$_{5b}$: $443_{(5)}=?_{(10)}$

<details><summary>Resposta:</summary>
<p>

$=4 \times 5^2 + 4 \times 5^1 + 3 \times 5^0$

$=100+20+3$

</p>
</details>

$=123$

&nbsp;

### Ex$_6$: 0x3456$=3456_{(16)}=?_{(10)}$

<details><summary>Resposta:</summary>
<p>

$=3\times 16^3 + 4 \times 16^2 + 5 \times 16^1 + 6 \times 16^0$

$=3 \times 4096 + 4 \times 256 + 80 + 6$

$= 12288 + 1024 + 86$

</p>
</details>

$=13398_{(10)}$

&nbsp;

### Ex$_9$: $117_{(10)}=?_{(5)}$

<details><summary>Resposta:</summary>
<p>

```
  117 / 5
- 115   23 / 5
    2  -20   4
         3
```

</p>
</details>

$117_{(10)}=432{(5)}$

&nbsp;

### Ex$_{10}$: $2.340.560_{(10)}=?_{(2)}$

<details><summary>Resposta:</summary>
<p>

Note: uma dica para este caso: ao invés de realizar sucessivas divisões por 2 (ou mesmo se for para ser resolvido pelo método de aproximações sucessivas), renderia uma boa quantidade de tempo para resolver. O mais prático é lembrar que cada algarismo hexadecimal = 4 bits e que é muito mais rápido executar sucessivas divisões por 16 do que por 2.

Resolvendo usando esta ideia:

```
  2340560 / 16
- 2340560   146285 / 16
        0  -146272   9142 / 16
                13  -9136   571 / 16
                        6  -560   35 / 16
                             11  -32    2
                                   3
```

Então: $2.340.560_{(10)}=23B6D0_{(16)}$

Como cada algarismo hexa = 4 bits, então:

$23B6D0_{(16)}=\underbrace{0010}_{=2}\;\underbrace{0011}_{3}\;\underbrace{1011}_{B}\;\underbrace{0110}_{6}\;\underbrace{1101}_{"13"=D}\;{\underbrace{0000}_{0}}_{(2)}$

</p>
</details>

$2.340.560_{(10)}=\underbrace{0010}_{=2}\;\underbrace{0011}_{3}\;\underbrace{1011}_{B}\;\underbrace{0110}_{6}\;\underbrace{1101}_{"13"=D}\;{\underbrace{0000}_{0}}_{(2)}$

&nbsp;

## Sobre código BCD:**

### Ex$_{11}$: Suponha que se queira transformar um dado na memória (temperatura) de um Arduino One para mostrá-lo num display de 7-segmentos x 2 algarismos. 

Ex.: temperatura = 22 (graus) 
<!-- binário no display: -->

<details><summary>Resposta:</summary>
<p>

1o-detalhe: necessidade de uso de 2 x displays;

2o-detalhe: cada display exige 4-bits (binário BCD)

temperatura$=22_{(10)}=0001\;0110_{(2)}$ $\leftarrow$ na memória do Arduino

Mas para o display deve ser gerado código BCD ($\ne$ binário):

Display: "22" $\rightarrow$ $2\;2_{(10)} \rightarrow \underbrace{0010}_{Dezenas}\;{\underbrace{0010}_{Unidades}}_{(2, BCD)}$

Note que a sequencia de bits entre a informação estocada na memória do Arduino e a sequencia de bits que deve ser usada para passar dados para displays de 7-segmentos é bem diferente!

</p>
</details>

&nbsp;

### Ex$_{12}$: Suponha um Encoder Absoluto de 13 bits, qual seria sua resolução?

Resolução disco de Gray de 13-bits:

<details><summary>Resposta: 0,0439453125 (graus)</summary>
<p>

$360^{o} \div 2^{13}=360 \div 8192 = 0,0439453125$ (graus)

</p>
</details>

---

Fernando Passold, em 23.03.2021