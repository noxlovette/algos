#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 11
#define MAX_KICKS 5

typedef struct {
  char *key;
  char *value;
  int in_use;
} Entry;

Entry table1[TABLE_SIZE];
Entry table2[TABLE_SIZE];

unsigned hash1(char *s) {
  unsigned hash = 0;
  while (*s) {
    hash = (hash * 31 + *s++) % TABLE_SIZE;
  }
  return hash;
}
unsigned hash2(char *s) {
  unsigned hash = 0;
  while (*s) {
    hash = (hash * 17 + *s++) % TABLE_SIZE;
  }
  return hash;
}
void insert(char *key, char *value) {
  char *cur_key = key;
  char *cur_value = value;
  for (int i = 0; i < MAX_KICKS; i++) {
    unsigned idx1 = hash1(cur_key);

    if (!table1[idx1].in_use) {
      table1[idx1].key = strdup(cur_key);
      table1[idx1].value = strdup(cur_value);
      table1[idx1].in_use = 1;
      return;
    }

    char *evicted_key = table1[idx1].key;
    char *evicted_value = table1[idx1].value;

    table1[idx1].key = strdup(cur_key);
    table1[idx1].value = strdup(cur_value);
    cur_key = evicted_key;
    cur_value = evicted_value;

    unsigned idx2 = hash2(cur_key);
    if (!table2[idx2].in_use) {
      table2[idx2].key = strdup(cur_key);
      table2[idx2].value = strdup(cur_value);
      table2[idx2].in_use = 1;
      return;
    }

    evicted_key = table2[idx2].key;
    evicted_value = table2[idx2].value;

    table2[idx2].key = cur_key;
    table2[idx2].value = cur_value;
    cur_key = evicted_key;
    cur_value = evicted_value;
  }

  printf("Insert failed: too many evictions\n");
}

char *lookup(char *key) {
  unsigned idx1 = hash1(key);

  if (table1[idx1].in_use && strcmp(table1[idx1].key, key) == 0)
    return table1[idx1].value;

  unsigned idx2 = hash2(key);
  if (table2[idx2].in_use && strcmp(table2[idx2].key, key) == 0)
    return table2[idx2].value;

  return NULL;
}

int main() {
  insert("name", "Alice");
  insert("age", "30");
  insert("city", "Paris");
  insert("country", "France");
  insert("email", "alice@example.com");

  printf("name: %s\n", lookup("name"));
  printf("age: %s\n", lookup("age"));
  printf("city: %s\n", lookup("city"));
  printf("country: %s\n", lookup("country"));
  printf("email: %s\n", lookup("email"));
  printf("notfound: %s\n", lookup("notfound"));

  return 0;
}