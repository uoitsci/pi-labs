+++
draft = false
title = "Controlling a seven-segment display from the Raspberry Pi - Part 2"
Weight = 9
+++


## Custom characters

You can create your own character output on a per-segment basis.  Each character is simply an 8-bit binary number, or two hexadecimal digits.  The table below describes the hexadecimal and binary codes for each segment:

<table class="wikitable">
    <caption>Segment Codes</caption>
    <tr>
        <th>Segment</th>
        <th>Hexadecimal</th>
        <th>Binary</th>
    </tr>
    <tr>
        <td>{{%img src="/images/segment_top.png"%}}</td>
        <td>0x01</td>
        <td>00000001</td>
    </tr>
    <tr>
        <td>{{%img src="/images/segment_top_right.png"%}}</td>
        <td>0x02</td>
        <td>00000010</td>
    </tr>
    <tr>
        <td>{{%img src="/images/segment_bottom_right.png"%}}</td>
        <td>0x04</td>
        <td>00000100</td>
    </tr>
    <tr>
        <td>{{%img src="/images/segment_bottom.png"%}}</td>
        <td>0x08</td>
        <td>00001000</td>
    </tr>
    <tr>
        <td>{{%img src="/images/segment_bottom_left.png"%}}</td>
        <td>0x10</td>
        <td>00010000</td>
    </tr>
    <tr>
        <td>{{%img src="/images/segment_top_left.png"%}}</td>
        <td>0x20</td>
        <td>00100000</td>
    </tr>
    <tr>
        <td>{{%img src="/images/segment_centre.png"%}}</td>
        <td>0x40</td>
        <td>01000000</td>
    </tr>
    <tr>
        <td>Decimal point</td>
        <td>0x80</td>
        <td>10000000</td>
    </tr>
</table>

For example, to generate a capital H:

<table class="wikitable">
    <caption>Calculating codes for a capital H</caption>
    <tr>
        <th>Character</th>
        <th>Hexadecimal</th>
        <th>Binary</th>
    </tr>
    <tr>
        <td>{{%img src="/images/letter_h.png"%}}</td>
        <td>
            0x10 (bottom left)<br />
            0x20 (top left)<br />
            0x40 (centre)<br />
            0x02 (top right)<br />
            0x04 (bottom right)<br />
            ----<br />
            0x76
        </td>
        <td>
            0001 0000 (bottom left)<br />
            0010 0000 (top left)<br />
            0100 0000 (centre)<br />
            0000 0010 (top right)<br />
            0000 0100 (bottom right)<br />
            ---------<br />
            0111 0110
        </td>
    </tr>
</table>

## Circuit

Let's connect the seven segment display along with a momentary button, as in the following diagram:

{{%img src="/images/7Segment_SpeedTest.png"%}}

Note: In this example, the circuit is designed to use the pull-up resistors in the Raspberry Pi's GPIO pins.  Be sure to configure the GPIO inputs accordingly in your Python program.

## Exercise #1

Write a program that uses the button to increment the count displayed on the seven segment display.  The counter will increase if the button is depressed, and remain the same otherwise.

## Exercise #2

Now, we are going to write a program inspired by the reaction tester at the Ontario Science Centre.  The tester is similar in appearance to the driver's seat of a vehicle.  The simulation starts when the user presses the accelerator pedal.  At a random time, a STOP indicator is shown. When the user sees the STOP indicator, they are supposed to hit the brake pedal.  The tester then shows you a comparative view of your reaction time.

Write a program that displays 'go' to simulate acceleration.  It will then delay for a random amount of time (between 2 seconds and 5 seconds in duration), before displaying 'stop'.  To generate a random number and sleep for that amount of time (in seconds):

{{< highlight python >}}
import time
import random

delay = random.randrange(2000, 5000) / 1000.0
time.sleep(delay)
{{< /highlight >}}

Once stop is displayed, record the time and start polling the button input (GPIO #17).  Then the button is pressed, record the time again.  Use the following code as a template:

{{< highlight python >}}
import datetime

startTime = datetime.datetime.now()

... do something ...

endTime = datetime.datetime.now()

elapsed = endTime - startTime
elapsedSeconds = elapsed.total_seconds()
{{< /highlight >}}

Display the user's reaction time using the seven segment display.

Note:  You will have to do your best to display 'go' and 'stop', as the seven segment display is intended for decimal digits.
