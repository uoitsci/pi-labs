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

{{<img src="/images/7400_pinout.png" alt="Pinout of the 7400 chip">}}

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

{{<img src="/images/half_adder.png" alt="Circuit diagram for a half adder" />}}

## Hardware Setup
Take out the Raspberry Pi and lay it on a flat surface.  Identify the 74xx chips required by examining the model numbers written on the top of the chip.  You will need a 7408 (4 AND gates) and 7486 (4 XOR gates) for this part.  Each of the two chips must be mounted across the gap in the middle of the breadboard, so that each side of pins has its own breadboard column for connecting wires.

Connect a red wire to a power supply of 5v on the GPIO header, and plug it into the red line at the top of the breadboard.  This will supply power to both chips.  Connect a black wire to one of the ground GPIO pins, and plug it into the blue line at the bottom of the breadboard.  For each of the two gate chips, plug another red wire from the red line to pin #14 (top left) on the chip, and another black wire from the blue line to pin #7 (bottom right) on the chip.  This will power the chips.

Now, connect the inputs for both the first XOR gate and the first AND gate to the GPIO pins #21 and #22.  Connect the output from the XOR gate to GPIO pin #23, and the output from the AND gate to GPIO pin #24.  The completed circuit wiring is shown below:

{{<img src="/images/HalfAdder_bb.png" alt="The hardware configuration for a half adder" />}}

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
