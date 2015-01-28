+++
draft = false
title = "Creating Circuits on the Breadboard"
Weight = 4
+++

In this lab we are going to experiment with gates and circuit design.  We'll use our understanding of gate behaviour to design a half adder and a full adder circuit, each of which will be implemented on the breadboard and interfaces with the Raspberry Pi.

# The 74xx Series
The 74xx series of chips generally contain logic gates and other components.  For example, the 7402 chip contains 4 NOR gates on a single 14-pin chip.  There are many variations, including some that have memory (flip-flops, latches).  The table below summarizes some of these chips.

<table class="wikitable">
<caption>Summary of Notable 74xx Chips</caption>
  <tr>
    <th>Base Model</th>
	<th>Description</th>
  </tr>
  <tr>
    <td>7400</td>
    <td>Four 2-input NAND gates</td>
  </tr>
  <tr>
    <td>7402</td>
    <td>Four 2-input NOR gates</td>
  </tr>
  <tr>
    <td>7404</td>
    <td>Four 1-input inverters (NOT gates)</td>
  </tr>
  <tr>
    <td>7408</td>
    <td>Four 2-input AND gates</td>
  </tr>
  <tr>
    <td>7432</td>
    <td>Four 2-input OR gates</td>
  </tr>
  <tr>
    <td>7486</td>
    <td>Four 2-input XOR gates</td>
  </tr>
</table> 

Nearly all of these chips has a very similar pin layout.  The diagram below describes the pin layout for the 7400 chip:

{{<img src="/images/7400_pinout.png" alt="Pinouts for the 7400 chip">}}

To use one of these chips, connect pin 7 to ground, and pin 14 to a power source (e.g. one of the 5v pins on the Raspberry Pi's GPIO array).  You can then connect two inputs (either GPIO output ports or directly from power source) to pins 1 and 2, and connect the output (pin 3) to either an LED (with an appropriate resistor) or a GPIO input port.  You can also combine gates together, by connecting output pins to input pins.

Note:  Be sure to orient the chip so that the dot appears on the left side.  Failure to do so could reverse the power and ground wiring, which will make the chip get very hot.  If this happens, do not touch the chip and immediately disconnect power.  Wait until the chip has had a chance to cool before re-orienting it.

# Half Adders
A half adder is a circuit that adds two binary digits, producing a sum and a carry bit.  The carry bit is one when the two bits add up to more than can be stored in a single digit.  This happens when both input bits are one (high), which produces a zero (low) sum bit and a one (high) carry bit.

## Circuit Design
One can easily construct a half adder for two input bits (X and Y) by drawing the truth table for both sum (S) and carry (C), as shown below:

<table class="wikitable">
  <caption>Truth table for a half adder (HA)</caption>
  <tr>
    <th>X</th>
	<th>Y</th>
	<th>S</th>
	<th>C</th>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
  </tr>
  <tr>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
  </tr>
  <tr>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
  </tr>
</table>

Recognizing that the S column is identical to the truth table for XOR, and that the C column is identical to the truth table for AND, we can design a very simple circuit for a half adder:

{{<img src="/images/half_adder_circuit.png" alt="The circuit for a half adder (HA)">}}

## Hardware Setup
Take out the Raspberry Pi and lay it on a flat surface.  Identify the 74xx chips required by examining the model numbers written on the top of the chip.  You will need a 7408 (4 AND gates) and 7486 (4 XOR gates) for this part.  Each of the two chips must be mounted across the gap in the middle of the breadboard, so that each side of pins has its own breadboard column for connecting wires.

Connect a red wire to a power supply of 5v on the GPIO header, and plug it into the red line at the top of the breadboard.  This will supply power to both chips.  Connect a black wire to one of the ground GPIO pins, and plug it into the blue line at the bottom of the breadboard.  For each of the two gate chips, plug another red wire from the red line to pin #14 (top left) on the chip, and another black wire from the blue line to pin #7 (bottom right) on the chip.  This will power the chips.

Now, connect the inputs for both the first XOR gate and the first AND gate to the GPIO pins #21 and #22.  Connect the output from the XOR gate to GPIO pin #23, and the output from the AND gate to GPIO pin #24.  The completed circuit wiring is shown below:

{{<img src="/images/HalfAdder_bb.png" alt="The hardware configuration for a half adder">}}

## Testing out your circuit
Connect the cables for the Raspberry Pi as usual, and boot to the Raspbian graphical environment.  Create a new Python file, called half_adder_test.py, containing the following code:

{{< highlight python >}}
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD)
GPIO.setup(16, GPIO.IN)  # s (sum),   GPIO #23
GPIO.setup(18, GPIO.IN)  # c (carry), GPIO #24
GPIO.setup(15, GPIO.OUT) # x,         GPIO #22
GPIO.setup(11, GPIO.OUT) # y,         GPIO #17

