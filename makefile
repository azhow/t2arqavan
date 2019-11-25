BIN = ./bin
SRC = ./src
COMPILER = gcc -O2

all: bfs.o floyd.o bfs_gpu.o floyd_gpu.o

bfs.o:
	$(COMPILER) -o $(BIN)/bfs $(SRC)/bfs.cpp
floyd.o:
	$(COMPILER) -o $(BIN)/floyd $(SRC)/floyd.cpp
bfs_gpu.o:
	$(COMPILER) -o $(BIN)/bfs_gpu $(SRC)/bfs_gpu.cpp
floyd_gpu.o:
	$(COMPILER) -o $(BIN)/floyd_gpu $(SRC)/floyd_gpu.cpp
clean:
	rm $(BIN)/*