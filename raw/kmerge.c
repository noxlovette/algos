#include <stdio.h>
#include <stdlib.h>

#define LENGTH 10

void generateRandomArray(int arr[], int length, int minVal, int maxVal) {
  for (int i = 0; i < length; i++) {
    arr[i] = rand() % (maxVal - minVal + 1) + minVal;
  }
}

void mergeSort(int arr[]) {
    
    mergeSortHelper(arr, 0, LENGTH);
}

void mergeSortHelper(arr, left, right) {

    int mid = (left+right)/2;


    if (arr[]) {
       // todo 
    }
}

int main() { 
    
    int k;

    printf("Tell me how many arrays to sort: ");

    scanf("%d", &k);
    if (k < 1 || k > 10) {
        printf("Invalid input");
        return 0;
    }
    int all[k];

    int i;

    for (i = 0; i<k;i++) {
        int arr[LENGTH];
        generateRandomArray(arr, LENGTH, -50, 100);
        mergeSort(arr);
        all[i] = arr;
    };

        
    return 0; }
