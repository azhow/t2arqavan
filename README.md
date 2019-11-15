# Trabalho 2 de arquiteturas avançadas

INF01191 - Arquiteturas Avançadas de Computadores
Prof. Antonio Carlos Schneider Beck Filho
 
Especificação do Segundo Trabalho Prático
1) Tarefas

Implemente dois algoritmos de grafos: Floyd-Warshall e BFS para que utilizem uma GPU para realizar a computação.

Realize testes com as diferentes entradas fornecidas e compare o desempenho da versão disponibilizada com sua implementação em GPU.

Faça uma análise crítica dos resultados obtidos em relação ao desempenho obtido na GPU vs obtido na CPU. Era o que vocês esperavam? Houve diferença entre os dois algoritmos? Por quê? E entre os grafos?

Detalhe as características do processador e da GPU utilizados para os testes. 


2) Experimentação

Execute pelo menos 30 repetições de cada experimento e apresente a média. Compile o código utilizando a flag -O2.

3) Entrega

Terá de ser feita uma apresentação em Powerpoint com no máximo 13 slides (incluindo título), que será apresentada ao restante da turma e ao professor. Se for o caso, a ordem de apresentação se dará por sorteio, feito no mesmo dia da apresentação; ou definida pelo professor previamente. Os códigos também deverão ser submetidos no moodle.

4) Data de Apresentação

Encontra-se no plano de ensino.

5) Entradas

São fornecidos dois códigos seriais base dos algoritmos BFS e Floyd-Warshall. No BFS, procura-se sempre o vértice 5000.

São fornecidos grafos de diferentes topologias para realização dos testes. São eles:

binomial: árvore binomial de grau 12
complete: grafo completo de 5 mil vértices
random250: grafo aleatório de 5 mil vértices e 250 mil arestas
random1250: grafo aleatório de 5 mil vértices e 1250000 arestas
