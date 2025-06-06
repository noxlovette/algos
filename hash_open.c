#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HASHSIZE 101

struct nlist {
  char *name; /* the value/given name */
  char *defn; /* the given name/replacement text */
  int in_use; /* 0 – empty, 1 – occupied */
};

static struct nlist hashtab[HASHSIZE]; /* table */
/* a simple hash function */
unsigned hash(char *s) {
  unsigned hashval; /* ensures that the value is non-negative */

  for (hashval = 0; *s != '\0'; s++)
    hashval = *s + 31 * hashval; /* scramble data */
  return hashval % HASHSIZE;     /* modulo */
}

/* look for s in the table */
struct nlist *lookup(char *s) {
  unsigned i = hash(s);

  for (int step = 0; step < HASHSIZE; step++) {
    unsigned idx = (i + step) % HASHSIZE;
    if (hashtab[idx].in_use) {
      if (strcmp(hashtab[idx].name, s) == 0) {
        return &hashtab[idx];
      }
    } else {
      return NULL; /* empty slot means not found */
    }
  }

  return NULL; /* table full or not found */
}

/* install a value into the table */
struct nlist *install(char *name, char *defn) {
  struct nlist *np = lookup(name);
  if (np) {
    free(np->defn);
    np->defn = strdup(defn);
    return np;
  }

  unsigned i = hash(name);

  for (int step = 0; step < HASHSIZE; step++) {
    unsigned idx = (i + step) % HASHSIZE;
    if (!hashtab[idx].in_use) {
      hashtab[idx].name = strdup(name);
      hashtab[idx].defn = strdup(defn);
      hashtab[idx].in_use = 1;
      return &hashtab[idx];
    }
  }

  return NULL; /* table is full */
}

int main() {
  install("name", "John");
  install("age", "30");
  install("city", "Moscow");

  struct nlist *result = lookup("name");
  if (result)
    printf("Found: %s = %s\n", result->name, result->defn);

  install("age", "31"); // update
  result = lookup("age");
  if (result)
    printf("Updated: %s = %s\n", result->name, result->defn);

  return 0;
}
