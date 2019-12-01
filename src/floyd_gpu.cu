#include <fstream>
#include <iostream>
#include <cuda_runtime.h>
// C++ Program for Floyd Warshall Algorithm  
//#include <bits/stdc++.h> 
#include <chrono>
#include <ctime>  
using namespace std; 
  
/* Define Infinite as a large enough 
value.This value will be used for  
vertices not connected to each other */
#define INF 99999  
  
// Solves the all-pairs shortest path  
// problem using Floyd Warshall algorithm  
__global__ void vecFloydWarshall(int** graph, int* dist, int nNodes, int k)
{
	/* Add all vertices one by one to
	the set of intermediate vertices.
	---> Before start of an iteration,
	we have shortest distances between all
	pairs of vertices such that the
	shortest distances consider only the
	vertices in set {0, 1, 2, .. k-1} as
	intermediate vertices.
	----> After the end of an iteration,
	vertex no. k is added to the set of
	intermediate vertices and the set becomes {0, 1, 2, .. k} */
	// Pick all vertices as source one by one  
	for (int i = blockIdx.x * blockDim.x + threadIdx.x; i < nNodes; i += blockDim.x * gridDim.x)
	{
		for (int j = blockIdx.y * blockDim.y + threadIdx.y; j < nNodes; j += blockDim.y * gridDim.y)
		{
			// Pick all vertices as destination for the  
			// above picked source  
			// If vertex k is on the shortest path from  
			// i to j, then update the value of dist[i][j]  
			//printf("j: %d\n",j);
			if (dist[i*nNodes+k] + dist[k*nNodes+j] < dist[i*nNodes+j]){
				dist[i*nNodes+j] = dist[i*nNodes+k] + dist[k*nNodes+j];
				//printf("i %d, j %d\n",i,j);
			}
		}
	}
}

/* A utility function to print solution */
void printSolution(int** dist, int nNodes)
{
	for (int i = 0; i < nNodes; i++)
	{
		for (int j = 0; j < nNodes; j++)
		{
			if (dist[i][j] == INF)
				cout << "INF" << "     ";
			else
				cout << dist[i][j] << "     ";
		}
		cout << endl;
	}
}

// This code is contributed by rathbhupendra 

int main(int argc, char **argv){
	int** graph;
	int** dist;
	int a, b, w, nNodes;
	int* device_dist;
	int* aux_dist;

	if (argc > 1) 
	{
		cout << "input file is " << argv[1] << endl;
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
  
	dist = new int*[nNodes];
	aux_dist = new int[nNodes * nNodes];
	for (int i = 0; i < nNodes; ++i)
		dist[i] = new int[nNodes];
    /* dist[][] will be the output matrix  
    that will finally have the shortest  
    distances between every pair of vertices */
    int  i, j, k;  
  
    /* Initialize the solution matrix same  
    as input graph matrix. Or we can say  
    the initial values of shortest distances 
    are based on shortest paths considering  
    no intermediate vertex. */
    for (i = 0; i < nNodes; i++)  {
        for (j = 0; j < nNodes; j++) {
			dist[i][j] = graph[i][j];  
			aux_dist[i*nNodes+j] = graph[i][j];
		}
	}
	//cout << graph[0][1] << " vs " << aux_dist[1] << "at position (" << 0 << "," << 1 << ")\n";
	
	cudaMalloc(&device_dist, nNodes * nNodes * sizeof(int));
	cudaMemcpy(device_dist, aux_dist, nNodes * nNodes * sizeof(int),cudaMemcpyHostToDevice);

	int blockSize = 256;
	int numBlocks = (nNodes + blockSize - 1) / blockSize;
	auto start = std::chrono::system_clock::now();
	for (int k = 0; k < nNodes; ++k){
		vecFloydWarshall<<<numBlocks, blockSize>>>(graph, device_dist, nNodes, k);
		cudaDeviceSynchronize();	
		//cout << "currently in " << k << endl;
	}
	auto end = std::chrono::system_clock::now();
	auto timeElapsed = (end - start);
	cudaMemcpy(aux_dist, device_dist, nNodes * nNodes * sizeof(int),cudaMemcpyDeviceToHost);

    for (i = 0; i < nNodes; i++)  {
        for (j = 0; j < nNodes; j++) {
			dist[i][j] = aux_dist[i*nNodes+j];
		}
	}
	//cout << graph[0][1] << " vs " << aux_dist[1] << "at position (" << 0 << "," << 1 << ")\n";
    // Print the shortest distance matrix  
    //printSolution(dist, nNodes);  
	auto sec = std::chrono::duration_cast<std::chrono::seconds>(timeElapsed).count();
	cout << "Computation time: " << sec << "\n";


    return 0;  
}  
  
