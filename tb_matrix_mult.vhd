library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_matrix.ALL;

entity tb_matrix_mult_3 is
-- Testbench 3: Entradas = 3
end tb_matrix_mult_3;

architecture Behavioral of tb_matrix_mult_3 is
    component matrix_mult_top
        Port (
            clk, rst, start : in std_logic;
            A_in, B_in : in t_matrix_in;
            done : out std_logic;
            R_out : out t_matrix_out
        );
    end component;

    signal clk, rst, start, done : std_logic := '0';
    signal A_in, B_in : t_matrix_in := (others => (others => (others => '0')));
    signal R_out : t_matrix_out;
    constant clk_period : time := 10 ns;

begin
    uut: matrix_mult_top port map (
        clk => clk, rst => rst, start => start,
        A_in => A_in, B_in => B_in, done => done, R_out => R_out
    );

    clk_process : process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        rst <= '1'; wait for 20 ns; rst <= '0'; wait for 20 ns;

        -- TESTE 3: Entradas com valor 3
        -- Esperado: 3*3 + 3*3 + 3*3 = 27 (Hex: 1B)
        report "Iniciando Teste 3 (Valores = 3)";
        A_in <= (others => (others => to_unsigned(3, 8)));
        B_in <= (others => (others => to_unsigned(3, 8)));

        start <= '1'; wait for clk_period; start <= '0';

        wait until done = '1';
        wait for clk_period;
        
        report "Teste 3 Concluido.";
        wait;
    end process;
end Behavioral;