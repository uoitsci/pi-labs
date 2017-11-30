+++
draft = false
title = "Creating Circuits on the Breadboard - Part 2"
Weight = 5
+++

## Full Adders

A full adder is a circuit that adds two binary digits, plus a carry in, producing a sum and a carry out bit.  The carry bit is one (high) when the three bits add up to more than can be stored in a single digit.  This happens when two or more of the input bits is one (high).

### Circuit Design

The same process used for the half adder can be used to design the circuit for a full adder, starting with the truth table (which is filled out by hand, based on what we know about the behaviour of the circuit).

A | B | Carry in | Sum | Carry out
-------|-------|-------|-------|-------
0 | 0 | 0 | 0 | 0
0 | 0 | 1 | 1 | 0
0 | 1 | 0 | 1 | 0
0 | 1 | 1 | 0 | 1
1 | 0 | 0 | 1 | 0
1 | 0 | 1 | 0 | 1
1 | 1 | 0 | 0 | 1
1 | 1 | 1 | 1 | 1

Using a Karnaugh map, and knowledge of XOR, we can get simplified Boolean algebraic expressions for each of the two output variables.

$$S = A \oplus B \oplus C\_{in}$$

$$C\_{out} = ((A \oplus B) \land C\_{in}) \lor (A \land B)$$

The circuit corresponding to these Boolean algebraic expressions is shown below.

{{<img src="/images/full-adder.png" hidpi="/images/full-adder@2x.png" alt="The circuit for a full adder">}}

### Hardware Setup

In addition to the components from the half adder, we'll need to add a 7432 chip for the single OR gate that is shown in the circuit diagram.  Connect power and ground to this chip accordingly.  Connect the gate inputs and outputs according to the following table:

Gate  | Input 1 | Input 2 | Output
------|---------|---------|-------
XOR 1 | A (GPIO22, pin #15) | B (GPIO17, pin #11) | XOR 2 input 1
XOR 2 | XOR 1 output | $C\_{in}$ (GPIO04, pin #7) | S (GPIO23, pin #16)
AND 1 | $C\_{in}$ (GPIO04, pin #7) | XOR 1 output | OR input 1
AND 2 | A (pin #15, GPIO #22) | B (GPIO17, pin #11) | OR input 2
OR    | AND 1 output | AND 2 output | $C\_{out}$ (GPIO24, pin #18)

The resulting circuit should look something like the following illustration.

{{<img src="/images/FullAdder_bb.png" hidpi="/images/FullAdder_bb@2x.png" alt="The hardware configuration for a full adder" id="full-adder-bb">}}

## Exercise

Write some code in Python to test your full adder circuit will all possible inputs.  Use the `half_adder_test.py` as a starting point.
