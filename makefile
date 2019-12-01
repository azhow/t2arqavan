BIN = ./bin
SRC = ./src
COMPILER = nvcc
DBFLAGS=-g -O0
RELEASEFLAG=-O2
FLAGS=

debug: FLAGS += $(DBFLAGS)
debug: 
	@echo "DEBUG build"
debug: executable

release: FLAGS += $(RELEASEFLAG)
release: executable

executable: bfs.o floyd.o bfs_gpu.o floyd_gpu.o

bfs.o:
	@mkdir -p $(BIN)
	@$(COMPILER) $(FLAGS) -o $(BIN)/bfs $(SRC)/bfs.cpp
floyd.o:
	@mkdir -p $(BIN)
	@$(COMPILER) $(FLAGS) -o $(BIN)/floyd $(SRC)/floyd.cpp
bfs_gpu.o:
	@mkdir -p $(BIN)
	@$(COMPILER) $(FLAGS) -o $(BIN)/bfs_gpu $(SRC)/bfs_gpu.cpp
floyd_gpu.o:
	@mkdir -p $(BIN)
	@$(COMPILER) $(FLAGS) -o $(BIN)/floyd_gpu $(SRC)/floyd_gpu.cpp
clean:
	@rm -rf $(BIN)/*
