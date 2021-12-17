#include <cstdlib>
#include <iostream>

void usage(char const* prog) {
  std::cout << "Usage:\n" << prog << " <array size> [seed]\n";
}

extern "C" {
void process(char* array, size_t size);
void initialize(char* array, size_t size);
long random_device();
extern long rnd_state;
}

int main(int argc, char const* argv[]) {
  if (argc != 2 && argc != 3) {
    usage(argv[0]);
    exit(1);
  }
  if (argc == 3)
    rnd_state = std::atoi(argv[2]);
  else
    rnd_state = random_device();
  std::size_t size = std::atol(argv[1]);
  char array[size + 1];
  array[size] = 0;
  initialize(array, size);
  std::cout << array << "\n";

  process(array, size);

  std::cout << array << "\n";
  return 0;
}
