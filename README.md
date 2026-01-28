# Counts - SPARK Ada Character Counting Library

A formally verified Ada library for counting character occurrences in buffers, developed using SPARK and proven correct with GNAT Prove.

## Overview

This project demonstrates formal verification techniques in Ada/SPARK by implementing a character counting algorithm with mathematical proofs of correctness. The implementation guarantees that the sum of all character counts equals the input buffer length.

## Features

- **Formally Verified**: All functions and procedures are proven correct using SPARK formal verification
- **Character Counting**: Efficiently counts occurrences of each character in a buffer
- **Mathematical Guarantees**: Proven postconditions ensure correctness
- **Ghost Code**: Includes lemmas and proof obligations for verification

## Project Structure

```
counts.ads          - Package specification with public interface
counts.adb          - Package body with implementation and proofs
gnatprove/          - GNAT Prove verification artifacts
obj/                - Compilation output directory
```

## Key Components

### Types

- **Buffer**: Array of characters with configurable index range (max size: 1024)
- **Counts_Array**: Maps each character to its occurrence count
- **Length**: Integer subtype representing valid buffer lengths (0 to 1024)

### Public Functions

#### `Char_Counts`
```ada
function Char_Counts (Input : Buffer) return Counts_Array
```
Counts the occurrences of each character in the input buffer.

**Postcondition**: The sum of all counts equals the input buffer length.

#### `Sum`
```ada
function Sum (Arr : Counts_Array; Up_To : Character) return Int32
function Sum (Arr : Counts_Array) return Int32
```
Computes the sum of counts up to a specified character or across all characters.

### Verification Lemmas

The implementation includes several ghost procedures (lemmas) used for formal verification:

- **Lem_Sum_Zero**: Proves that an all-zero array sums to zero
- **Lem_Incr_Eq**: Proves sum equality when incrementing a position after the range
- **Lem_Incr_Neq**: Proves sum increases by 1 when incrementing a position within the range

## Building and Verification

### Prerequisites

- GNAT compiler with SPARK support
- GNAT Prove verification tool

### Compilation

```bash
gprbuild -P test.gpr
```

### Formal Verification

Run GNAT Prove to verify all proof obligations:

```bash
gnatprove -P test.gpr --level=2
```

## Implementation Details

The `Char_Counts` function uses a loop to iterate through the input buffer, incrementing the count for each character encountered. At each iteration:

1. A ghost copy of the counts array is saved
2. The count for the current character is incremented
3. Lemmas are applied to prove that the sum property is maintained
4. Loop invariants ensure all counts remain valid and the sum equals processed characters

## Verification Guarantees

This implementation provides mathematical proof of:

- **Correctness**: The sum of all character counts always equals the input length
- **Bounds Safety**: No array indices are out of bounds
- **Overflow Prevention**: All arithmetic operations stay within valid ranges
- **Loop Invariants**: Properties are maintained throughout execution

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Additional Resources

- [SPARK Ada Documentation](https://www.adacore.com/about-spark)
- [GNAT Prove User's Guide](https://docs.adacore.com/spark2014-docs/html/ug/)
