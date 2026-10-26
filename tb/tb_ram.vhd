
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ram is
end tb_ram;

architecture Behavioral of tb_ram is

    -- Signals connected to the RAM
    signal address  : std_logic_vector(6 downto 0) := (others => '0');
    signal data_in  : std_logic_vector(7 downto 0) := (others => '0');
    signal write    : std_logic := '0';
    signal clock    : std_logic := '0';
    signal data_out : std_logic_vector(7 downto 0);

begin

    -- Instantiate the RAM under test
    DUT: entity work.rw_96x8_sync
        port map (
            address  => address,
            data_in  => data_in,
            write    => write,
            clock    => clock,
            data_out => data_out
        );

    -- Generate a 10 ns clock period
    clock_process: process
    begin
        while true loop
            clock <= '0';
            wait for 5 ns;
            clock <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Apply inputs and verify RAM behavior
    stimulus_process: process
    begin

        -- Test 1: Check initial value at address 0
        address <= "0000000";
        wait for 1 ns;

        assert data_out = x"33"
            report "FAIL: Initial value at address 0"
            severity failure;

        -- Test 2: Check initial value at address 1
        address <= "0000001";
        wait for 1 ns;

        assert data_out = x"22"
            report "FAIL: Initial value at address 1"
            severity failure;

        -- Test 3: Write AB to address 5
        wait until falling_edge(clock);
        address <= "0000101";
        data_in <= x"AB";
        write <= '1';

        wait until rising_edge(clock);
        wait for 1 ns;

        assert data_out = x"AB"
            report "FAIL: Write/read at address 5"
            severity failure;

        report "PASS: Write/read at address 5";

        -- Test 4: Disable writing and check data is preserved
        write <= '0';
        data_in <= x"55";

        wait until rising_edge(clock);
        wait for 1 ns;

        assert data_out = x"AB"
            report "FAIL: RAM changed when write was disabled"
            severity failure;

        report "PASS: Data preserved when write = 0";

        -- Test 5: Check that another address is unchanged
        address <= "0000110";
        wait for 1 ns;

        assert data_out = x"00"
            report "FAIL: Address 6 should remain zero"
            severity failure;

        report "PASS: Other address remains unchanged";
        report "ALL RAM TESTS PASSED";

        wait;
    end process;

end Behavioral;
