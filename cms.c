#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define W 1000 // width
#define D 5    // depth

int count[D][W]; // sketch table

// Simple hash functions with different seeds
unsigned int hash(int seed, const char *str) {
  unsigned int hash = seed;
  while (*str) {
    hash = hash * 101 + *str++;
  }
  return hash % W;
}

void cms_add(const char *item) {
  for (int i = 0; i < D; i++) {
    int idx = hash(i + 1, item);
    count[i][idx]++;
  }
}

int cms_query(const char *item) {
  int min = __INT_MAX__;
  for (int i = 0; i < D; i++) {
    int idx = hash(i + 1, item);
    if (count[i][idx] < min)
      min = count[i][idx];
  }
  return min;
}

int main() {
  memset(count, 0, sizeof(count));

  cms_add("apple");
  cms_add("apple");
  cms_add("banana");

  printf("apple: %d\n", cms_query("apple"));   // ≈ 2
  printf("banana: %d\n", cms_query("banana")); // ≈ 1
  printf("orange: %d\n", cms_query("orange")); // ≈ 0

  return 0;
}
