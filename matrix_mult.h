#ifndef MATRIX_MULT_H
#define MATRIX_MULT_H

#include <stdint.h>

#define N 3
typedef uint8_t mat_in_t;
typedef int32_t mat_out_t;

void matrix_mult(mat_in_t A[N][N], mat_in_t B[N][N], mat_out_t R[N][N]);

#endif