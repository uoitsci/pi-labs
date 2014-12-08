+++
draft = false
title = "Binary number representation"
Weight = 3
+++

In this lab we are going to learn about binary numbers and its representation.

# Binary numbers

The binary numeral system is a way to write numbers using only two digits: 0 and 1. These are used in computers as a series of "off" and "on" switches. In binary, each digit's place value is twice as much as that of the next digit to the right (since each digit holds two values). In decimal - the system that humans normally use - each digit holds ten values, and the place value increases by a power of ten (ones, tens, hundreds place, etc.). The place value of the rightmost digit in either case is 1.

Example: 10110011

* The place value of the last 1 (rightmost position) is 2<sup>0</sup>=1.
* The place value of the 1 before that is 2<sup>1</sup>=2.
* The place value of the 0 before that is 2<sup>2</sup>=4.
* The place value of the 0 before that is 2<sup>3</sup>=8.
* The place value of the 1 before that is 2<sup>4</sup>=16.
* The place value of the 1 before that is 2<sup>5</sup>=32.
* The place value of the 0 before that is 2<sup>6</sup>=64.
* The place value of the 1 before that is 2<sup>7</sup>=128.

Adding together all the place values that have 1s, it would be 1+2+16+32+128 = 179. For convenience, binary digits (bits, for short) are usually grouped together in 8 bits, or a byte.

To convert from a decimal integer numeral to its binary equivalent, the number is divided by two, and the remainder is the least-significant bit. The (integer) result is again divided by two, its remainder is the next least significant bit. This process repeats until the quotient becomes zero.

Example: 118

* 118 divided by 2 is equal to 59 with remainder 0, so the rightmost position is a 0.
* 59 divided by 2 is equal to 29 with remainder 1, so the value before that is a 1.
* 29 divided by 2 is equal to 14 with remainder 1, so the value before that is a 1.
* 17 divided by 2 is equal to 7 with remainder 0, so the value before that is a 0.
* 7 divided by 2 is equal to 3 with remainder 1, so the value before that is a 1.
* 3 divided by 2 is equal to 1 with remainder 1, so the value before that is a 1.
* 1 divided by 2 is equal to 0 with remainder 1, so the value before that is a 1.

The binary representation of the number 118 is 1110110.

## Bitwise operations

Bitwise operations are those that operates on binary numbers at the level of their individual bits. 

In the explanations below, any indication of a bit's position is counted from the right (least significant) side, advancing left. For example, the binary value 0001 (decimal 1) has zeroes at every position but the first one.

## Operator NOT
The bitwise `NOT` also called *complement* is an unary operation (only operates on one binary number). This operation perform a *logical negation* on each bit: bits that are 0 becomes 1, and those that are 1 becomes 0. For example: 

<pre>
NOT 0111 
  = 1000
</pre>


## Operator AND
The bitwise `AND` takes two binary representation of equal lenght and performs the *logical AND* on each pair of corresponding bits. The result in each position is one if both bits are 1, otherwise the result is 0. For example:

<pre>
    0101
AND 0011
  = 0001
</pre>

## Operator OR
The bitwise `OR` takes two bit patterns of equal length and performs the *logical inclusive OR* operation on each pair of corresponding bits. The result in each position is 1 if at least one of the bits is 1, otherwise the result is 0. For example:

<pre>
    0101
 OR 0011
  = 0111
</pre>

## Operator XOR
The bitwise `XOR` takes two bit patterns of equal length and performs the *logical exclusive OR* operation on each pair of corresponding bits. The result in each position if 1 if only one of the bits is one, otherwise the result is 0. For example:

<pre>
    0101
XOR 0011
  = 0110
</pre>

The `XOR` operator can be seen as a comparison of two bits patterns, given the result in each position 1 if both bits differs and 0 if they are the same.

## Bitwise operations in python
In python the bitwise operators has the following symbols:

* NOT: ~
* AND: &
*  OR: |
* XOR: ^

# Bit shift
The *bit shifts* are sometimes considered bitwise operations, because they treat a value as a series of bits rather than as a numerical quantity. In these operations the digits are moved, or shifted, to the left or right. Examples:

<pre>
SHIFT-LEFT 0101 
         = 1010
</pre>

{{%img src="/images/shift-left.png"%}}

<pre>
SHIFT-RIGHT 0101
          = 0010
</pre>

{{%img src="/images/shift-right.png"%}}

## Bit shift in python 
In python the left and right shift operators are `<<` and `>>`, respectively. The number of places to shift is given as the second argument to the shift operators. For example:

{{< highlight python >}}
y = x >> 2
{{< /highlight >}}

Now `y` contains the value of `x` shifted two positions to the right.

## Testing for bits in python
To test for different bits in python you can use the combination of the shift operator and the and operator. If you want to test if the bit in the i-th position (from right to left counting form 0) you can do:

{{< highlight python >}}
(x >> i) & 1
{{< /highlight >}}

The result of the above operation will be 1 if the bit in the i-th position has value 1, zero otherwise.

# Representing binary numbers with LED on the Raspberry Pi
We are going to do a fun exercise. Lets create a circuit with 3 LEDs representing each one a bit in a binary number of size 3, and increment that number every second. The circuit would be the following:

{{%img src="/images/binary.png"%}}

Notice that we are using GPIO pins 8, 10 and 12 as output pins for the LEDs. The following program will show the different binary numbers from 0 to 7 displayed using the LEDs:

{{< highlight python >}}
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)

GPIO.setup(8, GPIO.OUT)
GPIO.setup(10, GPIO.OUT)
GPIO.setup(12, GPIO.OUT)

c = 0

try:
        while True:
		c = (c + 1) % 8

		GPIO.output(8, (c >> 0) & 1)
		GPIO.output(10, (c >> 1) & 1)
		GPIO.output(12, (c >> 2) & 1)

		time.sleep(1)
except KeyboardInterrupt:
        GPIO.cleanup()
{{< /highlight >}}

## Exercise
Add a button to the circuit and extend the above program to increase the binary number when the button is pressed.
