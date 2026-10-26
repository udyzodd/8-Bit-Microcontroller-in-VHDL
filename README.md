# 8-Bit ALU in VHDL

An 8-bit Arithmetic Logic Unit (ALU) implemented in VHDL and verified using GHDL simulation and GTKWave waveform analysis.

This project is being developed incrementally to explore digital logic design, arithmetic operations, status flags, and hardware verification.

## Current Status

- [x] Implemented an 8-bit ALU
- [x] Implemented arithmetic and bitwise logical operations
- [x] Implemented NZVC status flags
- [x] Created a VHDL testbench
- [x] Passed 12 simulation test cases
- [x] Inspected simulation waveforms using GTKWave
- [x] Organized source code, testbench, and simulation folders
- [ ] Implement XOR and NOT operations
- [ ] Implement logical shift-left and shift-right operations
- [ ] Expand the operation selector to support all planned operations
- [ ] Extend test coverage for additional operations

## Project Structure

```text
VHDL/
├── src/
│   └── alu.vhd          # ALU implementation
├── tb/
│   └── tb_alu.vhd       # ALU testbench
├── sim/
│   └──                 # Saved waveform layouts (planned)
├── .gitignore           # Excludes generated files
└── README.md            # Project documentation
```

Generated simulation files, such as `alu.ghw` and `work-obj08.cf`, are not intended to be committed to version control.

## Supported Operations

The ALU takes two 8-bit inputs, `A` and `B`, and a 3-bit operation selector, `ALU_Sel`. It produces an 8-bit `Result` and four status flags.

| `ALU_Sel` | Operation | Description |
|---|---|---|
| `000` | ADD | Adds `A` and `B` |
| `001` | SUB | Subtracts `B` from `A` |
| `010` | AND | Bitwise AND of `A` and `B` |
| `011` | OR | Bitwise OR of `A` and `B` |
| `100` | INC | Increments `A` by 1 |
| `101` | DEC | Decrements `A` by 1 |
| `110` | Default | Falls back to addition |
| `111` | Default | Falls back to addition |

The default selector cases will be replaced as additional operations are implemented.

## Status Flags: NZVC

The `NZVC` output is a four-bit vector, ordered from most significant bit to least significant bit.

| Flag | Name | Meaning |
|---|---|---|
| `N` | Negative | Copies the most significant bit of the result |
| `Z` | Zero | Set when the result is `00` |
| `V` | Overflow | Indicates signed overflow for addition or subtraction |
| `C` | Carry | Carry-out for addition; no unsigned borrow for subtraction |

For operations other than addition and subtraction, the current implementation sets `V` and `C` to `0`.

## Tools Used

- **VHDL** — Hardware description language
- **GHDL** — VHDL compiler and simulator
- **GTKWave** — Waveform visualization
- **Git** — Version control

The current implementation uses Synopsys arithmetic packages, so the GHDL commands use the `-fsynopsys` option.

## Getting Started

The following commands assume Ubuntu or another Linux environment with GHDL installed and that the terminal is opened at the repository root.

### 1. Install the tools

```bash
sudo apt update
sudo apt install ghdl gtkwave
```

### 2. Analyze the VHDL source and testbench

```bash
ghdl -a --std=08 -fsynopsys src/alu.vhd
ghdl -a --std=08 -fsynopsys tb/tb_alu.vhd
```

### 3. Elaborate the testbench

```bash
ghdl -e --std=08 -fsynopsys tb_ALU
```

### 4. Run the simulation

```bash
ghdl -r --std=08 -fsynopsys tb_ALU --stop-time=200ns
```

The current testbench completes at approximately `120 ns` and reports the results of its test cases in the terminal.

### 5. Generate a waveform

```bash
ghdl -r --std=08 -fsynopsys tb_ALU \
  --wave=alu.ghw --stop-time=200ns
```

Open the generated waveform in GTKWave:

```bash
gtkwave alu.ghw
```

Add the following signals to the waveform display:

- `A`
- `B`
- `ALU_Sel`
- `Result`
- `NZVC`

Hexadecimal display is useful for `A`, `B`, and `Result`, while binary display makes the operation selector and status flags easier to interpret.

Generated waveform files are ignored by Git and can be recreated at any time.

## Verification

The current testbench contains 12 test cases. All 12 passed in the latest recorded simulation.

The tests cover:

- Addition and subtraction
- Bitwise AND and OR
- Increment and decrement
- Signed overflow during addition
- Carry-out during addition
- Unsigned borrow behavior during subtraction
- Zero and negative result flags
- 8-bit arithmetic wraparound

### Example Results

