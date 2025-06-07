#include <stdio.h>

long long cube(int n) { return (long long)n * n * n; }
/* the recursive guy */
int integerCubeHelper(int n, int left, int right) {
  if (left > right) {
    return right;
  };
  int mid = (left + right) / 2;
  long long mid_cubed = cube(mid);

  if (mid_cubed <= n && cube(mid + 1) > n) {
    return mid;
  } else if (mid_cubed > n) {
    return integerCubeHelper(n, left, mid);
  } else {
    return integerCubeHelper(n, mid, right);
  };
}
/* the business logic */
int integerCubeRoot(int n) {
  if (n < 0)
    return -1;
  if (n == 1 || n == 2) {
    return 1;
  }

  return integerCubeHelper(n, 0, n - 1);
}

/* user interaction */
int main() {
  int n;
  printf("Enter a number: ");

  scanf("%d", &n);
  int result = integerCubeRoot(n);

  printf("Integer cube root is: %d", result);

  return 0;
}
