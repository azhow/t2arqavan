#include <iostream>
#include <fstream>
#include <stack>
#include <queue>
#include <chrono>
#include <ctime>  
#include <stdlib.h>

using namespace std;

#define INF 99999
#define GOAL 5000

__global__ void vecBfs(int nNodes, int** graph, bool *visited, bool *done)
{
	for(int v = blockIdx.x; v < nNodes; ++v){
            //cout << "visited " << v << endl;
            if(v == GOAL)
            {
                //cout << "Found " << GOAL << endl;
                *done = true;
            }
            for(int i = blockIdx.y; i < nNodes; ++i){
                if(graph[v][i] != INF && v != i){
                    if(visited[i] == false)
                    {
                        visited[i] = true;
                        *done = false;
                    }
                }
            }
	}
}

int main(int argc, char **argv){
	int** graph;
    int a, b, w, nNodes;

    if (argc > 1)
    {
        ifstream inputfile(argv[1]);
        inputfile >> nNodes;
        graph = new int*[nNodes];
        for (int i = 0; i < nNodes; ++i)
        {
            graph[i] = new int[nNodes]; 
            for (int j = 0; j < nNodes; ++j)
                graph[i][j] = INF;
        }
        while (inputfile >> a >> b >> w)
        {
            graph[a][b] = w;
            graph[b][a] = w;
        }
    }
	
	bool *visited = new bool[nNodes];
	/* BFS */
	for(int i = 0; i < nNodes; i++)
		visited[i] = false;

   	queue<int> q;
	q.push(0);
	visited[0] = true;
	
	/* GPU Setup */
	int indx = 0, blockSize = 32;
	int numBlocks = (nNodes + blockSize - 1) / blockSize;
    bool* device_visited;
    bool* device_done;
    bool* done;
	*done = true;
    cudaMalloc(&device_visited, nNodes * sizeof(bool));
    cudaMemcpy(device_visited, visited, nNodes * sizeof(bool),cudaMemcpyHostToDevice);
    cudaMalloc(&device_done, sizeof(bool));
    cudaMemcpy(device_done, done, nNodes * sizeof(bool),cudaMemcpyHostToDevice);

    /* BFS */
    auto start = std::chrono::system_clock::now();
	while(!(*done)){
        *done = false;
        /* For all V in Graph - total of nNodes V's*/
        vecBfs<<<numBlocks,blockSize>>>(nNodes, graph, device_visited, device_done);
        cudaDeviceSynchronize();
        *done = *device_done;
    }
    /* BFS DONE */

	auto end = std::chrono::system_clock::now();
	auto timeElapsed = (end - start);
	auto sec = std::chrono::duration_cast<std::chrono::seconds>(timeElapsed).count();
	for(int i = 0; i < nNodes; i++)
		free(graph[i]);
	free(visited);
}

