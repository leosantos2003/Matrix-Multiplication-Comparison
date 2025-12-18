# Matrix Multiplication Comparison (HLS & PC-PO)

**INF01175 - Sistemas Digitais para Computadores - UFRGS - 2025/2**

## About

This project consists of the implementation and comparison of hardware architectures for the multiplication of two square matrices of dimension $3 \times 3$.

The main objective is to explore the trade-off between **Performance (Clock Cycles)** and **Area (Hardware Resources)** using two distinct design methodologies:
1. **HLS (High-Level Synthesis):** High-level synthesis using C++ with Vitis HLS, exploring different optimization directives.
2. **PC-PO (Control Part - Operational Part):** Manual design in VHDL describing the data flow and the finite state machine (RTL).

## File structure

### HLS implementation (C++)
The files below are intended for synthesis in Vitis HLS:
* `matrix_mult.h`: Definitions of types (8-bit inputs, 32-bit output) and dimension ($N=3$).

* `matrix_mult.cpp`: Basic implementation (nested triple loop).

* `matrix_mult_pipeline.cpp`: Optimized implementation with the `#pragma HLS PIPELINE` directive.

* `matrix_mult_unroll.cpp`: Optimized implementation with the `#pragma HLS UNROLL` directive (full parallelism).

* `matrix_mult_tb.cpp`: C++ testbench for functional validation before synthesis.

### VHDL implementation (PC-PO)
The following files comprise the manual RTL design:
* `matrix_mult_top.vhd`: Top entity that connects the PC and the PO.
* `matrix_mult_pc.vhd`: **Control Part**. State Machine (FSM) that generates the control signals (load, clear, increments).
* `matrix_mult_po.vhd`: **Operational Part**. Contains the registers, multiplier, adder/accumulator, and counters.
* `pkg_matrix.vhd` (implicit): Definition of matrix data types for VHDL.
* `tb_matrix_mult.vhd`: VHDL testbench for behavioral simulation.

## Implementation details

### 1. High-Level Synthesis (HLS)
Three versions were developed to analyze the impact of the directives:
* **Basic:** No loop optimizations. Sequential execution.

* **Pipeline:** Use of `II=1` in internal loops to allow the start of a new operation in each cycle.

* **Unroll:** Complete unrolling of loops, generating dedicated hardware to calculate all cells simultaneously (high area cost, very high speed).

### 2. Manual design (PC-PO)
The architecture follows the classic model:
* **Control (PC):** FSM with `IDLE`, `SETUP`, `CALC`, `WRITE_RES` states, and `i, j, k` counter checks.

* **Operative (PO):** Uses a single multiplier and accumulator. Performs the row x column operation sequentially, storing the partial result until the sum of the products is complete.

1. **PC-PO flowchart:**

<img width="1588" height="650" alt="Imagem colada" src="https://github.com/user-attachments/assets/8882d2d2-54d6-42bc-bc90-03ffffe6b97e" />

2. **PC-PO schematic:**

<img width="1457" height="861" alt="Imagem colada" src="https://github.com/user-attachments/assets/56b53e0b-b942-45e3-8b15-51b25ff55725" />

3. **PC finite state machine:**

<img width="1279" height="656" alt="Imagem colada" src="https://github.com/user-attachments/assets/bedada6f-cfce-42dd-92d4-34989f81e878" />

## Results comparison

The data below were obtained after simulation and synthesis (FPGA):

| Implementation | Clock Cycles (Latency) | LUTs | Flip-Flops (FF) | DSPs | Observation |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **HLS (Basic)** | 160 | 186 | 48 | 1 | Slowest solution, low parallelism. |
| **HLS (Pipeline)** | **23** | 320 | 50 | 2 | Best balance between area and performance. |
| **HLS (Unroll)** | **9** | 575 | 172 | 18 | Fastest, but with very high area cost. |
| **VHDL (PC-PO)** | ~34 | 175 | 361 | 0 | High use of FFs (manual registers), without the use of DSPs. |

### Main conclusions
* The **HLS Unroll** version is ideal for maximum performance, but consumes many resources (18 DSPs).
* The **HLS Pipeline** version offers an excellent speed gain (23 cycles) with a moderate increase in area.
* The manual **PC-PO** version had reasonable performance (34 cycles), but consumed more registers (FF) due to the explicit implementation of register banks.

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

## Contact

Leonardo Santos - <leorsantos2003@gmail.com>
