library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_matrix.ALL;

entity matrix_mult_po is
    Port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        
        -- Controle
        ld_regs     : in  std_logic;
        clr_acc     : in  std_logic;
        ld_acc      : in  std_logic;
        wr_res      : in  std_logic;
        inc_k, inc_j, inc_i : in  std_logic;
        clr_k, clr_j, clr_i : in  std_logic;
        
        -- Status (Done quando contadores chegam a 2)
        k_done      : out std_logic;
        j_done      : out std_logic;
        i_done      : out std_logic;
        
        -- Dados
        A_in        : in  t_matrix_in;
        B_in        : in  t_matrix_in;
        R_out       : out t_matrix_out
    );
end matrix_mult_po;

architecture Behavioral of matrix_mult_po is
    signal reg_A : t_matrix_in;
    signal reg_B : t_matrix_in;
    signal reg_R : t_matrix_out := (others => (others => (others => '0')));
    
    -- Contadores agora vão de 0 a 2 (3 iterações)
    signal i, j, k : integer range 0 to 2 := 0;
    
    signal mult_res : unsigned(15 downto 0);
    signal acc      : unsigned(19 downto 0);
begin

    -- Multiplicação Padrão: Linha de A x Coluna de B
    -- A(i,k) * B(k,j)
    mult_res <= reg_A(i, k) * reg_B(k, j);

    process(clk, rst)
    begin
        if rst = '1' then
            i <= 0; j <= 0; k <= 0;
            acc <= (others => '0');
            reg_R <= (others => (others => (others => '0')));
            reg_A <= (others => (others => (others => '0')));
            reg_B <= (others => (others => (others => '0')));
        elsif rising_edge(clk) then
            -- Carregar Entradas
            if ld_regs = '1' then
                reg_A <= A_in;
                reg_B <= B_in;
            end if;

            -- Acumulador
            if clr_acc = '1' then
                acc <= (others => '0');
            elsif ld_acc = '1' then
                acc <= acc + resize(mult_res, 20);
            end if;

            -- Escrever Resultado
            if wr_res = '1' then
                reg_R(i, j) <= acc;
            end if;

            -- Contadores
            if clr_k = '1' then k <= 0;
            elsif inc_k = '1' then k <= k + 1; end if;

            if clr_j = '1' then j <= 0;
            elsif inc_j = '1' then j <= j + 1; end if;

            if clr_i = '1' then i <= 0;
            elsif inc_i = '1' then i <= i + 1; end if;
        end if;
    end process;

    -- Sinais de Status: Done quando o contador é 2 (Tamanho - 1)
    k_done <= '1' when k = 2 else '0';
    j_done <= '1' when j = 2 else '0';
    i_done <= '1' when i = 2 else '0';
    
    R_out <= reg_R;

end Behavioral;