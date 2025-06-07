#include "log_parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

uint64_t hash(const char *s) {
  uint64_t hash = 5381;
  int c;
  while ((c = *s++)) {
    hash = ((hash << 5) + hash) + c;
  }
  return hash;
}

LogEntry *parse_log_line(const char *line) {
  LogEntry *entry = malloc(sizeof(LogEntry));
  if (!entry)
    return NULL;

  strncpy(entry->message, line, MAX_MESSAGE_LEN - 1);
  entry->message[MAX_MESSAGE_LEN - 1] = '\0';

  char *newline = strchr(entry->message, '\n');
  if (newline)
    *newline = '\0';

  entry->hash = hash_string(entry->message);
  entry->level = LOG_INFO;
  entry->timestamp = time(NULL);

  return entry;
}

void free_log_entry(LogEntry *entry) { free(entry); }