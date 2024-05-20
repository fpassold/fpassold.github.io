// variáveis globais
float x1 = 0;	// x[n-1]
float y1 = 0;	// y[n-1]
int k = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  // sinal original + ruído
  float t = micros()/1.0e6;	// clock do Arduino é de 16 MHz
  float x = sin(2*PI*2*t) + 0.2*sin(2*PI*50*t);
    
  // cálculo do sinal filtrado
  float y = 0.9691*y1 + 0.01547*x + 0.01547*x1;
    
  delay(1); 	// pausa de 1 mili-segundo
  // atualiza valor das variáveis associadas com amostras atrasadas
  x1 = x;
  y1 = y;
    
  if (k % 3 == 0){
    // Saída via porta serial
    Serial.print(2*x);
    Serial.print(" ");
    Serial.println(2*y);
  }
  k++;
}
