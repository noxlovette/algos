#include <stdio.h>

int findIndexHelper(int a[], int b[], int left, int right) {
    int mid = (left+right) / 2;

    if (a[mid] > b[mid] && a[mid+1] < b[mid+1]) {
        return mid;
    }

    if (a[mid] > b[mid]) { // which means that the crossover is on the right
        return findIndexHelper(a, b, mid, right);
    } else { // which means that the crossover is on the left
        return findIndexHelper(a, b, left, mid);
    }
}
#define SIZE 10
int main() {

    int a[SIZE] = {10, 12, 13, 14, 15, 19, 23, 25, 28, 33};
    int b[SIZE] = {6, 9, 14, 17, 18, 21, 25, 29, 32, 34};

    int result = findIndexHelper(a, b, 0, SIZE-1);

    printf("%d ", result);

    return 0;
}