print "x y s c"
print "-------"
for x in [0,1]:
   for y in [0,1]:
      GPIO.output(15, x)
	  GPIO.output(11, y)
	  s = GPIO.input(16)
	  c = GPIO.input(18)
	  
	  print x, y, s, c

GPIO.cleanup()
{{< /highlight >}}

The program's output should match the above truth table.

# Full Adders
A full adder is a circuit that adds two binary digits, plus a carry in, producing a sum and a carry out bit.  The carry bit is one (high) when the three bits add up to more than can be stored in a single digit.  This happens when two or more of the input bits is one (high).

## Circuit Design
The same process used for the half adder can be used to design the circuit for a full adder, starting with the truth table (which is filled out by hand, based on what we know about the behaviour of the circuit):

<table class="wikitable">
  <caption>Truth table for a full adder (FA)</caption>
  <tr>
    <th>X</th>
	<th>Y</th>
	<th>C(in)</th>
	<th>S</th>
	<th>C(out)</th>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
  </tr>
  <tr>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
  </tr>
  <tr>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
  </tr>
  <tr>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
  </tr>
  <tr>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
  </tr>
</table>

Using a Karnaugh map, and knowledge of XOR, we can get simplified Boolean algebraic expressions for each of the two output variables:

<pre>
   S = X XOR Y XOR C(in)
</pre>

<pre>
   C(out) = ((X XOR Y) AND C(in)) OR (X AND Y)
</pre>

The circuit corresponding to these Boolean algebraic expressions is shown below:

{{<img src="/images/full_adder_circuit.png" alt="The circuit for a full adder">}}

## Hardware Setup
Disconnect all of the gate inputs and outputs from the half adder.  We'll need to add a 7432 chip for the single OR gate that is shown in the circuit diagram.  Connect power and ground to this chip accordingly.  Connect the gate inputs and outputs according to the following table:

<table class="wikitable">
  <caption>Gate Inputs for a Full Adder</caption>
  <tr>
    <th>Gate</th>
	<th>Input 1</th>
	<th>Input 2</th>
	<th>Output</th>
  </tr>
  <tr>
    <td>XOR 1</td>
    <td>x (pin #15, GPIO #22)</td>
    <td>y (pin #11, GPIO #17)</td>
    <td>XOR 2 input 1</td>
  </tr>
  <tr>
    <td>XOR 2</td>
    <td>c(in) (pin #7, GPIO #4)</td>
    <td>XOR 1 output</td>
    <td>s (pin #16, GPIO #23)</td>
  </tr>
  <tr>
    <td>AND 1</td>
    <td>c(in) (pin #7, GPIO #4)</td>
    <td>XOR 1 output</td>
    <td>OR input 1</td>
  </tr>
  <tr>
    <td>AND 2</td>
    <td>x (pin #15, GPIO #22)</td>
    <td>y (pin #11, GPIO #17)</td>
    <td>OR input 2</td>
  </tr>
  <tr>
    <td>OR</td>
    <td>AND 1 output</td>
    <td>AND 2 output</td>
    <td>c(out) (pin #18, GPIO #24)</td>
  </tr>
</table>

The resulting circuit should look something like the following illustration:

{{<img src="/images/FullAdder_bb.png" alt="The hardware configuration for a full adder">}}

## Exercise
Write some code in Python to test your full adder circuit will all possible inputs.  Use the half_adder_test.py as a starting point.
