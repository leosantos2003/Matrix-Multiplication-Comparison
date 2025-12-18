#include "matrix_mult.h"
#include <iostream>

int main() {
    mat_in_t A[N][N] = {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}};
    mat_in_t B[N][N] = {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}};
    mat_out_t R[N][N];

    matrix_mult(A, B, R);

    // Verificacao simples: 1*1 + 1*1 + 1*1 = 3
    if(R[0][0] == 3) {
        std::cout << "Teste Passou!" << std::endl;
        return 0;
    } else {
        std::cout << "Teste Falhou. Esperado 3, obteve " << R[0][0] << std::endl;
        return 1;
    }
}