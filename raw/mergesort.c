#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_LENGTH 100

void generateRandomArray(int arr[], int length, int minVal, int maxVal) {
  for (int i = 0; i < length; i++) {
    arr[i] = rand() % (maxVal - minVal + 1) + minVal;
  }
}

void merge(int arr[], int left, int mid, int right) {
  int size1 = mid - left + 1;
  int size2 = right - mid;

  int *L = (int *)malloc(size1 * sizeof(int));
  int *R = (int *)malloc(size2 * sizeof(int));

  if (!L || !R) {
    fprintf(stderr, "Memory allocation failed!\n");
    exit(EXIT_FAILURE);
  }

  for (int i = 0; i < size1; i++)
    L[i] = arr[left + i];
  for (int j = 0; j < size2; j++)
    R[j] = arr[mid + 1 + j];

  int i = 0, j = 0, k = left;

  while (i < size1 && j < size2)
    arr[k++] = (L[i] <= R[j]) ? L[i++] : R[j++];

  while (i < size1)
    arr[k++] = L[i++];
  while (j < size2)
    arr[k++] = R[j++];

  free(L);
  free(R);
}

void mergeSort(int arr[], int left, int right) {
  if (left < right) {
    int mid = (left + right) / 2;
    mergeSort(arr, left, mid);
    mergeSort(arr, mid + 1, right);
    merge(arr, left, mid, right);
  }
}

void printArray(const char *label, int arr[], int size) {
  printf("%s[", label);
  for (int i = 0; i < size; i++) {
    printf("%d", arr[i]);
    if (i < size - 1)
      printf(", ");
  }
  printf("]\n");
}

int main() {
  srand(time(NULL));

  int arr[MAX_LENGTH];
  int length = rand() % (MAX_LENGTH - 5) + 5;

  generateRandomArray(arr, length, -50, 100);

  printArray("Unsorted: ", arr, length);

  clock_t start = clock();

  mergeSort(arr, 0, length - 1);

  clock_t stop = clock();

  printArray("Sorted:   ", arr, length);

  double elapsed = (double)(stop - start) / CLOCKS_PER_SEC;
  printf("⏱️ Time taken: %.6f seconds\n", elapsed);

  return 0;
}
