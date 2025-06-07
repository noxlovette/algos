#include <stdio.h>

#define SIZE 10

/* swap two values in the array */
void swap(int *px, int *py) {
  int temp;

  temp = *px;

  *px = *py;
  *py = temp;
}

/* insert a new value into the sorted array */
void insert(int a[], int j) {
  int i;

  for (i = j - 1; i >= 0; i--) {

    if (a[i] > a[i + 1]) {
      swap(&a[i], &a[i + 1]);
    } else {
      break;
    }
  }
}
/* inserted sort */
int main() {
  int i;

  int a[SIZE] = {1, 56, 23, 421, 2, 44, 78, 5, 42, 11};

  for (i = 1; i < SIZE; i++) {
    insert(a, i);
  }

  printf("Sorted Array:\n");
  for (i = 0; i < SIZE; i++) {
    printf("%d ", a[i]);
  }
  printf("\n");

  return 0;
}
