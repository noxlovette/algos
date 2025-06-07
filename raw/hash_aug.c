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

int undef(char *s) {
  struct nlist *np, *prev = NULL;
  unsigned hashval = hash(s);

  for (np = hashtab[hashval]; np != NULL; prev = np, np = np->next) {
    if (strcmp(s, np->name) == 0) {
      if (prev == NULL) {
        hashtab[hashval] = np->next;
      } else {
        prev->next = np->next;
      }

      free(np->name);
      free(np->defn);
      free(np);

      return 1;
    }
  }
  return 0;
}

void print_distribution() {
  printf("\nHash Table Distribution:\n");
  for (int i = 0; i < HASHSIZE; i++) {
    int count = 0;
    struct nlist *np = hashtab[i];
    while (np != NULL) {
      count++;
      np = np->next;
    }
    if (count > 0) {
      printf("Bucket %d: %d entries\n", i, count);
    }
  }
}
void bulk_insert(int num) {
  char key[32], value[32];
  for (int i = 0; i < num; i++) {
    sprintf(key, "key%d", i);
    sprintf(value, "value%d", i);
    install(key, value);
  }
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

  int remove_result;
  remove_result = undef("age");
  if (remove_result) {
    printf("deleted key\n");
  }
  result = lookup("age");
  if (!result) {
    printf("Deleted key not found, correct\n");
  }

  bulk_insert(200); // Or try 1000+ for more collisions
  print_distribution();

  return 1;
}