+++
draft = false
title = "Controling a Servomotor from the RaspberryPi"
Weight = 6
+++

A *Servomotor* is a small device that has an output shaft. This shaft can be positioned to specific angular positions by sending the servo a coded signal. As long as the coded signal exists on the input line, the servo will maintain the angular position of the shaft. As the coded signal changes, the angular position of the shaft changes.

{{%img src="/images/servoMotor.png"%}}

Servomotors, or in short servos, are extremely useful in practice, they can be used to operate remote-controlled or radio-controlled toy cars, robots and airplanes. Servos are also used in industrial applications, robotics, in-line manufacturing, pharmaceutics and food services.

# How is the servo controlled?
Servos are controlled by sending an electrical pulse of variable width, or pulse width modulation (PWM), through the control wire. There is a minimum pulse, a maximum pulse, and a repetition rate. A servo motor can usually only turn 90 degrees in either direction for a total of 180 degree movement. The motor's neutral position is defined as the position where the servo has the same amount of potential rotation in the both the clockwise or counter-clockwise direction. The PWM sent to the motor determines position of the shaft, and based on the duration of the pulse sent via the control wire; the rotor will turn to the desired position. The servo motor expects to see a pulse every 20 milliseconds (ms) and the length of the pulse will determine how far the motor turns. For example, a 1.5ms pulse will make the motor turn to the 90-degree position. Shorter than 1.5ms moves it to 0 degrees, and any longer than 1.5ms will turn the servo to 180 degrees, as diagramed below:
ghlight python%}}

{{%img src="/images/servoInput.png"%}}

When these servos are commanded to move, they will move to the position and hold that position. If an external force pushes against the servo while the servo is holding a position, the servo will resist from moving out of that position. The maximum amount of force the servo can exert is called the torque rating of the servo. Servos will not hold their position forever though; the position pulse must be repeated to instruct the servo to stay in position.

# Controling a servo from the RaspberryPi

To control del servo motor from the RaspberryPi we are going to use the PWM module in RPi.GPIO. The first step is to create the PWM instance asociated with the GPIO pin:

{{%highlight python%}}
p = GPIO.PWM(12, 50)
{{%/highlight%}}

In the above case we have intanciated the PWM module for the pin number 12 with a frequency of 50Hz. That frequency was selected because the servo motor expect a pulse avery 20ms (period), that means 50 pulses per second or Hertz. Once instantiated the PWM module, to start sending a pulse we do:

{{%highlight python%}}
p.start(dc)
{{%/highlight%}}

In this case dc is the *duty cicle*. The duty cycle describes the proportion of *on* time to the regular interval or *period* of time. If we want a pulse with an specific lenght we can calculate the duty cicle as follows: 

{{%img src="/images/dc.png"%}}

Since the servo uses 20ms cicles, we can calculate the dutycicle of the 3 turns of the servo motor:

{{%img src="/images/dc_servo.png"%}}

To change the duty cicle we can use:

{{%highlight python%}}
p.ChangeDutyCycle(dc)
{{%/highlight%}}

and to stop the pulse emition:

{{%highlight python%}}
p.stop()
{{%/highlight%}}

# Example of controling a servo from the RaspberryPi
The following diagram shows how to connect the servo to the RaspberryPi:

{{%img src="/images/circuit_servo.png"%}}

The following program will control the servo making it move to it's neutral position (90 degrees), wait 1 second and then move to it's 0 degrees, wait 1 second and finally move to it's 180 degrees. The cicle contiue until interrupted:

{{%highlight python%}}
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)

GPIO.setup(12, GPIO.OUT)

p = GPIO.PWM(12, 50)

p.start(7.5)

try:
        while True:
		p.ChangeDutyCycle(7.5)  # turn towards 90 degree
		time.sleep(1) # sleep 1 second
		p.ChangeDutyCycle(2.5)  # turn towards 0 degree
		time.sleep(1) # sleep 1 second
		p.ChangeDutyCycle(12.5) # turn towards 180 degree
                time.sleep(1) # sleep 1 second 
except KeyboardInterrupt:
	p.stop()
        GPIO.cleanup()
{{%/highlight%}}

## Exercise
Add two buttons to the circuit and extend the above program to control the servo in the following way: One button will make the servo turn to its 0 degrees, the other will make it trun to it's 180 degrees and both buttons at the same time will make the servo turn towards it neutral position (90 degrees).  
