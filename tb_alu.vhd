
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_ALU is
end tb_ALU;

architecture test of tb_ALU is

    signal A, B : std_logic_vector(7 downto 0);
    signal ALU_Sel : std_logic_vector(2 downto 0);
    signal NZVC : std_logic_vector(3 downto 0);
    signal Result : std_logic_vector(7 downto 0);

begin

    uut: entity work.ALU
        port map (
            A       => A,
            B       => B,
            ALU_Sel => ALU_Sel,
            NZVC    => NZVC,
            Result  => Result
        );

    process
    begin
        -- ADD: 10 + 20 = 30
        A <= x"0A"; B <= x"14"; ALU_Sel <= "000";
        wait for 10 ns;
        report "ADD Result=" & to_hstring(Result)
            & " NZVC=" & to_hstring(NZVC);

        -- SUB: B - A = 20 - 10 = 10
        A <= x"0A"; B <= x"14"; ALU_Sel <= "001";
        wait for 10 ns;
        report "SUB Result=" & to_hstring(Result)
            & " NZVC=" & to_hstring(NZVC);

        -- AND: 0F AND 0A = 0A
        A <= x"0F"; B <= x"0A"; ALU_Sel <= "010";
        wait for 10 ns;
        report "AND Result=" & to_hstring(Result)
            & " NZVC=" & to_hstring(NZVC);

        -- OR: 0F OR 0A = 0F
        A <= x"0F"; B <= x"0A"; ALU_Sel <= "011";
        wait for 10 ns;
        report "OR Result=" & to_hstring(Result)
            & " NZVC=" & to_hstring(NZVC);

        -- Increment: 0F + 1 = 10
        A <= x"0F"; B <= x"00"; ALU_Sel <= "100";
        wait for 10 ns;
        report "INC Result=" & to_hstring(Result)
            & " NZVC=" & to_hstring(NZVC);

        -- Decrement: 10 - 1 = 0F
        A <= x"10"; B <= x"00"; ALU_Sel <= "101";
        wait for 10 ns;
        report "DEC Result=" & to_hstring(Result)
            & " NZVC=" & to_hstring(NZVC);

        -- Zero flag test: 0 + 0 = 0
        A <= x"00"; B <= x"00"; ALU_Sel <= "000";
        wait for 10 ns;
        report "ZERO Result=" & to_hstring(Result)
            & " NZVC=" & to_hstring(NZVC);

        -- Carry flag test: 255 + 1 = 0 (8-bit result)
        A <= x"FF"; B <= x"01"; ALU_Sel <= "000";
        wait for 10 ns;
        report "CARRY Result=" & to_hstring(Result)
            & " NZVC=" & to_hstring(NZVC);

        report "Simulation completed.";
        std.env.stop;
        wait;
    end process;

end test;
