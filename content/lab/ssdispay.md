+++
draft = false
title = "Controlling a seven-segment display from the RaspberryPi"
Weight = 7
+++

A *seven-segment display* (SSD), is a form of electronic display device for displaying decimal numerals. They are widely used in digital clocks, electronic meters, and other electronic devices for displaying numerical information.

The seven elements of the display can be lit in different combinations to represent the arabic numerals. The seven segments are arranged as a rectangle of two vertical segments on each side with one horizontal segment on the top, middle, and bottom. Additionally, the seventh segment bisects the rectangle horizontally. The segments of a 7-segment display are referred to by the letters A to G, where the optional DP decimal point (an *eighth segment*) is used for the display of non-integer numbers.

{{%img src="/images/7_segment_display.png"%}}

There are 128 different ouput that can be generated with a 7-segment display:

{{%img src="/images/7-segment_combinations.png"%}}

All the 10 digits can be represented in a 7-segment display:

<table class="wikitable">
<caption>Displaying the digits 0 to 9</caption>
<tr><th>Digit</th><th>   a     </th><th>   b     </th><th>   c     </th><th>   d     </th><th>   e     </th><th>   f     </th><th>   g     </th></tr>
<tr><td>  0  </td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td>  off    </td></tr>
<tr><td>  1  </td><td>  off    </td><td><b>on</b></td><td><b>on</b></td><td>  off    </td><td>  off    </td><td>  off    </td><td>  off    </td></tr>
<tr><td>  2  </td><td><b>on</b></td><td><b>on</b></td><td>  off    </td><td><b>on</b></td><td><b>on</b></td><td>  off    </td><td><b>on</b></td></tr>
<tr><td>  3  </td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td>  off    </td><td>  off    </td><td><b>on</b></td></tr>
<tr><td>  4  </td><td>  off    </td><td><b>on</b></td><td><b>on</b></td><td>  off     </td><td> off    </td><td><b>on</b></td><td><b>on</b></td></tr>
<tr><td>  5  </td><td><b>on</b></td><td>  off    </td><td><b>on</b></td><td><b>on</b></td><td>  off    </td><td><b>on</b></td><td><b>on</b></td></tr>
<tr><td>  6  </td><td><b>on</b></td><td>  off    </td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td></tr>
<tr><td>  7  </td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td>  off    </td><td>  off    </td><td>  off    </td><td>  off</td></tr>
<tr><td>  8  </td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td></tr>
<tr><td>  9  </td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td><b>on</b></td><td>  off    </td><td><b>on</b></td><td><b>on</b></td></tr>
</table>

Seven-segment displays may use a liquid crystal display (LCD), a light-emitting diode (LED) for each segment, or other light-generating or controlling techniques. In a simple LED package, typically all of the cathodes (negative terminals) or all of the anodes (positive terminals) of the segment LEDs are connected and brought out to a common pin; this is referred to as a *common cathode* or *common anode* device. Hence a 7 segment plus decimal point package will only require nine pins.

Multiple-digit LED displays as used in pocket calculators and similar devices used multiplexed displays to reduce the number of I/O pins required to control the display. For example, all the anodes of the A segments of each digit position would be connected together and to a driver circuit pin, while the cathodes of all segments for each digit would be connected. To operate any particular segment of any digit, the controlling integrated circuit would turn on the cathode driver for the selected digit, and the anode drivers for the desired segments; then after a short blanking interval the next digit would be selected and new segments lit, in a sequential fashion. In this manner an four digit display with seven segments and a decimal point would require only 8 cathode drivers and 4 anode drivers, instead of 32 pins.

# Controling the four-digit seven-segment display

The four-digit seven-segment display that we are going to use has 14 pins numerates as the picture shows:

{{%img src="/images/4x7LED.png"%}}

The pins 14, 11, 10 and 6 are the common cathode of the digits from left to right. The rest of the pins correspond to the segments as follows: 13-a, 9-b, 4-c, 2-d, 1-e, 12-f, 5-g, the pin 3 correspond to the decimal point (DP) and the pins 7 and 8 corresponds to the two central dots .

If you want to turn on the segment a on the left-most digit you will need to conect the pin 13 to a power source and pin 14 to ground. If you connect the common cathode of all digits to ground, it will turn on the same segment on all digits.

# Controling the four-digit seven-segment display form the RaspberryPi

Because the output voltage of GPIO pins is 3.3 volts and each segment operates with 2.2 volts it is necesary to insert a 330 ohm resistor in the connection between the GPIO port and the pin corresponding to a segment. For pins representing each digit, if we want to activate that digit, we set the output of that GPIO port to 0 (ground) and to deactivated, we set the output of the GPIO port to one. Our example generates random numbers in python each time the button is pressed and displayed on the 4-digit 7-segment display.

