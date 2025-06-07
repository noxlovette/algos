#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BLOOM_SIZE 1024 // Size of the bit array (in bits)
#define BLOOM_HASHES 2  // Number of hash functions

// Bit array
uint8_t bit_array[BLOOM_SIZE / 8] = {0};

// djb2 hash function
unsigned long hash1(const char *str) {
  unsigned long hash = 5381;
  int c;
  while ((c = *str++))
    hash = ((hash << 5) + hash) + c; // hash * 33 + c
  return hash;
}

// sdbm hash function
unsigned long hash2(const char *str) {
  unsigned long hash = 0;
  int c;
  while ((c = *str++))
    hash = c + (hash << 6) + (hash << 16) - hash;
  return hash;
}

// Set bit in bit array
void set_bit(int pos) { bit_array[pos / 8] |= (1 << (pos % 8)); }

// Check bit in bit array
int get_bit(int pos) { return (bit_array[pos / 8] >> (pos % 8)) & 1; }

// Add string to Bloom filter
void bloom_add(const char *str) {
  unsigned long h1 = hash1(str);
  unsigned long h2 = hash2(str);
  for (int i = 0; i < BLOOM_HASHES; i++) {
    int combined_hash = (h1 + i * h2) % BLOOM_SIZE;
    set_bit(combined_hash);
  }
}

// Check if string might be in Bloom filter
int bloom_check(const char *str) {
  unsigned long h1 = hash1(str);
  unsigned long h2 = hash2(str);
  for (int i = 0; i < BLOOM_HASHES; i++) {
    int combined_hash = (h1 + i * h2) % BLOOM_SIZE;
    if (!get_bit(combined_hash))
      return 0; // Definitely not in set
  }
  return 1; // Possibly in set
}

// Test main
int main() {
  bloom_add("apple");
  bloom_add("banana");

  printf("Check 'apple': %s\n", bloom_check("apple") ? "maybe" : "no");
  printf("Check 'banana': %s\n", bloom_check("banana") ? "maybe" : "no");
  printf("Check 'grape': %s\n", bloom_check("grape") ? "maybe" : "no");

  return 0;
}