| Test case | Inputs | Expected result | Observed result |
|---|---|---|---|
| Addition | `0A + 14` | `1E` | `1E` |
| Subtraction | `0A - 14` | `F6` | `F6` |
| AND | `0F AND 0A` | `0A` | `0A` |
| OR | `0F OR 0A` | `0F` | `0F` |
| Increment | `FF + 1` | `00` | `00` |
| Decrement | `00 - 1` | `FF` | `FF` |

The simulation waveforms were also inspected to verify the changes in operands, operation selection, results, and status flags over time.

## Simulation Results

The ALU was simulated using GHDL, and its behavior was inspected using GTKWave.

### Testbench Output

The testbench currently includes 12 test cases covering arithmetic operations, logical operations, status flags, overflow, carry, borrow, and 8-bit wraparound.

All 12 test cases passed in the latest recorded simulation.

![ALU testbench results](docs/images/simulation_results.png)

### GTKWave Simulation

The waveform below shows the ALU inputs (`A`, `B`), operation selector (`ALU_Sel`), output (`Result`), and status flags (`NZVC`) changing during the simulation.

![ALU waveform in GTKWave](docs/images/gtkwave_alu.png)

### Representative Results

| Operation | Inputs | Result | NZVC |
|---|---|---|---|
| ADD | `0A + 14` | `1E` | `0` |
| SUB | `0A - 14` | `F6` | `8` |
| AND | `0F AND 0A` | `0A` | `0` |
| OR | `0F OR 0A` | `0F` | `0` |
| ADD with signed overflow | `7F + 01` | `80` | `A` |
| ADD with carry-out | `FF + 01` | `00` | `5` |
| INC | `FF + 1` | `00` | `4` |
| DEC | `00 - 1` | `FF` | `8` |

The `NZVC` values are displayed in hexadecimal. For example, `A` represents `1010` (negative and overflow set), while `5` represents `0101` (zero and carry set).

## Planned Improvements

1. Implement XOR and bitwise NOT.
2. Implement logical shift-left and shift-right.
3. Expand `ALU_Sel` from 3 bits to 4 bits to assign distinct codes to all ten planned operations.
4. Add test cases for every new operation and its boundary conditions.
5. Investigate and eliminate the arithmetic warning observed during initial simulation.
6. Integrate additional operations with the microcontroller's instruction decoder and control logic if instruction-level support is required.

## Learning Objectives

This project provides practical experience with:

- Combinational digital logic
- Fixed-width arithmetic
- Signed overflow and unsigned carry/borrow
- VHDL testbench development
- Simulation-driven verification
- Timing waveform analysis
- Version control and project organization

---

**Project status:** In progress — core ALU operations implemented and verified through simulation.

## RAM Module (96x8)

The RAM block is the microcontroller's data memory. It stores byte-sized values, provides read access to the currently selected address, and writes new data only when a valid write pulse is detected on the clock edge. In a typical microcontroller, this kind of memory is used to hold operands, intermediate results, variables, and temporary data during instruction execution.

The implemented module is a synchronous memory array of 96 bytes, addressed using a 7-bit address bus. Each memory location stores one 8-bit value, so the total memory size is:

- 96 addresses
- 8 bits per address
- total capacity = 96 x 8 = 768 bits

### Functional Overview

The RAM consists of three main functional parts:

1. Address selection
2. Write control
3. Data storage and readout

At any time, the selected address is decoded from `address(6 downto 0)`. If `write = '1'` during a rising clock edge, the value from `data_in` is stored into that location. The value at the selected address is continuously driven onto `data_out`.

### Block Diagram

```text
                     +-------------------+
                     |   RAM Array       |
                     | 96 x 8 Memory    |
                     |                   |
 address(6:0)  ------>|                   |
                     |                   |----> data_out(7:0)
 data_in(7:0) -------->|                   |
                     |                   |
 write  -------------->|  Write Control    |
 clock  -------------->|  Rising Edge      |
                     +-------------------+
```

The diagram above shows the basic structure: the address selects one of the 96 memory locations, the write signal controls whether a new byte is stored, and the stored byte is read back through `data_out`.

### Port and Signal Description

| Signal | Width | Direction | Description |
|---|---:|---|---|
| `address` | 7 bits | input | Selects one of 96 memory locations |
| `data_in` | 8 bits | input | Data byte written into the selected memory location |
| `write` | 1 bit | input | Enables write operation when asserted |
| `clock` | 1 bit | input | Synchronous clock used for write timing |
| `data_out` | 8 bits | output | Reads the current data value at the selected address |

### Operating Principle

