library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ALU is
    port (
        A, B     : in  std_logic_vector(7 downto 0);
        -- Two 8-bit input operands

        ALU_Sel  : in  std_logic_vector(2 downto 0);
        -- Selects which ALU operation to perform

        NZVC     : out std_logic_vector(3 downto 0);
        -- Status flags: N = Negative, Z = Zero,
        --               V = Overflow, C = Carry

        Result   : out std_logic_vector(7 downto 0)
        -- 8-bit result produced by the ALU
    );
end ALU;

architecture Behavioral of ALU is

    -- Stores the 8-bit result of the selected operation.
    signal ALU_Result : std_logic_vector(7 downto 0);

    -- 9-bit intermediate result used to capture carry-out
    -- from addition and determine carry/no-borrow in subtraction.
    signal ALU_ADD : std_logic_vector(8 downto 0);

    -- Individual status flags.
    signal C, Z, V, N : std_logic;

    -- Intermediate signals for signed overflow detection.
    signal add_ov, sub_ov : std_logic;

begin

    -- =====================================================
    -- Main ALU operation selection
    -- Sensitivity list contains all signals read by process.
    -- =====================================================

    process(ALU_Sel, A, B)
    begin

        -- Default extended result: prevents ALU_ADD from
        -- retaining an old carry value for other operations.
        ALU_ADD <= "000000000";

        case ALU_Sel is

            when "000" =>
                -- ADD: A + B
                -- The extra leading zero allows the 9-bit
                -- result to preserve the carry-out bit.
                ALU_ADD <= ('0' & A) + ('0' & B);
                ALU_Result <= A + B;

            when "001" =>
                -- SUB: A - B
                -- ALU_Result keeps the lower 8 result bits.
                -- ALU_ADD is used to determine carry/no-borrow.
                ALU_Result <= A - B;
                ALU_ADD <= ('0' & A) - ('0' & B);

            when "010" =>
                -- AND: output bit is 1 only if both input
                -- bits are 1.
                ALU_Result <= A and B;

            when "011" =>
                -- OR: output bit is 1 if either input bit
                -- is 1.
                ALU_Result <= A or B;

            when "100" =>
                -- Increment: A + 1
                ALU_Result <= A + x"01";

            when "101" =>
                -- Decrement: A - 1
                ALU_Result <= A - x"01";

            when others =>
                -- Fallback for unused selection codes.
                -- Currently performs A + B.
                ALU_Result <= A + B;

        end case;
    end process;


    -- =====================================================
    -- Output result and Negative/Zero flags
    -- =====================================================

    Result <= ALU_Result;

    -- N (Negative): copies the most significant result bit.
    -- For signed 8-bit two's-complement numbers, 1 indicates
    -- a negative result.
    N <= ALU_Result(7);

    -- Z (Zero): set when all 8 result bits are zero.
    Z <= '1' when ALU_Result = x"00" else '0';


    -- =====================================================
    -- Signed overflow detection
    -- =====================================================

    -- Addition overflow occurs when A and B have the same
    -- sign but the result has the opposite sign.
    add_ov <=
        (A(7) and B(7) and (not ALU_Result(7))) or
        ((not A(7)) and (not B(7)) and ALU_Result(7));

    -- Subtraction overflow occurs when A and B have
    -- different signs and the result's sign differs from A.
    sub_ov <=
        (A(7) and (not B(7)) and (not ALU_Result(7))) or
        ((not A(7)) and B(7) and ALU_Result(7));

    -- Select the appropriate overflow flag for the operation.
    -- Other operations do not set the overflow flag.
    with ALU_Sel select
        V <= add_ov when "000",
             sub_ov when "001",
             '0'    when others;

    -- =====================================================
    -- Carry flag
    -- =====================================================


    -- ADD: ALU_ADD(8) is the carry-out bit.
    -- SUB: inverted extended subtraction MSB means C = 1
    -- when no unsigned borrow occurs.
    -- Other operations clear the carry flag.
    with ALU_Sel select
        C <= ALU_ADD(8)      when "000",
             not ALU_ADD(8)  when "001",
             '0'             when others;
    -- Combine the flags in the order N, Z, V, C.
    -- NZVC(3) = N, NZVC(2) = Z,
    -- NZVC(1) = V, NZVC(0) = C.
    NZVC <= N & Z & V & C;
end Behavioral;