First we are going to connect the four-digit seven-segment display to the GPIO pins as follows:

{{%img src="/images/4x7LED_Circuit.png"%}}

Once conected as in the above diagram, you can test if everything was properly conected using the followig program. This progam turn on all segments in all digits:

{{%highlight python%}}
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)

segments = {'a': 26, 'b': 22, 'c': 15, 'd': 11, 
            'e':  7, 'f': 24, 'g': 13}

for segment in segments:
	GPIO.setup(segment, GPIO.OUT)
	GPIO.output(segment, 1) # We put segments output in one

digits = [19, 21, 23, 18]

for digit in digits:
	GPIO.setup(digit, GPIO.OUT)
	GPIO.output(digit, 0)   # We put digit output in zero

try:
    while True:
	pass
except KeyboardInterrupt:
        GPIO.cleanup()
{{%/highlight%}}

If after running the above program not all segments in all digits are on, you should recheck your wiring.

Now that we know that the wiring is correct, we can display some numbers (between 0 and 9) in the 7 segment display. In this case, we are going to display the same number in all digit. The python program is the following:

{{%highlight python%}}
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)

segments = {'a': 26, 'b': 22, 'c': 15, 'd': 11, 
            'e':  7, 'f': 24, 'g': 13}

for segment in segments:
	GPIO.setup(segment, GPIO.OUT)
	GPIO.output(segment, 0) # We put segments output in zero

digits = [19, 21, 23, 18]

for digit in digits:
	GPIO.setup(digit, GPIO.OUT)
	GPIO.output(digit, 0)  # We put digit output in zero

num = {' ':[],
       '0':['a', 'b', 'c', 'd', 'e', 'f'],
       '1':['b', 'c', 'd'],
       '2':['a', 'b', 'd', 'e', 'g'],
       '3':['a', 'b', 'c', 'd', 'e', 'g'],
       '4':['b', 'c', 'f', 'g'],
       '5':['a', 'c', 'd', 'f', 'g'],
       '6':['a', 'c', 'd', 'e', 'f', 'g'],
       '7':['a', 'b', 'c'],
       '8':['a', 'b', 'c', 'd', 'e', 'f', 'g'],
       '9':['a', 'b', 'c', 'd', 'f', 'g']}

n = 0

try:
    while True:
	s = str(n)

	digitSegments = num[s]:
	for segment in digitSegments:
		GPIO.output(segments[segment], 1) # Turn on segment

	time.sleep(1) # Wait 1 second
	for segment in digitSegments:
		GPIO.output(segments[segment], 1) # Turn off segments

	n = (n + 1) % 10 # Increase the number
except KeyboardInterrupt:
        GPIO.cleanup()
{{%/highlight%}}

Note that in the above program we initialize the segments output to zero insted of one as in the previous. 

Now we are ready to display larger numbers with different values for each one of the four digits. For that we are going to proced as follow: we are going to display the values of each digit one at a time but changing from one to the other very fast, so the human will see as if all four are on at the same time. The following program displays the number 1234 in the seven segment display:

{{%highlight python%}}
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)

segments = {'a': 26, 'b': 22, 'c': 15, 'd': 11, 
            'e':  7, 'f': 24, 'g': 13}

for segment in segments:
	GPIO.setup(segment, GPIO.OUT)
	GPIO.output(segment, 0) # We put segments output in zero

digits = [19, 21, 23, 18]

for digit in digits:
	GPIO.setup(digit, GPIO.OUT)
	GPIO.output(digit, 1)  # We put digit output in zero

num = {' ':[],
       '0':['a', 'b', 'c', 'd', 'e', 'f'],
       '1':['b', 'c', 'd'],
       '2':['a', 'b', 'd', 'e', 'g'],
       '3':['a', 'b', 'c', 'd', 'e', 'g'],
       '4':['b', 'c', 'f', 'g'],
       '5':['a', 'c', 'd', 'f', 'g'],
       '6':['a', 'c', 'd', 'e', 'f', 'g'],
       '7':['a', 'b', 'c'],
       '8':['a', 'b', 'c', 'd', 'e', 'f', 'g'],
       '9':['a', 'b', 'c', 'd', 'f', 'g']}

n = 1234

try:
    while True:
	s = str(n).rjust(4)
		
	for digit in range(4):
		GPIO.output(digit, 0) # Turn on the digit

		digitSegments = num[s[digit]]:
		for segment in digitSegments:
			GPIO.output(segments[segment], 1) # Turn on segments

		GPIO.output(digit, 1) # Turn off the digit
		for segment in digitSegments:
			GPIO.output(segments[segment], 0) # Turn off segments
		
except KeyboardInterrupt:
	GPIO.cleanup()
{{%/highlight%}}

## Exercise
Add a button to the circuit and extend the above program to increase the number displayed every time the button is pressed. 
