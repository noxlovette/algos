#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HASHSIZE 101

struct nlist {
  struct nlist *next; /* the next element in the array */
  char *name;         /* the value/given name */
  char *defn;         /* the given name/replacement text */
};

static struct nlist *hashtab[HASHSIZE]; /* pointer table */
/* a simple hash function */
unsigned hash(char *s) {
  unsigned hashval; /* ensures that the value is non-negative */

  for (hashval = 0; *s != '\0'; s++)
    hashval = *s + 31 * hashval; /* scramble data */
  return hashval % HASHSIZE;     /* modulo */
}

/* look for s in the table */
struct nlist *lookup(char *s) {
  struct nlist *np;

  for (np = hashtab[hash(s)]; np != NULL; np = np->next)
    if (strcmp(s, np->name) == 0)
      return np; /* found */
  return NULL;   /* not found */
}

/* install a value into the table */
struct nlist *install(char *name, char *defn) {
  struct nlist *np;
  unsigned hashval;

  if ((np = lookup(name)) == NULL) { /* not found */
    np = (struct nlist *)malloc(sizeof(*np));
    if (np == NULL || (np->name = strdup(name)) == NULL)
      return NULL;
    hashval = hash(name);
    np->next = hashtab[hashval];
    hashtab[hashval] = np;
  } else                    /* already there */
    free((void *)np->defn); /* free previous defn */
  if ((np->defn = strdup(defn)) == NULL)
    return NULL;
  return np;
}

int main() {
  printf("Testing the hash function\n");
  install("name", "John Doe");
  install("age", "29");
  install("city", "Moscow");

  struct nlist *result = lookup("name");
  if (result) {
    printf("Found: %s = %s\n", result->name, result->defn);
  } else {
    printf("Key not found\n");
  };

  install("age", "26");
  result = lookup("age");
  if (result) {
    printf("Updated: %s = %s\n", result->name, result->defn);
  }

  result = lookup("nonexistent");
  if (!result) {
    printf("Key 'nonexistent' correctly not found\n");
  }

  return 1;
}