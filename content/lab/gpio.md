+++
draft = false
title = "RaspberryPi GPIO"
Weight = 2
+++

In this lab we are going to introduce the GPIO interface of the RaspberryPi.

# What is GPIO?
In one corner of the RaspberryPi is a 26 pin expansion header. The pins are numerated from 1 to 26, with the even numbers on the outside of the board as the picture shows:

{{<img src="/images/expansionHeader.png">}}

This table indentifies  each of the pins in the expansion header:

{{<img src="/images/pins.png">}}

There are different types of pins in the expansion header:

* The red pins: those pins are connected to the RaspberryPi 5 volts rail, meaning that they provide constant 5 volts.
* The orange pins: those pins are connected to the RaspberryPi 3.3 volts rail, meaning that they provide constant 3.3 volts.
* The black pins: those pins are connected to ground, meaning they provide constant 0 volts.

All the remaining pins are known as the **General-purpose input/output (GPIO)**. The GPIO is a generic pin on a circuit whose behavior, including whether it is an input or output, can be controlled by the user at run time. The GPIO pins are also connected to the 3.3 volts rails but what that makes them special is that they can be used to read voltages (input) or they can set to 3.3 volts or 0 volts (output).

There are also 4 types of GPIO ports in the RaspberryPi expansion header. The green pins are generic GPIO pins. The blue, yellow and gray are also GPIO pins, but by default they have been assing for special functions, but they can be reconfigured if needed. 

In total there are 17 GPIO ports. Although any GPIO pins can be used, is your desing requires less than 8 pins, we recomend to use only the 8 colored in green in the above table.

# Using the GPIO from python

To use the GPIO interface from python the first step is to import the RaspberryPi GPIO module:

{{< highlight python >}}
import RPi.GPIO as GPIO
{{< /highlight >}}

Then it is necesary to initialize the GPIO interface:

{{< highlight python >}}
GPIO.setmode(GPIO.BOARD)
{{< /highlight >}}

An now everything is ready to start using the GPIO port. You will need to define the input and ouput pins and do your logic behind them. To finalize it is a good practice to do:

{{< highlight python >}}
GPIO.cleanup()
{{< /highlight >}}

That clean all setting we have define. If you forget to do the cleanup and one output pin is active (set to 1) it will continue providing 3.3 volts until deactivated (set to 0) or a cleanup is done.

# Define and manage input pins

To define a GPIO pin as output from python, you need to set:

{{< highlight python >}}
GPIO.setup(12, GPIO.OUT)
{{< /highlight >}}

Now the pin is ready to provide output. You can set it to provide 3.3 volts (on) doing:

{{< highlight python >}}
GPIO.output(12, 1)
{{< /highlight >}}

Or set is to provide 0 volts (off) doing:

{{< highlight python >}}
GPIO.output(12, 0)
{{< /highlight >}}

### Simple circuit using the RaspberryPi GPIO ports: control a LED. 

A **light-emitting diode** (LED) is a two-lead semiconductor light source. It resembles a basic pn-junction diode, which emits light when activated.

{{<img src="/images/led.png">}}

Because LEDs are diodes, they only left current pass in one way, so you must ensure to connect the anode to the power source and the cathode to the ground, otherwise current would not pass through and thus it would not emit light. Monochrome LEDs has two legs being generally the longest the anode and the shortest the cathode. You can also identify the cathode has a flat top side inside the lens in round LEDs.

To control a LED from the RaspberryPi, we are going to connect it to a GPIO port, for instance the number 12 as the following picture shows:

{{<img src="/images/ledCircuit.png">}}

As the output voltage of the GPIO pins is 3.3 volts, and the LED uses only 2 volts, we need to add a resistor. The specification of this LED says it consume 5ma, so to calculate the appropiate resistor we need to use the Ohmns law as follows:

{{<img src="/images/ohmnLed.png">}}

As the formula indicates, we need a resistor of at least 325 ohms, so a 330 ohms is OK.

Now that we are ready, lets control the LED from the RaspberryPI. The following program turns the LED on for 3 seconds:

{{< highlight python >}}
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)

GPIO.setup(12, GPIO.OUT)

GPIO.output(12, 1)

time.sleep(3)

GPIO.cleanup()
{{< /highlight >}}


## Define and manage output pins

In a similar way that we defined a GPIO output pin we can define a GPIO input pin:

{{< highlight python >}}
GPIO.setup(11, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
{{< /highlight >}}

Notice the extra argument *pull_up_down* provided to the setup function. The values of this argument will be explained later.

To read from that pin that we have defined as input we need to do:

{{< highlight python >}}
GPIO.input(11)
{{< /highlight >}}

That function will return 1 or 0 depending if the input is considered active or not. When input is considered active is defined in the *pull_up_down* argument to the setup function. It has two possible values:

* `GPIO.PUD_DOWN`: The input is considered on when that pin is reading 3.3 volts, off if reading less than that.
* `GPIO.PUD_UP`: The input is considered on when the pins is reading less that 3.3 volts, on if reading 3.3 volts.

Both values are opposite behaviors and the usage depends on the needs. 

### Simple button input with the RaspberryPi.

When we controled the LED from the RaspberryPi, we demostrated the usage of a GPIO pin as output. To show the usage of a GPIO pin as input, we are going to extend the above program to make the led blink on the push of a button. In this case we want the light the LED when the button is pushed. For that we are going to connect the button to the GPIO pin 11 and to the 3.3 V pin 17 as follow:

{{<img src="/images/button.png">}}

and we are going to setup the *pull_up_down* argument of that ping to `GPIO.PUD_DOWN`. When the button is pushed, it closes the circuit and there will be 3.3 volts at pin 11, and the function `GPIO.input(11)` will return 1.

The following python program turns the LED on push of the button:

{{< highlight python >}}
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD)

GPIO.setup(12, GPIO.OUT)
GPIO.setup(11, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.output(12, 0)

try:
	while True:
		GPIO.output(12, GPIO.input(11))
except KeyboardInterrupt:
	GPIO.cleanup()
{{< /highlight >}}

## Exercise
Extend the first program to make the LED blink constantly.
