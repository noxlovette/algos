#include "log_parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void print_usage(const char *program_name) {
  printf("Usage: %s <log_file> [options]\n", program_name);
  printf("Options:\n");
  printf("    --top-errors N  Show top N most frequent errors\n");
  printf("    --duplicates    Find duplicate log entries\n");
  printf("    --pattern TEXT  Find entries containing TEXT\n");
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    print_usage(argv[0]);
    return 1;
  }

  const char *filename = argv[1];
  FILE *file = fopen(filename, "r");
  if (!file) {
    fprintf(stderr, "Error: Cannot open file %s\n", filename);
    return 1;
  }

  printf("Analysing log file: %s\n", filename);

  char line[1024];
  size_t line_count = 0;

  while (fgets(line, sizeof(line), file)) {
    line_count++;
    if (line_count <= 5) {
      printf("Line %zu: %s", line_count, line);
    }
  }

  printf("\nTotal lines: %zu\n", line_count);
  fclose(file);
  return 0;
}