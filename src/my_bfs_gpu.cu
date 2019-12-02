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

__global__ void vecBfs(int nNodes, int** graph, bool *visited, bool *notdone)
{
	for(int v = blockIdx.x * blockDim.x + threadIdx.x; v < nNodes; v+= blockDim.x * gridDim.x){
            //printf("visited %d\n",v);
            if(v == GOAL)
            {
                //cout << "Found " << GOAL << endl;
                *notdone = true;
            }
            for(int i = blockIdx.y * blockDim.y + threadIdx.y; i < nNodes; i += blockDim.y * gridDim.y){
                if(graph[v][i] != INF && v != i){
                    if(visited[i] == false)
                    {
                        visited[i] = true;
                        *notdone = false;
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
	int blockSize = 32;
	int numBlocks = (nNodes + blockSize - 1) / blockSize;
    bool* device_visited;
    bool* device_notdone;
    bool notdone;
    notdone = true;
    cudaMalloc(&device_visited, nNodes * sizeof(bool));
    cudaMemcpy(device_visited, visited, nNodes * sizeof(bool),cudaMemcpyHostToDevice);
    cudaMalloc(&device_notdone, sizeof(bool));
    cudaMemcpy(device_notdone, &notdone, nNodes * sizeof(bool),cudaMemcpyHostToDevice);
    /* BFS */
    auto start = std::chrono::system_clock::now();
	while(notdone){
        notdone = false;
        /* For all V in Graph - total of nNodes V's*/
        vecBfs<<<numBlocks,blockSize>>>(nNodes, graph, device_visited, device_notdone);
        cudaDeviceSynchronize();
        cudaMemcpy(&notdone, device_notdone, sizeof(bool),cudaMemcpyDeviceToHost);
    }
    /* BFS DONE */

	auto end = std::chrono::system_clock::now();
	auto timeElapsed = (end - start);
	auto sec = std::chrono::duration_cast<std::chrono::milliseconds>(timeElapsed).count();
	cout << sec << "\n";
	for(int i = 0; i < nNodes; i++)
		free(graph[i]);
	free(visited);
}

