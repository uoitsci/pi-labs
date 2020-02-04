+++
draft = false
title = "Analog to Digital Conversion"
Weight = 6
+++
The Raspberry Pi computer does not have a way to read analog inputs. It's a digital-only computer. Analog inputs are handy because many sensors are analog outputs, so we need a way to read that inputs. For that we are going to use an analog-to-digital converter, in our case the chip MCP3008.

An *analog-to-digital converter* (ADC, A/D, or A to D) is a device that converts a continuous physical quantity (usually voltage) to a digital number that represents the quantity's amplitude. Typically the digital output will be a two's complement binary number that is proportional to the input.

# The MCP3008 SPI ADC chip

The MCP3008 chip is an SPI-based analogue to digital converter (ADC). It has 8 analog input channels that can be configured, so it can handle up to 8 ADC conversions. The MCP3008 is a 10-bit ADC so its output will vary from 0 to 1023. The pinout of the MCP3008 is the following:

![MCP3008 SDI ADC Pinout](mcp3008pin.png "[Tony DiCola [CC BY 3.0]](https://learn.adafruit.com/assets/30456)")

Typically the VDD pin is connected to  3.3V power. The AGND and DGND pins can be connected directly to the ground reference point. The VREF pin is the reference voltage which is the largest possible voltage that the ADC can interpret. In our scenario we will connect the VREF pin to 3.3V (same as VDD). So if 3.3V was sampled on any of the ADC's channels it would be interpreted as the maximum digital value that can be represented by this 10-bit ADC i.e. $2^{10} – 1 = 1023$. Similarly the smallest analog voltage that the ADC can detect (also known as the 'LSB size') is VREF/1024. Which in our case is $\frac{3.3\text{V}}{1024}= 3.22\text{mV}$ and represents a digital value of 1. The equation that converts between the analog voltage and its digital interpretation is given by "Digital output code = 1024*VIN/VREF"; where VIN is the analog input voltage and VREF is the reference voltage.

# SPI
The Serial Peripheral Interface (SPI) is a communication bus that is used to interface one or more slave peripheral integrated circuits (ICs) to a single master SPI device; usually a microcontroller or microprocessor of some sort. Many SPI  Peripheral ICs exist. They include, analog to digital converters (ADC), digital to analog converters (DAC), general purpose input/output (GPIO) expansion ICs, temperature sensing ICs, accelerometers and many more. 

The 3 SPI wires shared by all devices on the SPI  bus are:

* Master in slave out (DIN). Data is moved from slave to master on this wire. 
* Master out slave in (DOUT). Data is moved from master to slave on this wire.

Serial clock (CLK). This clock is always generated by the master controller and is used to synchronize the transmission of data between devices on the bus.
In addition to these wires we have ‘n’ wires for ‘n’ slave devices on the bus. Each one of these wires carries the chip select signal (CS) for its respective device. Only one slave device can have its chip select signal asserted by the master controller at a time.

The operation of the SPI bus is conceptually simple. Both the master controller and each slave device contain a shift register. When the chip select signal of a slave device is asserted (usually by being pulled low), the DIN and DOUT wires are used to connect its shift register with that of the master device. Clock pulses are then generated (by the master device)  to shift data between the two shift registers enabling communication. In this sense the read and write operation are combined.

# ADC using SPI from a Raspberry Pi
In order to read analog data we need to use the following pins: VDD (power), DGND (digital ground) to power the MCP3008 chip. We also need four 'SPI' data pins: DOUT (Data Out from MCP3008), CLK (Clock pin), DIN (Data In from Raspberry Pi),  and /CS (Chip Select).  Finally of course, a source of analog data, we'll be using the basic 10k trim pot. A trimpot is a three-terminal resistor with a sliding or rotating contact that forms an adjustable voltage divider:

{{< figure caption="10k Ohm Trimpot" width="300px" >}}
![10k Ohm Trimpot](trimpot.jpg)
{{< /figure >}}

The MCP3008 has a few more pins we need to connect: AGND (analog ground, used sometimes in precision circuitry, which this is not) connects to GND, and VREF (analog voltage reference, used for changing the 'scale' - we want the full scale so tie it to 3.3V)

Below is a wiring diagram:

![ADC circuit](ADC.png)

The connections of the MCP3008 chip is the following:

MCP 3008 Pin | RPi Pin
-------------|---------
VDD  | 3.3V (red)
VREF | 3.3V (red)
AGND | GND (black)
CLK  | #11 (orange)
DOUT | #13 (yellow)
DIN  | #15 (blue)
CS   | #19 (purple)
DGND | GND (black)

Next connect up the potentiometer. Pin #1 (left) goes to GND (black), #2 (middle) connects to MCP3008 CH0 (analog input #0) with a pink wire, and #3 (right) connects to 3.3V (red).

The following python program read the value of the potentiometer and print it value to the screen:

{{< highlight python >}}

import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)

CLK  = 11
DOUT = 13
DIN  = 15
CS   = 19

GPIO.setup(CLK,  GPIO.OUT)
GPIO.setup(DOUT, GPIO.IN)
GPIO.setup(DIN,  GPIO.OUT)
GPIO.setup(CS,   GPIO.OUT)

potentiometer = 0

# read SPI data from MCP3008 chip, 8 possible adc's  
def readadc(num, clk, dout, din, cs):
    if ((num > 7) or (num < 0)):
        return -1

    GPIO.output(cs , 1) # Stopping any previous transitions
    GPIO.output(clk, 0) # start clock
    GPIO.output(cs , 0) # Selecting slave to start transition

    command = num 
    command |= 0x18     # Puting 2 ones at front of the number
    command <<= 3       # Moving the number to the first 5 digits

    for i in range(5):
        if (command & 0x80):
            GPIO.output(din, 1)
        else:
            GPIO.output(din, 0)

        command <<= 1
        GPIO.output(clk, 1) # clock pulse to shift
        GPIO.output(clk, 0)

    out = 0
    
    # read in one empty bit, 10 ADC bits and one 'null' bit at the end
    for i in range(12):
        GPIO.output(clk, 1) # clock pulse to shift
        GPIO.output(clk, 0)
        out <<=1
        out |= GPIO.input(dout)

    GPIO.output(cs , 1) # Deselecting slave to stop transmition
    out >>= 1 
    return out	 

try:
    while True:
        value = readadc(potentiometer, CLK, DOUT, DIN, CS)
        print("Reading {:4} of 1023 ".format(value))
        print("({:7.2%})".format(value/1023.0))
        time.sleep(1)
  except KeyboardInterrupt:
      GPIO.cleanup()
{{< /highlight >}}

## Exercise
Add another potentiometer to the circuit and extend the above program to print both values.