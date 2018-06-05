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
        <td>5.0V</td>
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

Adafruit, who makes the 7-segment display, has created a Python library for our display, which provides the `SevenSegment` class.  The library is preinstalled on the Pi, but you'll need to download the example code from GitHub.

{{< highlight bash >}}
git clone https://github.com/adafruit/Adafruit_Python_LED_Backpack
cd Adafruit_Python_LED_Backpack
{{< /highlight >}}

## Connections

First we are going to connect the four-digit seven-segment display to the GPIO pins as follows:

{{%img src="/images/7Segment_Output.png"%}}

## Testing connections

Let's run the provided test program, which shows the current time on the 7 segment display, to be sure it is working properly.

{{< highlight bash >}}
sudo python examples/ex_7segment_clock.py
cd examples
sudo python ex_7segment_clock.py
{{< /highlight >}}

To verify that the address of our seven segment display is 0x70, try the following command in the terminal:

{{< highlight bash >}}
sudo i2cdetect -y 1
{{< /highlight >}}

## Test program

Once connected as in the above diagram, you can test if everything was properly connected using the following program. This program displays 'AbCd':

{{< highlight python >}}
from Adafruit_LED_Backpack.SevenSegment import SevenSegment

segment = SevenSegment()

segment.set_digit(0, 'A')
segment.set_digit(1, 'B')
segment.set_digit(2, 'C')
segment.set_digit(3, 'D')

# The display won't update without this line
segment.write_display()
{{< /highlight >}}

You can turn the colon (:) on or off:

{{< highlight python >}}
from Adafruit_LED_Backpack.SevenSegment import SevenSegment

segment = SevenSegment()

segment.set_colon(True)
segment.set_colon(False)

segment.write_display()
{{< /highlight >}}

## Exercise

Write a program that does the following:

* Write a function 'writeDec' which outputs a decimal value [0,9999]
* Count from 0000 to 1000, in decimal, with no delay
* Write a function 'writeHex' which outputs a hexadecimal value [0,FFFF]
* Count from 0000 to 1000, in hexadecimal, with no delay

Hint:  You can use // and % to extract a single digit from a number.  The following code demonstrates how to retrieve the $i$-th number (counted from 0, starting on the right) of the number in num:

{{< highlight python >}}
def get_digit(i, num):
    return (num / 10**i) % 10

num = 12345
for i in range(0, 5):
    print("get_digit(", i, ", 12345) =", get_digit(i, num))
{{< /highlight >}}
