+++
draft = false
title = "Controlling a seven-segment display from the Raspberry Pi - Part 1"
Weight = 8
+++

A *seven-segment display* (SSD), is a form of electronic display device for displaying decimal numerals. They are widely used in digital clocks, electronic meters, and other electronic devices for displaying numerical information.

The seven elements of the display can be lit in different combinations to represent the Arabic numerals. The seven segments are arranged as a rectangle of two vertical segments on each side with one horizontal segment on the top, middle, and bottom. Additionally, the seventh segment bisects the rectangle horizontally. The segments of a 7-segment display are referred to by the letters A to G, where the optional DP decimal point (an *eighth segment*) is used for the display of non-integer numbers.

{{%img src="/images/7_segment_display.png"%}}

There are 128 different ouput that can be generated with a 7-segment display:

{{%img src="/images/7-segment_combinations.png"%}}

## The I<sup>2</sup>C bus

The HT16K33 7-segment display uses the I<sup>2</sup>C bus.  An I<sup>2</sup>C bus can support up to 256 different devices (e.g. sensors, motors, outputs) at the same time.  Each component has a unique hexadecimal address.  The HT16K33 generally uses a 0x70 address, but we'll verify that later.  The I<sup>2</sup>C bus uses only two GPIO pins:

<table class="wikitable">
    <caption>The I<sup>2</sup>C bus lines</caption>
    <tr>
        <th>Line</th>
        <th>Purpose</th>
    </tr>
    <tr>
        <td>SDA</td>
        <td>Data</td>
    </tr>
    <tr>
        <td>SCL</td>
        <td>Clock</td>
    </tr>
</table>

## Digits

All the 10 decimal digits (and all 16 hexadecimal digits) can be represented in a 7-segment display:

<table class="wikitable">
    <caption>Displaying the hexadecimal digits 0 to F</caption>
    <tr>
        <th>Digit</th>
        <th>Input</th>
    </tr>
    <tr>
        <td>0</td>
        <td>0x3F</td>
    </tr>
    <tr>
        <td>1</td>
        <td>0x06</td>
    </tr>
    <tr>
        <td>2</td>
        <td>0x5B</td>
    </tr>
    <tr>
        <td>3</td>
        <td>0x4F</td>
    </tr>
    <tr>
        <td>4</td>
        <td>0x66</td>
    </tr>
    <tr>
        <td>5</td>
        <td>0x6D</td>
    </tr>
    <tr>
        <td>6</td>
        <td>0x7D</td>
    </tr>
    <tr>
        <td>7</td>
        <td>0x07</td>
    </tr>
    <tr>
        <td>8</td>
        <td>0x7F</td>
    </tr>
    <tr>
        <td>9</td>
        <td>0x6F</td>
    </tr>
    <tr>
        <td>A</td>
        <td>0x77</td>
    </tr>
    <tr>
        <td>B</td>
        <td>0x7C</td>
    </tr>
    <tr>
        <td>C</td>
        <td>0x39</td>
    </tr>
    <tr>
        <td>D</td>
        <td>0x5E</td>
    </tr>
    <tr>
        <td>E</td>
        <td>0x79</td>
    </tr>
    <tr>
        <td>F</td>
        <td>0x71</td>
    </tr>
</table>

# Controlling the 4-digit 7-segment display

The four-digit seven-segment display that we are going to use has 4 pins (+, -, D, C).  The table below describes each pin, as well as how it should be connected to the Raspberry Pi:

{{%img src="/images/4x7LED.png"%}}

<table class="wikitable">
    <caption>The I<sup>2</sup>C bus lines</caption>
    <tr>
        <th>7-segment Pin</th>
        <th>Purpose</th>
        <th>GPIO Pin</th>
    </tr>
    <tr>
        <td>+</td>
        <td>Power</td>
        <td>5.0v</td>
    </tr>
    <tr>
        <td>-</td>
        <td>Ground</td>
        <td>GND</td>
    </tr>
    <tr>
        <td>D</td>
        <td>SDA (Data for I<sup>2</sup>C)</td>
        <td>SDA</td>
    </tr>
    <tr>
        <td>C</td>
        <td>SCL (Clock for I<sup>2</sup>C)</td>
        <td>SCL</td>
    </tr>
</table>

## Download the support code

AdaFruit, who makes the 7 segment display, has created a Python class for our display, called SevenSegment.  To get this code, along with some test code, download the following package from their GitHub repository:

{{< highlight bash >}}
git clone https://github.com/adafruit/AdaFruit-Raspberry-Pi-Python-Code
cd AdaFruit-Raspberry-Pi-Python-Code/Adafruit_LEDBackpack
{{< /highlight >}}

## Connections

First we are going to connect the four-digit seven-segment display to the GPIO pins as follows:

{{%img src="/images/7Segment_Output.png"%}}

## Testing connections

Let's run the provided test program, which shows the current time on the 7 segment display, to be sure it is working properly.

{{< highlight bash >}}
sudo python ex_7segment_clock.py
{{< /highlight >}}

To verify that the address of our seven segment display is 0x70, try the following command in the terminal:

{{< highlight bash >}}
sudo i2cdetect -y 1
{{< /highlight >}}

## Test program

Once connected as in the above diagram, you can test if everything was properly connected using the following program. This program displays 'AbCd':

{{< highlight python >}}
segment = SevenSegment(address=0x70)

segment.writeDigit(0, 10)
segment.writeDigit(1, 11)
segment.writeDigit(3, 12)
segment.writeDigit(4, 13)
{{< /highlight >}}

Note:  The digit '2' is the colon in our display.  You can turn it on or off:

{{< highlight python >}}
segment = SevenSegment(address=0x70)

segment.setColon(True)
segment.setColon(False)
{{< /highlight >}}

## Exercise

Now, we are going to write a Python program to test our seven segment display.  For simplicity, put your code into <span style="font-family: monospace">AdaFruit-Raspberry-Pi-Python-Code/Adafruit_LEDBackpack</span>.  Write a program that does the following:

<ol>
    <li>Write a function 'writeDec' which outputs a decimal value [0,9999]</li>
    <li>Count from 0000 to 1000, in decimal, with no delay</li>
    <li>Write a function 'writeHex' which outputs a hexadecimal value [0,FFFF]</li>
    <li>Count from 0000 to 1000, in hexadecimal, with no delay</li>
</ol>

Hint:  You can use // and % to extract a single digit from a number.  The following code demonstrates how to retrieve the ith number (counted from 0, starting on the right) of the number in num:

{{< highlight python >}}
def get_digit(i, num):
    return (num / 10**i) % 10

num = 12345
for i in range(0, 5):
    print "get_digit(", i, ", 12345) =", get_digit(i, num)
{{< /highlight >}}