The module uses a `process(clock)` block with a rising-edge trigger. This means the memory is updated only when the clock transitions from low to high.

```vhdl
process(clock)
begin
    if rising_edge(clock) then
        if write = '1' then
            RAM(conv_integer(unsigned(address))) <= data_in;
        end if;
    end if;
end process;
```

This behavior is important because it makes the RAM synchronous and predictable. It ensures that memory changes happen at a known time in the system clock cycle, which is ideal for digital design and HDL-based verification.

### Read Behavior

The read path is asynchronous with respect to the clock in the sense that the output is always driven from the selected memory cell:

```vhdl
data_out <= RAM(conv_integer(unsigned(address)));
```

This means the data at the chosen address is immediately available on `data_out`, while the write operation occurs only on clock edges.

### Memory Organization

The memory is declared as an array of 96 bytes:

```vhdl
type data_mem is array (0 to 95) of std_logic_vector(7 downto 0);
```

Each cell is addressed from `0` to `95`, which corresponds to addresses from `0000000` to `1011111` in binary. The module uses a 7-bit bus because:

- 2^7 = 128 possible addresses
- 96 addresses are used in practice
- the valid range is `0..95`

### Initial Memory Content

The RAM is initialized with a small set of test values to support early simulation and debugging. The first few locations are defined as follows:

| Address | Value | Purpose |
|---|---|---|
| `0000000` | `x"33"` | Initial byte at address 0 |
| `0000001` | `x"22"` | Initial byte at address 1 |
| `0000010` to `0000101` | `x"00"` | Empty/default locations |

The remaining addresses are also initialized to `x"00"` to keep the memory array predictable during simulation.

### Memory Timing Behavior

| Clock condition | `write` | Result |
|---|---|---|
| Rising edge | `0` | No write; existing memory value remains unchanged |
| Rising edge | `1` | `data_in` is written into the selected address |
| No clock edge | either | No state change occurs |

This makes the RAM well suited for a synchronous processor design, where every write is aligned to a system clock cycle.

### Why This RAM Is Useful in the Microcontroller

This memory block acts as the data store for the processor. It can be used for:

- storing runtime variables
- holding intermediate arithmetic results
- buffering input/output data
- temporary storage for controller operations
- general-purpose register-like data access

Because it is byte-addressable and synchronous, it integrates cleanly with other digital blocks in the microcontroller datapath.

### RAM Testbench Summary

A separate testbench, `tb_ram.vhd`, validates the RAM behavior under realistic conditions.

It checks:

- initial value at address `0`
- initial value at address `1`
- successful write to address `5`
- no write when `write = '0'`
- data retention in neighboring memory locations

The tests also confirm that the memory preserves previously stored values unless a valid write operation is triggered.

```vhdl
-- Test 1: Check initial value at address 0
address <= "0000000";
assert data_out = x"33"
    report "FAIL: Initial value at address 0"
    severity failure;

-- Test 2: Check initial value at address 1
address <= "0000001";
assert data_out = x"22"
    report "FAIL: Initial value at address 1"
    severity failure;

-- Test 3: Write AB to address 5
address <= "0000101";
data_in <= x"AB";
write <= '1';
wait until rising_edge(clock);
assert data_out = x"AB"
    report "FAIL: Write/read at address 5"
    severity failure;

-- Test 4: Write disabled, value should remain unchanged
write <= '0';
data_in <= x"55";
wait until rising_edge(clock);
assert data_out = x"AB"
    report "FAIL: RAM changed when write was disabled"
    severity failure;
```

### Vivado / Schematic Validation

The RAM module was verified in Vivado and confirmed to behave correctly in both simulation and synthesis flow. The block-level implementation is consistent with a standard synchronous memory array used in processor-style designs.

![RAM Schematic](docs/images/RAM_schematic.png)

### RAM Simulation Results

The waveform confirms the expected behavior of the memory block during successive operations. In the simulation, the initial data is visible at startup, a write is performed at a selected address, and the memory state is preserved when write enable is disabled.

![RAM Simulation](docs/images/RAM_waveform.png)

### Verification Outcomes

| Check | Result |
|---|---|
| Initial memory values read correctly | Pass |
| Write operation updates selected address | Pass |
| Data read back correctly after write | Pass |
| `write = '0'` prevents accidental overwrite | Pass |
| Other addresses remain unchanged | Pass |

All RAM tests passed successfully in the verification flow, confirming the design is stable and suitable for use in the 8-bit microcontroller architecture.

---

**Project status:** ALU implemented and verified; RAM module added, validated, and documented as the next functional block in the microcontroller datapath.
