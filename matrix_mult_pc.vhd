library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity matrix_mult_pc is
    Port (
        clk, rst, start : in  std_logic;
        done            : out std_logic;
        
        -- Inputs da PO
        k_done, j_done, i_done : in  std_logic;
        
        -- Outputs para PO
        ld_regs, clr_acc, ld_acc, wr_res : out std_logic;
        inc_k, inc_j, inc_i : out std_logic;
        clr_k, clr_j, clr_i : out std_logic
    );
end matrix_mult_pc;

architecture Behavioral of matrix_mult_pc is
    type state_type is (IDLE, SETUP, INIT_I, INIT_J, INIT_K, CALC, CHECK_K, WRITE_RES, CHECK_J, CHECK_I, FINISHED);
    signal current_state, next_state : state_type;
begin

    process(clk, rst)
    begin
        if rst = '1' then current_state <= IDLE;
        elsif rising_edge(clk) then current_state <= next_state;
        end if;
    end process;

    process(current_state, start, k_done, j_done, i_done)
    begin
        -- Defaults
        ld_regs<='0'; clr_acc<='0'; ld_acc<='0'; wr_res<='0';
        inc_k<='0'; inc_j<='0'; inc_i<='0';
        clr_k<='0'; clr_j<='0'; clr_i<='0';
        done<='0'; next_state <= current_state;

        case current_state is
            when IDLE =>
                if start = '1' then next_state <= SETUP; end if;
            when SETUP =>
                ld_regs <= '1'; next_state <= INIT_I;
            when INIT_I =>
                clr_i <= '1'; next_state <= INIT_J;
            when INIT_J =>
                clr_j <= '1'; next_state <= INIT_K;
            when INIT_K =>
                clr_k <= '1'; clr_acc <= '1'; next_state <= CALC;
            when CALC =>
                ld_acc <= '1'; next_state <= CHECK_K;
            when CHECK_K =>
                if k_done = '1' then next_state <= WRITE_RES;
                else inc_k <= '1'; next_state <= CALC; end if;
            when WRITE_RES =>
                wr_res <= '1'; next_state <= CHECK_J;
            when CHECK_J =>
                if j_done = '1' then next_state <= CHECK_I;
                else inc_j <= '1'; next_state <= INIT_K; end if;
            when CHECK_I =>
                if i_done = '1' then next_state <= FINISHED;
                else inc_i <= '1'; next_state <= INIT_J; end if;
            when FINISHED =>
                done <= '1';
                if start = '0' then next_state <= IDLE; end if;
            when others => next_state <= IDLE;
        end case;
    end process;
end Behavioral;