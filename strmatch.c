#include <stdio.h>
#include <string.h>

#define BASE 256
#define MOD 101

int rabin_karp(char *text, char *pattern) {
  int n = strlen(text);
  int m = strlen(pattern);
  int pattern_hash = 0;
  int text_hash = 0;
  int h = 1;

  // Calculate h = pow(BASE, m-1) % MOD
  for (int i = 0; i < m - 1; i++)
    h = (h * BASE) % MOD;

  // Calculate initial hashes
  for (int i = 0; i < m; i++) {
    pattern_hash = (BASE * pattern_hash + pattern[i]) % MOD;
    text_hash = (BASE * text_hash + text[i]) % MOD;
  }

  // Slide pattern over text
  for (int i = 0; i <= n - m; i++) {
    if (pattern_hash == text_hash) {
      // Hash match - verify character by character
      int j;
      for (j = 0; j < m; j++) {
        if (text[i + j] != pattern[j])
          break;
      }
      if (j == m)
        return i; // Found at position i
    }

    // Calculate next hash: remove leading digit, add trailing digit
    if (i < n - m) {
      text_hash = (BASE * (text_hash - text[i] * h) + text[i + m]) % MOD;
      if (text_hash < 0)
        text_hash += MOD;
    }
  }
  return -1;
}
