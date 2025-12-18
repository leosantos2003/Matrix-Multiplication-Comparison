library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_matrix.ALL;

entity matrix_mult_top is
    Port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        start   : in  std_logic;
        A_in    : in  t_matrix_in;
        B_in    : in  t_matrix_in;
        done    : out std_logic;
        R_out   : out t_matrix_out
    );
end matrix_mult_top;

architecture Structural of matrix_mult_top is
    signal ld_regs, clr_acc, ld_acc, wr_res : std_logic;
    signal inc_k, inc_j, inc_i, clr_k, clr_j, clr_i : std_logic;
    signal k_done, j_done, i_done : std_logic;
begin
    inst_PC: entity work.matrix_mult_pc
    port map (
        clk => clk, rst => rst, start => start, done => done,
        k_done => k_done, j_done => j_done, i_done => i_done,
        ld_regs => ld_regs, clr_acc => clr_acc, ld_acc => ld_acc, wr_res => wr_res,
        inc_k => inc_k, inc_j => inc_j, inc_i => inc_i,
        clr_k => clr_k, clr_j => clr_j, clr_i => clr_i
    );

    inst_PO: entity work.matrix_mult_po
    port map (
        clk => clk, rst => rst,
        ld_regs => ld_regs, clr_acc => clr_acc, ld_acc => ld_acc, wr_res => wr_res,
        inc_k => inc_k, inc_j => inc_j, inc_i => inc_i,
        clr_k => clr_k, clr_j => clr_j, clr_i => clr_i,
        k_done => k_done, j_done => j_done, i_done => i_done,
        A_in => A_in, B_in => B_in, R_out => R_out
    );
end Structural;