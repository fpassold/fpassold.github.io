# Programando em FreeRTOS em ESP32

Placas ESP32 usam o freeRTPS como seu "sistema operacional". A placaESP8266 tem um modelo sem sistema operacional e com sistema operacional.

O freeRTOS básico inclui um "sistema operacional" e ele não sobrecarrega a RAM da placa quando usado [[1]](#ref1).

Para usar o freeRTOS:

```C++
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/timers.h"
#include "freertos/event_groups.h"
```

Provavelmente você vai desejar enviar dados pela porta serial. Então se sugere o uso de outras 2 bibliotecas para acelerar comunicações seriais  [[1]](#ref1):

```c++
#include "sdkconfig.h"
#include "esp_system.h"
```

Referências:

<a name="ref1">[1]</a>[FreeRTOS example-codes for ESp32](https://forum.arduino.cc/t/freertos-example-codes-for-esp32/682084) em [Using Arduino](https://forum.arduino.cc/c/using-arduino/6) >> [Programming Questions](https://forum.arduino.cc/c/using-arduino/programming-questions/20). 

