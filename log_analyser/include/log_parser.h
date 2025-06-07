#ifndef LOG_PARSER_H
#define LOG_PARSER_H

#include <stdint.h>
#include <time.h>

#define MAX_LOG_LINE 1024
#define MAX_MESSAGE_LEN 512

typedef enum { LOG_DEBUG, LOG_INFO, LOG_WARN, LOG_ERROR, LOG_FATAL } LogLevel;

typedef struct {
  time_t timestamp;
  LogLevel level;
  char message[MAX_MESSAGE_LEN];
  uint64_t hash;
} LogEntry;

LogEntry *parse_log_line(const char *line);
void free_log_entry(LogEntry *entry);
uint64_t hash_string(const char *str);

#endif