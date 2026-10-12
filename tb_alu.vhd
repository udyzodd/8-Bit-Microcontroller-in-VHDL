library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_ALU is
end tb_ALU;

architecture test of tb_ALU is
    signal A       : std_logic_vector(7 downto 0) := (others => '0');
    signal B       : std_logic_vector(7 downto 0) := (others => '0');
    signal ALU_Sel : std_logic_vector(2 downto 0) := (others => '0');
    signal NZVC    : std_logic_vector(3 downto 0);
    signal Result  : std_logic_vector(7 downto 0);
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
        procedure check_case(
            constant test_name : in string;
            constant a_value   : in std_logic_vector(7 downto 0);
            constant b_value   : in std_logic_vector(7 downto 0);
            constant sel_value : in std_logic_vector(2 downto 0);
            constant exp_result: in std_logic_vector(7 downto 0);
            constant exp_flags : in std_logic_vector(3 downto 0)
        ) is
        begin
            A <= a_value;
            B <= b_value;
            ALU_Sel <= sel_value;
            wait for 10 ns;

            assert Result = exp_result
                report "FAIL " & test_name &
                       ": Result expected " & to_hstring(exp_result) &
                       ", got " & to_hstring(Result)
                severity error;

            assert NZVC = exp_flags
                report "FAIL " & test_name &
                       ": NZVC expected " & to_hstring(exp_flags) &
                       ", got " & to_hstring(NZVC)
                severity error;

            report "PASS " & test_name &
                   " Result=" & to_hstring(Result) &
                   " NZVC=" & to_hstring(NZVC)
                severity note;
        end procedure;
    begin
        -- Existing basic cases
        check_case("ADD 0A + 14", x"0A", x"14", "000", x"1E", "0000");
        check_case("SUB 0A - 14", x"0A", x"14", "001", x"F6", "1000");
        check_case("AND 0F & 0A", x"0F", x"0A", "010", x"0A", "0000");
        check_case("OR 0F | 0A", x"0F", x"0A", "011", x"0F", "0000");
        check_case("INC 0F + 1", x"0F", x"00", "100", x"10", "0000");
        check_case("DEC 10 - 1", x"10", x"00", "101", x"0F", "0000");

        -- Overflow: signed +127 + 1 = signed -128 (8-bit representation)
        check_case("ADD signed overflow 7F + 01",
                   x"7F", x"01", "000", x"80", "1010");

        -- No signed overflow: -1 + 1 = 0, with carry out
        check_case("ADD FF + 01",
                   x"FF", x"01", "000", x"00", "0101");

        -- Subtraction without borrow: 14 - 0A = 0A
        check_case("SUB 14 - 0A",
                   x"14", x"0A", "001", x"0A", "0001");

        -- Borrow: 00 - 01 = FF (8-bit wraparound)
        check_case("SUB 00 - 01",
                   x"00", x"01", "001", x"FF", "1000");

        -- Increment wraps around: FF + 1 = 00
        check_case("INC FF",
                   x"FF", x"00", "100", x"00", "0100");

        -- Decrement wraps around: 00 - 1 = FF
        check_case("DEC 00",
                   x"00", x"00", "101", x"FF", "1000");

        report "All test cases completed.";
        std.env.stop;
        wait;
    end process;
end test;