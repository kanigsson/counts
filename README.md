# SPARK Character Counting Example

A simple example demonstrating formal verification in SPARK Ada. This code accompanies a blog post showing how to prove functional correctness properties using GNAT Prove.

## The Example

This example implements a character counting function that:
- Takes a buffer of characters as input
- Returns an array counting occurrences of each character
- **Proves** that the sum of all counts equals the input buffer length

## Key Files

- [counts.ads](counts.ads) - Package specification with the public interface and postconditions
- [counts.adb](counts.adb) - Implementation with loop invariants and verification lemmas

## What This Demonstrates

This example shows several SPARK verification techniques:

- **Postconditions**: Guaranteeing functional correctness (`Sum(Result) = Input'Length`)
- **Loop invariants**: Maintaining properties across iterations
- **Ghost code**: Helper lemmas that exist only for verification
- **Automatic proof**: GNAT Prove verifies all properties automatically at level 2

## Running Verification

```bash
gnatprove -P test.gpr --level=2
```

All proof obligations should discharge successfully using SPARK Pro 26.1.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Additional Resources

- [SPARK Ada Documentation](https://www.adacore.com/about-spark)
- [GNAT Prove User's Guide](https://docs.adacore.com/spark2014-docs/html/ug/)
