// numeros.c
// Fernando Passold, em 25/08/2023
// Gera numeros aleatórios (-1, +1)
// Linguagem GNU C
// compilar com: % gcc numeros.c -o numeros

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

int main(){
  int i,n;
  double random_value, maior, menor, sum, variance, mean, std;

  srand( time(NULL) ); // inicializa semente de numeros aleatórios
  printf("\n\nEntre com quantidade de numeros aleatorios: ? ");
  scanf("%i", &n);

  // Aloca memória dinamicamente para o vetor de números aleatórios
  double *number = (double *)malloc(n * sizeof(double));
  if (number == NULL) {
    printf("Ops... Problemas de alocação de memória.\n\n");
    return 1;
  }

  // Criar e escrever os números aleatórios em um arquivo de texto
  FILE *file = fopen("numeros.txt", "w");
  if (file == NULL) {
    printf("Erro ao criar o arquivo.\n");
    return 1;
  }  

  printf("\n");
  sum = 0;
  for(i=0; i<n; i++){
    // rand() gera numeros aleatorios entre 0 e RAND_MAX (macro predefinida em stdlib.h)
    random_value = -1.0 + 2.0*(rand()/(double)RAND_MAX); // gera numero float aleatorio entre -1 à +1
    
    //printf("%2i) %7.4f ", i+1, random_value);
    // Exibir os números formatados na tela, 10 numeros por linha de texto
    printf("%7.4f ", random_value);
    if ((i + 1) % 10 == 0) {
      printf("\n");
    }

    sum = sum + random_value;
    number[i] = random_value; // guarda numero no vetor
    if (i == 0){
      menor = random_value;
      maior = random_value;
    }
    if (random_value < menor){
      menor = random_value;
    }
    if (random_value > maior){
      maior = random_value;
    }

    // gravando os dados em arquivo texto
    fprintf(file, "%f\n", random_value);
  }

  fclose(file);

  mean = sum/n;
  variance = 0;
  for(i=0; i<n; i++){
    variance = variance + pow(number[i] - mean, 2);
  }
  variance = variance / n;
  std = sqrt(variance);
  printf("\nMenor Valor gerado: %7.4f\n", menor);
  printf(  "Maior Valor gerado: %7.4f\n", maior);
  printf(  "Valor Médio gerado: %7.4f\n", mean);
  printf(  "Desvio padrão: %7.4f\n", std);
  printf("\nGerado arquivo <<numeros.txt>>\n\n");

  // liberando memoria alocada para o vetor
  free(number);
  return 0; // finalizado sem problemas
}