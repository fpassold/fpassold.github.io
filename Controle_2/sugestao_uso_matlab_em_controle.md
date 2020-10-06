<img src="justin-luebke-SmAiLn-nnJg_copia.jpg" alt="justin-luebke-SmAiLn-nnJg_copia.jpg" width="700"" />

[🎵WHTKD: Say to Me](https://soundcloud.com/whtkd/say-to-me)

</br>

**Índice**

* [1. Chavear Diretório no Matlab](#chavear)
* [2. Ativando **Diary**](#diary)
* [3. Gerando arquivo texto Markdown](#ger_markdown)
* [4. Anexando figuras ao arquivo Markdown](#add_fig_markdown)
* [5. Salvando imagens do Matlab](#save_fig_matlab)
  * [Escalonando figuras](#zoom_figures)
* [6. Encerrando trabalho no Matlab (**>> Save**)](#matlab_save)
* [7. Fechar Diary (**>> diary off**)](#diary_off)
* [8. Resultados (exemplo)](#resultados)
* [9. Ajustando arquivo texto (diary) para formato Markdown](#adjust2markdown)
  * [Inserindo equações no documento Markdown](#insertEquations)
* [Inserindo código/comandos do Matlab](#code_matlab)
* [Opções de escalonamento de figuras no Markdown](#adjust_figs)
* [**Resumo**](#resumo)
* [Referências sobre Markdown](#ref_markdonw)
  * [Editor on-line de equações](#equation_editors)

</br>
</br>

# Sugestões para uso do MATLAB nas aulas de Controle

Segue-se sugestões para utilização mais prática e eficaz do `MATLAB` na aulas de **Controle Automático**. 

O objetivo principal aqui é **criar um arquivo texto** fácil de ser editado e **fácil de ser exportado para página `html`** incluíndo figuras, gráficos do `MATLAB` e comandos usados no `MATLAB`) para resumir as aulas e conteúdo sendo explorado na disciplina de Controle Automático). Uma opção para gerar este tipo de documento seria usar processadores de texto usuais como o Office Word por exemplo. Mas existe umna forma mais prática e ráapida.

O `MATLAB` permite criar um "diário" (arquivo texto) refletindo os comandos e resultados obtidos na janela de comandos (*CLI* = *_C_omand _L_ine _I_nterface*) do mesmo.

E o `MATLAB` através dos comandos **save \<file>** (e contra-parte: **load \<file>**) permite salvar todas as variárias (com valores) gerados em determinada seção de trabalho no mesmo.

Conciliar os comandos **diary**, **save** e **load** do `MATLAB` podem permitir agilizar a operação das aulas de controle automático e facilitar bastante o seu registro (para posterior revisão/estudo).

## Passos

<a name="chavear"></a>
### 1. Chavear MATLAB para diretório atual de trabalho

​Antes de criar um arquivo texto "diário" e considerando-se que seja interessante de alguma forma incorporar neste "diário" os resultados gráficos obtidos, recomenda-se fortemente que, **antes de executar os próximos comandos**, que o usuário, **chaveie o `MATLAB` para o diretório no qual pretende concentrar o aquivo "diário" à ser criado e os arquivos gráficos (figuras)** -- preferencialmente num diretório diferente do padrão usado pelo `MATLAB` que é `~/Documentos/MATLAB`.
Para forçar o `MATLAB` para determinando diretório você pode na CLI usar o comando `cd` para forçar o `MATLAB` até o diretório correto ou simplesmente usar a barra superior da CLI do `MATLAB` e ajustar o diretório de trabalho para outro que não seja **~/Documentos/MATLAB** (o padrão adotado pelo Matlab):
    
<img src="mudando_diretorio_trabalho_matlab.jpg" alt="figura" width="700"/>

Por exemplo, neste caso, se está concentrando os arquivos gerados nesta seção de trabalho no diretório `~/Documents/UPF/Controle_II/6_Usando_RL_Projetos`. O local atual do diretório sendo usado pelo `MATLAB` pode ser confirmada usando comando **pwd**:

```matlab
>> pwd
ans =
    '/Users/fernandopassold/Documents/UPF/Controle_II/6_Usando_RL_Projetos'
>>
```

​Eventualmente, você pode criar uma nova pasta de dentro do Matlab (sem ter que recorrer ao Explorer), usando o comando **mkdir** (*make directory*), o mesmo usado em sistemas Linux. No exemplo abaixo, estamos criando a pasta "/2020\_2" a partir do diretório anterior "/6\_Usando\_RL\_Projetos", para tando foi feito:

```matlab
>> mkdir 2020_2  % cria a pasta "2020_2" à partir do diretório atual
>> cd 2020_2     % chaveira para este diretório
>> pwd           % verificando diretório atual de trabalho:
ans =
    '/Volumes/Data/Users/fernandopassold/Documents/UPF/Controle_2/6_Projetos_via_RL/2020_2'
>> format compact % comando para compactar mensagens de texto geradas pelo Matlab
>> format short   % comando para usar menos dígitos para informações numéricas
```

<a name="diary"></a>
### 2. Ativando o 'diary'

​Uma vez decidido em que diretório serão concetrados os arquivos gerados na atual seção de trabalho, o arquivo "diário" pode ser criado simplesmente usando o comando "**diary** <nome_arquivo>.txt":

```matlab
>> diary aula_12_09_2019.txt % daqui por diante um arquivo texto de nome "aula_12_09_2019.txt" está sendo criado
```

<a name="ger_markdown"></a>
### 3. Gerando arquivo texto no formato Markdown

​No caso anterior, os próximos comandos seguintes ao `diary` serão todos gravados no arquivo texto `aula_12_09_2019.txt`. É gerado algo similar a um arquivo de "log". Este arquivo pode ser editado por qualquer editor de textos comum como o `Notepad` (no Windows) ou `TextEditor` (no Mac) ou `nano` (na CLI de um sistema Linux). 

​Sugere-se o uso de editores de texto mais poderosos como o [Sublime Text](https://www.sublimetext.com) (multiplataforma) ou adotar diretamente algum ==**editor de textos compatível com Markdown**==:

* http://pad.haroopress.com (disponível para Windows, Linux, Mac)<br/>
  ![haroopad.png](haroopad.png)
* https://typora.io (também disponível para Windows, Linux, Mac)<br/>
  ![typora.gif](typora.gif)

​Se quiser saber mais sobre markdown ☞ [O que é Markdown](https://www.markdownguide.org/getting-started), [Página Wikipedia sobre Markdown](https://en.wikipedia.org/wiki/Markdown).

Note que todos os próximos comandos passados ao `MATLAB` serão automaticando repassados para o arquivo texto `<arquivo.txt>`, com excessão das figuras (gráficos criados no `MATLAB`).

<a name="add_fig_markdown"></a>
### 4. Acrescentando figuras ao arquivo Markdown (ou arquivo diary)

​	**Para "acrescentar" ao arquivo diary as figuras dos gráficos** gerados numa seção de trabalho no `MATLAB` a idéia é fazer uso da linguagem **Markdown**. Nesta linguagem, figuras podem ser incluídas num arquivo no formato final `.html` ou `.pdf` se no arquivo `.md` (ou arquivo texto compatível com Markdown) forem incorporados os comandos:

```markdown
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")
```

​No caso acima, a figura à ser acrescentada no arquivo é obtida diretamente via internet (neste caso, uma conexão online é necessária para que posteriormente a imagem seja visualizada).

​No nosso caso, a idéia é usar figuras criadas locamente (no seu próprio computador). Então o comando anterior se modifica ligeiramente para:

```markdown
![Texto alternativo](arquivo_imagem)
```

onde: `arquivo_imagem` pode ser um arquivo do tipo: `.jpg`, `.gif` (animado até), `.png` (preferir este tipo de arquivo).

​Recomenda-se **png** que resulta normalmetne arquivos menores (compactos), com boa resolução (se for possível especificar resolução, recomenda-se adotar 150 dpi).

<a name="save_fig_matlab"></a>
### 5. Salvando imagens à partir de gráficos do Matlab 

​Por exemplo, em determinado instante de uso do `MATLAB` podemos querer incluir no arquigo diário sendo criado, a figura (gráfico) do resultado gráfico da resposta ao degrau aplicado à determinada função transferência de malha-fechada. 

​Neste caso, **na janela de gráfico** (Figure \<No>) do `MATLAB` você deve selecionar:</br>
**File >> Save**, para gerar o arquivo com a figura desejada.

O `MATLAB` permite gravar vários formatos de imagens:

<img src="tipos_imagens_MATLAB.png" alt="tipos_imagens_MATLAB.png" width="700"/>

​Repare na figura anterior, no diretório onde estarão sendo gravadas as imagens/figuras (o mesmo para o qual chaveamos o Matlab no início deste texto).

​Recomenda-se que uma vez que a figura tenha sido salva, que **no MATLAB** (na janela de comandos enquanto se está trabalhando) se acrescente uma linha como:

```matlab
>> % Resposta ao degrau de diferentes controladores:
>> % ![step_integrador_puro.jpg](step_integrador_puro.jpg)
```

A sequencia de comandos acima será repassada para o arquivo texto (diary) sendo criado. Note que para o Matlab são apenas comentários (para não implicar erros no Matlab), mas quando o arquivo diary criado for aberto num editor compatível com markdown, o caracter "%" é ignorado (é impresso, mas não gera erro e pode removido do arquivo markdown) e ao lado de "%" já surge a figura (como no caso do Typora mostrado abaixo):

<img src="exemplo_inserindo_figura.png" alt="exemplo_inserindo_figura.png" width="700" />

**Obs.:** a opção anterior, inclui as figuras, mas não permite escalonar as figuras.

<a name="zoom_figures"></a>
#### Escalonar figuras?

**Se for desejado escalonar as figuras** usar outro comando (ou pouco mais complicado de lembrar):

```markdown
<img src="exemplo_inserindo_figura.png" alt="exemplo_inserindo_figura.png" style="zoom:50%;" />
```

ao invés de usar:

```markdown
![tipos_imagens_MATLAB.png](tipos_imagens_MATLAB.png)
```

O editor Typora permite usar a opção com escalonamento depois que foi realizada a seleção do arquivo da figura deseja. Basta depois do momento de selecionar o arquivo, clicar no botão direito do mouse para abrir propriedades, o que faz surgir uma caixa de diálogo flutuante com algumas opções de escalonamento. O próprio Typora passa do formato originalmente previsto para markdown para o formato HTML (acima). Por exemplo:

<img src="exemplo_incluir_escalonar_figura_typora.mp4" alt="exemplo_incluir_escalonar_figura_typora.mp4" style="zoom:67%;" />

<a name="matlab_save"></a>
==**IMPORTANTE**==

### 6. Encerrando trabalhos com Matlab $\rightarrow$ Save \<arquivo> 

​Ao final de uma seção de trabalho no `MATLAB`, recomenda-se salvar num **arquivo `.mat`** as variáveis criadas/usadas na atual seção de trabalho (variáveis do *workspace*) através do comando **save**, por exemplo:

```matlab
>> save planta
```

Note que neste caso, **não é necessário** se fornecer a extensão para o arquivo sendo criado. O próprio `MATLAB` assume que será criado o arquivo `planta.mat` para o caso do exemplo anterior.

<a name="diary_off"></a>
### 7. "Fechar" arquivo diary

​Recomenda-se também que o usuário "feche" o arquivo texto do diário, fazendo:

```matlab
>> diary off
```

Este comando efetivamente fecha o arquivo texto iniciado anteriormente. 
Atenção: No Windows, somente depois do **diary off** é que o arquivo texto criado ficará disponível no Explorer. Se o usuário esquecer de fornecer o comando `diary off` em máquina Windows, corre-se o risco de danificar o arquivo caso a máquina entre em hibernação, o usuário saia do `MATLAB` ou simplemente desligue o Windows.

<a name="resultados"></a>
### 8. Resultado final

Se não houve nenhum erro até aqui, deve constar no diretório atual de trabalho, o arquivo texto referente ao `diary` recém fechado e mais as figuras salvas enquanto se estava trabalhando no `MATLAB`.

Exemplo de conteúdo de um arquivo `.txt` criado no `MATLAB` via `diary`:

```matlab
format compact
format short
pwd
ans =
    '/Users/fernandopassold/Documents/UPF/Controle_II/6_Usando_RL_Projetos'

G=tf(1,poly([-1 -2 -10])) % ingressando dados da planta
G =
 
             1
  ------------------------
  s^3 + 13 s^2 + 32 s + 20
 
Continuous-time transfer function.

zpk(G)
ans =
 
          1
  ------------------
  (s+10) (s+2) (s+1)
 
Continuous-time zero/pole/gain model.

save planta
OS=10;
zeta = (-log(OS/100))/(sqrt(pi^2 + (log(OS/100)^2)))
zeta =
    0.5912

save planta
% grafico salvo como: step_integrador_puro.jpg
% ![step_integrador_puro.jpg](step_integrador_puro.jpg)
diary off
```

Note que o "prompt" (`>>`) do `MATLAB` não é repassado para o arquivo texto.

Como o arquivo texto criado não passa de um simples arquivo texto, sem figuras, recomenda-se passá-lo para o formato **Markdown**.

<a name="adjust2markdown"></a>
### 9. Transformar arquivo texto (resultado do Diary) para arquivo Markdown

​No Explorer (ou outro navegador de arquivos presente no seu sistema), **renomeie o arquivo `.txt`** recém criado **para `.md`**.

​Este arquivo `.md` pode ser editado em qualquer editor de textos simples ou outro compatível com Markdown.

​Edite o arquivo `.md` e retire os comentários (`%`) presentes no arquivo texto. Principalmente em linhas como:

```matlab
% grafico salvo como: step_integrador_puro.jpg
% ![step_integrador_puro.jpg](step_integrador_puro.jpg)
```

As linhas acima devem ficar algo como:

```markdown
Grafico à seguir mostra resultado da entrada degrau aplicada ao controlador
![step_integrador_puro.jpg](step_integrador_puro.jpg)
```

​Uma vez editado o arquivo `.md`, se o usuário estiver usando um editor de textos compatível com Markdown, pode então exigir que seja vizualizado um "Preview" mostrando o resultado da interpretação dos comandos Markdown contidos no arquivo texto.

A figura à seguir mostra o editor [Haroopad](http://pad.haroopress.com) (free e multiplataforma) usado para editar/interpretar arquivos texto compatíveis com Markdown. Este editor além de interpretar comandos Markdowns, interpreta equações incorporadas no arquivo texto (`.md`) usando formato **LaTeX**. Veja exemplos nas próximas figuras (se editor além de compatível com Markdown, estiver preparado para lidar com `MathJax` (rendering support library):

Abaixo seguem figuras de edição usando editor Haroopad:

<img src="Haroopad_uso_1.png" alt="Haroopad_uso_1.png" width="700" /><br/>

<img src="Uso_haroopad_2.png" alt="Uso_haroopad_2.png" width="700 /><br/>

---

.<a name="insertEquations"></a>
#### Incorporando equações no documento Markdown:

É simples engressar uma equação no formato compatível Markdown, basta introduzir a equação num formato compatível com LaTeX entre os caracteres `$$`.

Por exemplo

* Exemplo\_1:

  ```markdown
$$ C(s)=\dfrac{1}{(s+1)(s+2)(s+10)}$$
```

  produz:
  $$ C(s)=\dfrac{1}{(s+1)(s+2)(s+10)}$$


* Exemplo\_2:

  ```markdown
$$ \zeta = \dfrac{ -\log(OS/100) }{\sqrt{pi^2 + \log(OS/100)^2} }$$
```

  gera:
  $$ \zeta = \dfrac{ -\log(OS/100) }{\sqrt{pi^2 + \log(OS/100)^2} }$$

* Exemlo\_3:

  ```markdown
$$ \omega_n = \sigma / \zeta $$
```
  gera:
  $$ \omega_n = \sigma / \zeta $$

Note que as equações ou expressões matemáticas podem ser introduzidas no meio do texto:

* Exemplo\_4:

  ```markdown
Lembrando que $\%OS<10\%$ (O que resulta no $\zeta=0,5912 $).
```
  gera:<br/>
  Lembrando que $\%OS<10\%$ (O que resulta no $\zeta=0,5912 $).

---

<a name="code_matlab"></a>
### Ressaltando comandos do `MATLAB` 

Linhas de comando do `MATLAB` podem ser destacadas do texto, colocando as linhas de comandos entre 3 caracteres de crases, por exemplo:

<img src="figuras/edicao_markdown_exemplo_2.png" alt="edicao_markdown_exemplo_2.png" width="350"/>

O que gera:

 Entrando com a equação do controlador:
 $$C(s)=\frac{(s+0,1)}{(s+0,9)}$$
 no `MATLAB` fazemos:

 ```matlab
 >> C=tf([1 0.1],[1 0.9])
 >> % continuam trabalhos no Matlab...
 ```

---

<a name="adjust_figs"></a>
### Escalonando as figuras no arquivo Markdown 

- Durante a criação do `diary` ou durante a edição do arquivo **Markdown** uma forma de controlar o **tamanho das figuras** é incoporar diretamente código `html` no arquivo `.md`. Por exemplo:
 - Antes a inclusão de figuras era feita na forma:

  ```markdown
![figura](figura.png)
```
 - a idéia é substituir esta linha por:

  ```markdown
<img src="figura.png" alt="figura" width="500"/>
```
ou (mais explicitamente):

  ```markdown
<img src="figura.png" width="200" height="200" />
```
ou ainda por:

  ```markdown
<img src="figura.png" alt="exemplo_inserindo_figura" style="zoom:50%;" />
```

mas normalmente apenas o atributo `width` ou `zoom` já permite escalonar a figura de forma conveniente. Note que o atributo `alt` é opcional (não necessário).

---

<a name="resumo"></a>
## Resumo

<img src="uso_matlab_1.jpg" alt="uso_matlab_1.jpg" width=600 /> 

-----

<a name="ref_markdonw"></a>
## Mais Referências sobre Markdown

- [Markdown Cheat Sheet](https://www.markdownguide.org/cheat-sheet)

- [Markdown Cheat Sheet (github)](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

- [Markdown Getting Started](https://www.markdownguide.org/getting-started)

- [Dilinger: **editor web online de Markdown**](https://dillinger.io)

<a name="equation_editors"></a>
- [Writing Mathematic Fomulars in Markdown](http://csrgxtu.github.io/2015/03/20/Writing-Mathematic-Fomulars-in-Markdown/):<br/>
    <img src="Writing Mathematic Fomulars in Markdown -csrgxtu.github.io.png" alt="Writing Mathematic Fomulars in Markdown -csrgxtu.github.io.png" width="700" />

- [Editor online de equações no formato LaTeX: CodeCogs](https://www.codecogs.com/eqnedit.php):<br/>
  <img src="Editor_Online_de_Equações_LaTeX_png.png" width="700" />

- [Editor online de equações no formato LaTeX: LaTeX4technics](https://www.latex4technics.com)

- [Introdução à expressões matemáticas formato LaTeX do Overleaf](https://www.overleaf.com/learn/latex/Mathematical_expressions):<br/>
    <img src="help_equacoes_overleaf.png" alt="help_equacoes_overleaf.png" width="700" />

- [Overleaf: Editor online para documentos formato LaTeX](https://www.overleaf.com)

- Outra idéia (tendência): instalar "[Jupyter notebook](https://jupyter.org)"<br/> 
  [//]: # (<img src="exemplo_jupyter_c++.png" alt="exemplo_jupyter_c++.png" width="700" />)
  Para trabalhar com o `MATLAB` $\rightarrow$ [Install Jupyter-MATLAB](https://am111.readthedocs.io/en/latest/jmatlab_install.html), 
 
    Mas esta opção está disponível para usuários mais avançados, com conhecimento de linha de comandos no Linux ou Mac (ou o novo shell linux presente nas últimas versões do Windows). A página anterior funciona no Mac/Linux/Windows rodando MATLAB R2017a. Exige instalação do **Anaconda** e **Python > 3.5**.<br/> O resultado final seria algo próximo de:</br>
    <img src="jupyter_matlab.png" alt="jupyter_matlab.png" width="700" />

-----

Documento atualizado em 13/09/2019 e 05/10/2020 (c) Fernando Passold