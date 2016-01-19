+++
draft = false
title = "About Python"
Weight = 1
+++

In this lab we are going to introduce the Python programming language that we are going to use to program our Raspberry Pi projects.

# Raspberry Pi
The Raspberry Pi (RPi) is a credit card-sized computer that is relatively low cost, and has been used for a wide variety of projects.  Many people have used RPis to be their media centre, and nearly as many have developed game consoles, which run emulators of old gaming systems and arcade machines (e.g. Sega Genesis, Atari 2600, Nintendo 64).  There are many other projects. 

The RPi has its operating system on a MicroSD card, that is plugged into your device, called Raspbian.  Raspbian is a scaled down version of Debian Linux, built for the ARM architecture and including some useful packages.

Important note:  These RPis are shared, and you should not expect your work to still be there from a previous lab.  Also, it is not recommended that you leave your completed work on the Raspberry Pi.  You should delete all work after you've completed it.

# Python programming language
Python is a simple to learn yet powerful programming language that was conceived in the late 1980s and nowadays is a widely used programming language backed with a huge community. There are hundreds of modules that can be used for free for almost anything you might need to do. And YES, you can write and run python in the Raspberry Pi, and there are modules that allow us to interact with the GPIO ports, the camera, etc.

## Hardware Setup
To get started, obtain a Raspberry Pi kit.  The contents of the RPi kit include an RPi, a microUSB AC adapter, an Ethernet cable, a multimeter, and various wires and components.

The most important component is the RPi itself.  Remove it from its Mylar bag and set it down carefully on a flat surface.  Note that it has been mounted onto a plastic mounting board along with a breadboard.

We will use this breadboard in future labs, but not this time.  To start, we'll need power, keyboard, mouse, and display connections.  Start by plugging in a USB keyboard and mouse.  In the figure below, a wireless keyboard transmitter was plugged in, but you can also use separate wired keyboard and mouse.

Next, plug in an HDMI cable with the other end attached to a display.  The TA may help you determine which display and HDMI cable to use.  We are ready to boot our RPi.  Attach the microUSB AC adapter and you should see the RPi's boot process on the display.

After a short time, the RPi will be booted into text mode.  Log into the RPi using your science.uoit.ca username and password.  At the command prompt, type 'startx' and hit enter to start graphical mode.

Once in graphical mode, take a few minutes to examine some of the application icons on the desktop, as well as applications available in the menu (which is accessible from the bottom left corner, similar to the start menu in Windows).

Double click the desktop icon 'IDLE' (not to be confused with 'IDLE3') to start the Python development environment.

## Running Python on the Raspberry Pi
IDLE is a relatively simple IDE for Python.  It doesn't have the capabilities of Visual Studio, but it will do for our purposes.  When you see:

```python
>>> 
```

This is the interactive Python shell.  It is a place where you can enter Python code directly, and have it execute immediately.  At the Python shell, type in the following (don't type the prompt):

```python
>>> 2 + 9
```

Sometimes, this interactive mode is what you want and sometimes you want to edit a program in a file.  Let's create a program in a file.  In the 'File' menu, choose 'New Window' to open a text editor.  In the window that appears, type in the following test program:

```python
print("testing 1 2 3...")
```

Choose 'File', 'Save As' and save this file in ~/Documents with the name basics.py.  Hit F5 to run your program, and you should see the output 'testing 1 2 3...' in the first IDLE window.  Spend a few minutes familiarizing yourself with the menu in the IDLE windows.  It has common text editor functionality, along with some basic programming environment features (e.g. Comment Out Region).

## Python Language Introduction
In this part of the lab, we'll experiment with some Python language features, under the assumption that you have previously written programs in C++.  First of all, let's consider variables and values.  In the Python shell, type in the following:

```python
>>> x = 8
>>> print(x)
8
>>> print(x * 2)
16
```

Notice that the results of the program were printed after each line?  Now, type in the following code into the text editor window:

```python
x = 8
print(x)
print(x * 2)
```

Save this program over your basics.py program from part 2 and execute it with F5.  Notice that this program does not execute line-by-line, but executes the entire program when you hit F5.

Let's add some other variables to the end of our program:

```python
name = "Raspberry Pi"
length = 14.5
width = 7.25
```

Represented in our program are three different value types: integer, floating point, and string.  Let's print some values.  Add the following code to the end of the program:

```python
print("x: ")
print(x)
print("Name:", name)
print("width:",)
print(width)
print("length:" + str(length))
```

Save and run the program.  Notice what happened?  In some cases, spaces were added automatically by print, and in other cases a newline was added.  You'll need to be careful about that if you want precise output in Python.  To suppress the spaces, follow the pattern for length above.  To suppress the newline, add the extra comma on the right side, like with the following line:

```python
print("width:",)
```

Now, let's try out conditionals.

```python
x = 8
if x < 10:
   print("x is small")
elif X < 20:
   print("x is medium")
else:
   print("x is large")
```

Try experimenting with different values for X until you understand how the conditional works.

Note:  Python uses space to structure code blocks.  In C++, you surrounded your code block in { and }, but in Python you indent your code block.  Be sure to be consistent with your spacing or you might confuse Python if code is inside or outside of a block.

Let's examine a while loop now.  Again, the major difference with C++ is the use of indentation to show what code is inside the loop.

```python
x = 8
while x > 0:
   print(x)
   x = x - 1
```

In Python, for loops work using lists so let's examine those in more detail before we learn the for loop syntax.  A list is merely a collection of elements of the same type surrounded by square brackets (e.g. `[1, 2, 3, 4, 5]`).  We can loop over any list:

```python
names = ["Bob", "Sally", "Kunal", "Ahmed", "Carla"]
for name in names:
   print(name)
```

There is a function `range()` that can generate a list, that is very useful in for loops.  You can pass 3 values to range:  the minimum, the maximum, and the step size, and `range()` will generate a list that starts at the minimum value (default 0), proceeds to the next by adding the step size (default 1), until the maximum value is reached.  The maximum value is not included in the resulting list.  Try out `range()` a bit in the Python shell:
	
```python
range(10)
range(5, 10)
range(5, 15, 2)
```

We are finally ready to use a familiar form of for loop:

```python
for val in range(0, 20):
   print val
```

There is a lot more to Python, but this should be enough to get us through these labs.
