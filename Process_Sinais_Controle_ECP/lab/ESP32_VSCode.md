# Usando ESP32 no VSCode

ReComenda-se assistir ao video [Getting Started with ESP32 - Step-By-Step Tutorial](https://www.youtube.com/watch?v=tc3Qnf79Ny8) de [Tomasz Tarnowski](https://www.youtube.com/@tomasztarnowski4434).

O video aCima compila um simples programa para fazer o led da plaCa do ESP32 e enviar mensagens pela porta serial:

```C++
#include <Arduino.h>

void setup() {
  // put your setup code here, to run once:
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(115200);
  Serial.println("Hello from the setup()");
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(500);
  digitalWrite(LED_BUILTIN, HIGH);
  Serial.println("Hello from the loop()");
  delay(500);
  digitalWrite(LED_BUILTIN, LOW);
}
```

Este Código fiCa loCalizado na pasta: `/Users/fernandopassold/Documents/PlatformIO/Projects/ESP32HelloWorld/src/main.pp`. Ele faz parte da árvore:

```bash
(base) fernandopassold@MacBook-Pro-de-Fernando Projects % tree
.
└── ESP32HelloWorld
    ├── include
    │   └── README
    ├── lib
    │   └── README
    ├── platformio.ini
    ├── src
    │   └── main.cpp
    └── test
        └── README

6 directories, 5 files
(base) fernandopassold@MacBook-Pro-de-Fernando Projects %   
```

Siga as instruções do video para Complilar e enviar o programa para a plaCa:

* Botão "✔️" para Compilar;
* Botão "$\rightarrow$" para transferir o Código para a plaCa;
* Botão "🔌" para Conexão ao Monitor Serial.

---

## Outros videos:

* [Control ESP32 from ANYWHERE in the World - Step-By-Step Tutorial](https://www.youtube.com/watch?v=z53MkVFOnIo&t=3s) de [Tomasz Tarnowski](https://www.youtube.com/@tomasztarnowski4434) (1:48:56)

* [Getting Started with the ESP32 Development Board | Programming an ESP32 in C/C++](https://www.youtube.com/watch?v=dOVjb2wXI84) de [
Low Level Learning](https://www.youtube.com/@LowLevelLearning) (15:22).

* [Introduction to RTOS Part 1 - What is a Real-Time Operating System (RTOS)? | Digi-Key Electronics](https://www.youtube.com/watch?v=F321087yYy4) da [DigiKey](https://www.youtube.com/@digikey) (11:33).

---

<script language="JavaScript">
<!-- Hide JavaScript...
var LastUpdated = document.lastModified;
document.writeln ("🌊 Fernando Passold, página atualizada em " + LastUpdated); // End Hiding -->
</script>
