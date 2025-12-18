#include "matrix_mult.h"

void matrix_mult(mat_in_t A[N][N], mat_in_t B[N][N], mat_out_t R[N][N]) {
    #pragma HLS INTERFACE ap_memory port=R
    #pragma HLS INTERFACE ap_ctrl_hs port=return
    
    Row_Loop: for (int i = 0; i < N; i++) {
        Col_Loop: for (int j = 0; j < N; j++) {
            mat_out_t sum = 0;
            Prod_Loop: for (int k = 0; k < N; k++) {
                sum += A[i][k] * B[k][j];
            }
            R[i][j] = sum;
        }
    }
}