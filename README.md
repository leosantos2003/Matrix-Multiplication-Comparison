# Projeto: Multiplicação de Matrizes 3x3 (HLS & PC-PO)

**Disciplina:** Sistemas Digitais - 2025/2  
**Professora:** Fernanda Kastensmidt  
**Autores:**
- Gabriel Patrocínio
- Leonardo Santos

## 📋 Descrição do Projeto

Este projeto consiste na implementação e comparação de arquiteturas de hardware para a multiplicação de duas matrizes quadradas de dimensão $3 \times 3$.

O objetivo principal é explorar o compromisso entre **Desempenho (Ciclos de Clock)** e **Área (Recursos de Hardware)** utilizando duas metodologias de design distintas:
1.  **HLS (High-Level Synthesis):** Síntese de alto nível utilizando C++ com Vitis HLS, explorando diferentes diretivas de otimização.
2.  **PC-PO (Parte de Controle - Parte Operativa):** Design manual em VHDL descrevendo o fluxo de dados e a máquina de estados finitos (RTL).

## 📂 Estrutura dos Arquivos

### Implementação em HLS (C++)
Os arquivos abaixo destinam-se à síntese no Vitis HLS:
* `matrix_mult.h`: Definições de tipos (entradas de 8 bits, saída de 32 bits) e dimensão ($N=3$).
* `matrix_mult.cpp`: Implementação básica (Loop triplo aninhado).
* `matrix_mult_pipeline.cpp`: Implementação otimizada com diretiva `#pragma HLS PIPELINE`.
* `matrix_mult_unroll.cpp`: Implementação otimizada com diretiva `#pragma HLS UNROLL` (paralelismo total).
* `matrix_mult_tb.cpp`: Testbench em C++ para validação funcional antes da síntese.

### Implementação em VHDL (PC-PO)
Os arquivos abaixo compõem o design RTL manual:
* `matrix_mult_top.vhd`: Entidade de topo que conecta a PC e a PO.
* `matrix_mult_pc.vhd`: **Parte de Controle**. Máquina de Estados (FSM) que gera os sinais de controle (load, clear, incrementos).
* `matrix_mult_po.vhd`: **Parte Operativa**. Contém os registradores, multiplicador, somador/acumulador e contadores.
* `pkg_matrix.vhd` (implícito): Definição dos tipos de dados de matriz para o VHDL.
* `tb_matrix_mult.vhd`: Testbench em VHDL para simulação comportamental.

## 🛠️ Detalhes das Implementações

### 1. High-Level Synthesis (HLS)
Foram desenvolvidas três versões para analisar o impacto das diretivas:
* **Básica:** Sem otimizações de loop. Execução sequencial.
* **Pipeline:** Uso de `II=1` nos loops internos para permitir o início de uma nova operação a cada ciclo.
* **Unroll:** Desenrolamento completo dos loops, gerando hardware dedicado para calcular todas as células simultaneamente (custo alto de área, altíssima velocidade).

### 2. Design Manual (PC-PO)
A arquitetura segue o modelo clássico:
* **Controle (PC):** FSM com estados `IDLE`, `SETUP`, `CALC`, `WRITE_RES`, e verificações de contadores `i, j, k`.
* **Operativa (PO):** Utiliza um único multiplicador e acumulador. Realiza a operação linha x coluna sequencialmente, armazenando o resultado parcial até completar a soma dos produtos.

## 📊 Comparativo de Resultados

Os dados abaixo foram obtidos após simulação e síntese (FPGA):

| Implementação | Ciclos de Clock (Latência) | LUTs | Flip-Flops (FF) | DSPs | Observação |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **HLS (Básico)** | ~160 | 186 | 48 | 1 | Solução mais lenta, baixo paralelismo. |
| **HLS (Pipeline)** | **23** | 320 | 50 | 2 | Melhor balanço entre área e desempenho. |
| **HLS (Unroll)** | **9** | 575 | 172 | 18 | Mais rápida, porém com altíssimo custo de área. |
| **VHDL (PC-PO)** | ~34 | 175 | 361 | 0 | Alto uso de FFs (registradores manuais), sem uso de DSPs. |

### Conclusões Principais
* A versão **HLS Unroll** é ideal para desempenho máximo, mas consome muitos recursos (18 DSPs).
* A versão **HLS Pipeline** oferece um excelente ganho de velocidade (23 ciclos) com um aumento moderado de área.
* A versão **PC-PO** manual teve desempenho razoável (34 ciclos), mas consumiu mais registradores (FF) devido à implementação explícita dos bancos de registradores.

## 🚀 Como Executar

### Pré-requisitos
* AMD Xilinx Vivado (para VHDL)
* AMD Vitis HLS (para C++)

### Passos
1.  **Simulação C++:** Compile `matrix_mult_tb.cpp` com a versão desejada do `.cpp` para verificar a lógica.
2.  **Síntese HLS:** Crie um projeto no Vitis HLS, adicione os arquivos C++ e execute a síntese para obter os relatórios de área e latência.
3.  **Simulação VHDL:** Crie um projeto no Vivado, adicione os arquivos `.vhd`, defina `tb_matrix_mult` como *top module* de simulação e execute a simulação comportamental.
