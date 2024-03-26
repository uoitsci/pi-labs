+++
draft = false
title = "ARM assembler in Raspberry Pi"
Weight = 10
+++

Machine language is built up from discrete statements or instructions implemented by a particular processor. ARM is a family of instruction set architectures for computer processors and is the one used by the processor of the Raspberry Pi. The machine language is interpreted by the computer in term of binary codes. Binary code is what a computer can run. It is composed of instructions, that are encoded in a binary representation (such encodings are documented in the ARM manuals). You could write binary code encoding instructions but that would be painstaking. So instead we will write assembler language. Assembler language is just a thin syntax layer on top of the binary code.

Since the computer cannot run assembler we have to get binary code from it. We use a tool called, well, assembler to assemble the assembler code into a binary code that we can run. The tool to do this is called as. In particular GNU Assembler, which is the assembler tool from the GNU project, sometimes it is also known as gas for this reason. This is the tool we will use to assemble our programs.

# Our first ARM programs
We have to start with something, so we will start with a ridiculously simple program which does nothing but return an error code.

{{< highlight "ARM Assembly" >}}
.text             /* -- Code section */
.global main      /* 'main' is our entry point and must be global */
.func main        /* 'main' is a function */

main:             /* This is main */
       mov w0,#2  /* Put a 2 inside the register w0 */
       ret        /* Return from main */
{{< /highlight >}}

Create a file called first.s and write the contents shown above. Save it.

To assemble the file type the following command (write what comes after `$`).

{{< highlight bash >}}
$ as -o first.o first.s
{{< /highlight >}}

This will create a first.o. Now link this file to get an executable.

{{< highlight bash >}}
$ gcc -o first first.o
{{< /highlight >}}

If everything goes as expected you will get a first file. This is your program. Run it.

{{< highlight bash >}}
$ ./first
{{< /highlight >}}

It should do nothing. Yes, it is a bit disappointing, but it actually does something. Get its error code this time.

{{< highlight bash >}}
$ ./first ; echo $?
2
{{< /highlight >}}

Great! That error code of 2 is not by chance, it is due to that #2 in the assembler code.

# Well, what happened?
We cheated a bit just to make things a bit easier. We wrote a C main function in assembler which only does `return 2;`. This way our program is easier since the C runtime handled initialization and termination of the program for us. I will use this approach all the time.

Let's review every line of our minimal assembler file.

These are comments. Comments are enclosed in `/*` and `*/`. Use them to document your assembler as they are ignored. As usual, do not nest `/*` and `*/` inside `/*` because it does not work.

{{< highlight "ARM Assembly" >}}
.global main /* 'main' is our entry point and must be global */
{{< /highlight >}}

This is a directive for GNU Assembler. A directive tells GNU Assembler to do something special. They start with a dot (`.`) followed by the name of the directive and some arguments. In this case we are saying that main is a global name. This is needed because the C runtime will call main. If it is not global, it will not be callable by the C runtime and the linking phase will fail.

{{< highlight "ARM Assembly" >}}
.func main   /* 'main' is a function */
{{< /highlight >}}

Another GNU assembler directive. Here we state that main is a function. This is important because an assembler program usually contains instructions (i.e. code) but may also contain data. We need to explicitly state that main actually refers to a function, because it is code.

{{< highlight "ARM Assembly" >}}
main:          /* This is main */
{{< /highlight >}}

Every line in GNU Assembler that is not a directive will always be like label: instruction. We can omit `label:` and instruction (empty and blank lines are ignored). A line with only `label:`, applies that label to the next line (you can have more than one label referring to the same thing this way). The instruction part is the ARM assembler language itself. In this case we are just defining main as there is no instruction.

{{< highlight "ARM Assembly" >}}
mov w0, #2 /* Put a 2 inside the register w0 */
{{< /highlight >}}
    
Whitespace is ignored at the beginning of the line, but the indentation suggests visually that this instruction belongs to the main function.
This is the mov instruction which means move. We move a value `2` to the register `w0`. In the next chapter we will see more about registers, do not worry now. Yes, the syntax is awkward because the destination is actually at left. In ARM syntax it is always at left so we are saying something like move to register `w0` the immediate value `2`. We will see what immediate value means in ARM in the next chapter, do not worry again.

In summary, this instruction puts a `2` inside the register `w0` (this effectively overwrites whatever register `w0` may have at that point).

And the error code? Well, the result of main is the error code of the program and when leaving the function such result must be stored in the register `w0`, so the `mov` instruction performed by our main is actually setting the error code to `2`.

# Registers

At its core, a processor in a computer is nothing but a powerful calculator. Calculations can only be carried using values stored in very tiny memories called registers. The ARM processor in a Raspberry Pi has 16 integer registers and 32 floating point registers. A processor uses these registers to perform integer computations and floating point computations, respectively. We will put floating registers aside for now and eventually we will get back to them in a future installment. Let’s focus on the integer registers.

Those 16 integer registers in ARM have names from `w0` to `w15`. They can hold 32 bits. Of course these 32 bits can encode whatever you want. That said, it is convenient to represent integers in two's complement as there are instructions which perform computations assuming this encoding. So from now, except noted, we will assume our registers contain integer values encoded in two's complement.

# Instructions

Some of the instructions for the ARM assembler are different from the ones for x86 covered in lecture. One such difference is that many instructions now have an explicit destination register, rather an implicit one. For example, the addition instruction `add` takes 3 operands instead of 2 – the first is the destination register where the result will be stored, and the next two operands are the numbers you want to add together, e.g. if you want to sore the result of `w1 + w2` in the register `w0`, you would use:

{{< highlight "ARM Assembly" >}}
add, w0, w1, w2
{{< /highlight >}}

# Branching

In x86, the commands used to branch use the “jump” nomenclature, and as such usually begin with `j`, or use `jmp` for an unconditional branch. With ARM assembly, you branch with the instruction `b` followed by an optional condition. You still use the `cmp` instruction to compare two numbers, it’s just the branch statement that changes. For example, an unconditional jump to the label `exit` would use the command:

{{< highlight "ARM Assembly" >}}
b exit
{{< /highlight >}}

Whereas a jump to the label `top`, based on whether or not the value in register `w0` was less than 0 would use the commands:

{{< highlight "ARM Assembly" >}}
cmp w0, #0
blt top
{{< /highlight >}}

The following table shows the different conditions for x86 and ARM (we’ll stick to signed number comparisons)

| Condition                    | x86 Instruction | ARM Instruction |
| ---------------------------- | --------------- | --------------- |
| equal (==)                   | je              | beq             |
| not equal (!=)               | jne             | bne             |
| less than (<)                | jl              | blt             |
| less than or equal to (≤)    | jle             | ble             |
| greater than (>)             | jg              | bgt             |
| greater than or equal to (≥) | jge             | bge             |

# Exercise #1

Almost every processor can do some basic arithmetic computations using the integer registers. So do ARM processors.  You can **add** two registers. Let's retake our example from above:

{{< highlight "ARM Assembly" >}}
/* -- sum01.s */
.global main
.func main
 
main:
    mov w1, #3      /* w1 ← 3 */
    mov w2, #4      /* w2 ← 4 */
    add w0, w1, w2  /* w0 ← w1 + w2 */
    ret
{{< /highlight >}}

If we compile and run this program the error code is, as expected, `7`.

# Exercise #2

Write an assembly language program that loops through the numbers 1 through 10, adding each to a total, and exiting the loop as appropriate. Once the loop is complete, the total value should be returned, just as we have in the previous exercise and above examples such that it can be examined from the command line. In this example, the result should be 55 (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 = 55).
