* Erro para entrada degrau depende da constante $K_p$:

  $e_{step}(\infty)=\lim_{z \to 1} (z-1) \cdot \dfrac{1}{(1+FTMA(z))} \cdot \underbrace{\dfrac{z}{(z-1)}}_{\text{Degrau}}$

  $e_{step}(\infty)=\dfrac{1}{1+\lim_{z \to 1} FTMA(z)}=\dfrac{1}{(1+K_P)}$ 

  

* Para sistemas tipo 0,  $K_p \ge 0$:

  

  $K_p=\lim_{z \to 1} \dfrac{K(z-z_1)\cdots(z-z_n)}{(z-p_1)\cdots(z-p_m)}=cte_1$
   ou seja, um ganho de erro estático de posição, não nulo. E como $e_{Degrau}(\infty)=\dfrac{1}{1+K_p}=cte_2$, isto resulta em:
   $e_{Degrau}(\infty) \ge 0$   sempre!

  

* Para zerar (anular) o erro para uma entrada degrau, se faz necessário ao menos 1 integrador na malha de realimentação. Neste caso:

  

  $K_P=\lim_{z \to 1} FTMA(z)$

  $K_p=\lim_{z \to 1} \dfrac{K(z-z_1) \cdots (z-z_n)}{\underbrace{(z-1)^\textcolor{blue}{1}}_{\text{integrador}}(z-p_1)\cdots(z-p_m)}$

  $K_p=\dfrac{cte_1}{ \underbrace{(z-1)}_{\to 0} \cdot cte_2} = \dfrac{cte_1}{\to 0}=\infty$

  $e_{step}=\dfrac{1}{1+Kp}=\dfrac{1}{\infty}=0$

  

* Para zerar o erro para entrada rampa, são necessários __2__ integradores:

* O erro para entrada rampa é definido como:

  $e_{Ramp}(\infty)=\lim_{z \to 1} \cancel{(z-1)} \left[ \dfrac{1}{1+FTMA(z)}\right] \cdot \dfrac{T\;z}{ (z-1)^{\textcolor{blue}{\cancel{2}^1} } }$

  $e_{Ramp}(\infty)=\dfrac{T}{ \lim_{z \to 1} \; (z-1) \; FTMA(z) }=\dfrac{T}{K_v}$

  onde $K_v$ se refere ao ganho do erro estático de velocidade.



* Se a $FTMA(z)$ possui __2__ integradores, então:

  $K_v=\lim_{z \to 1} \; (z-1) \cdot FTMA(z)$  fica:

  $K_v=\lim_{z \to 1} \dfrac{ \cancel{(z-1)} \cdot K(z-z_1) \cdots (z-z_n)}{ (z-1)^{ \cancel{\textcolor{blue}{2}}^1 } (z-p_1) \cdots (z-p_m)}$

  $K_v=\dfrac{cte_1}{ \underbrace{\lim_{z \to 1}(z-1)}_{\to 0} \cdot cte_2}=\dfrac{cte_1}{\to0}=\infty$.

  $e_{Ramp}(\infty)=\dfrac{T}{K_v}=\dfrac{T}{\infty}=0$

  

* Se a $FTMA(z)$ possui 1 integrador, este erro fica:

  $K_v=\lim_{z \to 1} \dfrac{ \cancel{(z-1)} \cdot (z-z_1)\cdots(z-z_n)}{\cancel{(z-1)}^{\textcolor{blue}{1}}(z-p_1)\cdots(z-p_n)}$

  $K_v=\dfrac{cte_1}{cte_2}=cte_3$

  ou seja: $K_v \ge 0$, e então:

  $e_{Ramp}(\infty)=\dfrac{T}{K_v}=\dfrac{T}{cte_3}=cte_4$, ou seja, não é nulo (__mas limitado__).